/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:horsethegame/my_game.dart';

import 'level.dart';

class WorldLevel extends Component with HasGameRef<MyGame> {
  WorldLevel();

  FutureOr<void> loadNextLevel() async {
    removeWhere((component) => component is Level);

    if (game.currentLevelIndex < game.levelNames.length - 1) {
      game.currentLevelIndex++;
    } else {
      game.currentLevelIndex = 0;
    }

    await loadLevel();
  }

  FutureOr<void> loadLevel() async {
    if (game.currentLevelIndex == 0) {
      _prepareGameLiveScore();
    }

    await Future.delayed(const Duration(seconds: 1), () async {
      Level world = Level(
        player: game.player,
        levelName: game.levelNames[game.currentLevelIndex],
      );

      game.cam = CameraComponent.withFixedResolution(
        world: world,
        width: game.fixedResolution.x,
        height: game.fixedResolution.y,
        hudComponents: game.hudComponents,
      );

      game.cam.viewfinder.anchor = Anchor.topLeft;
      game.cam.priority = 1;

      await addAll([game.cam, world]);
    });
  }

  void _prepareGameLiveScore() {
    game.lives = game.startLives;
    game.score = 0;
  }
}
