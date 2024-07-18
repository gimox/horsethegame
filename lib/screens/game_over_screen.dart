/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:horsethegame/components/utils/bsckground_util.dart';
import 'package:horsethegame/my_game.dart';

class GameOverWorld extends World with HasGameRef<MyGame> {
  final double yStartPos = 20;

  @override
  void onMount() {
    game.gameTimer.interval.stop();
    game.sound.stop();
    game.sound.playBgm('gameOver');

    super.onMount();
  }

  @override
  Future<void> onLoad() async {
    final Image img = game.images.fromCache('Menu/gameover.png');

    final s = SpriteComponent(
      sprite: Sprite(img),
      anchor: Anchor.topLeft,
      position: Vector2((game.size.x / 2) - (400 / 2), game.size.y / 2 - 108 / 2),
      size: Vector2(400, 108),
    );

    add(s);
  }
}

class GameOverScreen extends PositionComponent
    with HasGameRef<MyGame>, TapCallbacks {
  late SpriteComponent s;

  @override
  Future<void> onLoad() async {
    World world = GameOverWorld();

    final CameraComponent cam = CameraComponent.withFixedResolution(
      world: world,
      width: game.fixedResolution.x,
      height: game.fixedResolution.y,
    )..viewfinder.anchor = Anchor.topLeft;

    await addAll([
      cam,
      world,
      BackgroundUtil(const Color(0xff282828)),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) {
    game.gamePlay.splashRoute();
  }
}
