/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:horsethegame/components/level.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
import 'package:horsethegame/my_game.dart';

class GamePlay extends Component with HasGameRef<MyGame> {
  GamePlay();

  // call this to only on start game
  FutureOr<void> startGame() async {
    if (kDebugMode) {
      print('* startGame call');
    }

    removeWhere((component) => component is Level);
    _initGame();

    await _loadLevel();
  }

  // call to change level
  FutureOr<void> loadNextLevel() async {
    removeWhere((component) => component is Level);

    if (game.currentLevelIndex < game.levelNames.length - 1) {
      game.currentLevelIndex++;
    } else {
      // no more level
      game.router.pushReplacementNamed('win');
    }

    await _loadLevel();
  }

  FutureOr<void> _loadLevel() async {
    //   if (game.currentLevelIndex == 0) _initGame();

    // needed to display level in HUD
    game.playerData.level.value = game.currentLevelIndex + 1;

    if (kDebugMode) {
      print('');
      print('');
      print('-------------------------------------------------');
      print('current index level: ${game.currentLevelIndex}');
      print('player level: ${game.playerData.level.value}');
      print('player score: ${game.playerData.score.value}');
      print('player health: ${game.playerData.health.value}');
      print('-------------------------------------------------\n');
    }

    await Future.delayed(const Duration(seconds: 1), () async {
      game.worldGameLevel = Level(
        player: game.player,
        levelName: game.levelNames[game.currentLevelIndex],
      );

      game.cam = CameraComponent.withFixedResolution(
        world: game.worldGameLevel,
        width: game.fixedResolution.x,
        height: game.fixedResolution.y,
        hudComponents: game.hudComponents,
      );

      game.cam.viewfinder.anchor = Anchor.topLeft;
      game.cam.priority = 1;

      await addAll([game.cam, game.worldGameLevel]);
    });
  }

  void _initGame() {
    if (kDebugMode) print('* _initGame call');

    game.currentLevelIndex = 0;
    game.playerData.health.value = game.playerData.startHealth;
    game.playerData.score.value = game.playerData.startScore;
    game.playerData.level.value = game.playerData.startLevel;
  }

  void removeHealth() {
    if (game.playerData.health.value > 0) {
      game.playerData.health.value -= 1;
    } else {
      game.playerData.health.value = 0;
    }
  }

  Future<void> onChangeLevel() async {
    const waitToChangeDuration =
        Duration(seconds: GameVars.changeLevelDuration);
    await Future.delayed(waitToChangeDuration, () => loadNextLevel());
  }

  Future<void> onGameOver() async {
    game.router.pushNamed('gameOver');
  }
}
