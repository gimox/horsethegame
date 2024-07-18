/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/rendering.dart';
import 'package:horsethegame/components/utils/bsckground_util.dart';
import 'package:horsethegame/my_game.dart';

class SplashWorld extends World with HasGameRef<MyGame> {
  late final SpriteComponent titleImage;
  late final SpriteButtonComponent spriteButton;

  final double yStartPos = 20;
  final double buttonSpaceSize = 10;

  @override
  FutureOr<void> onLoad() async {
    await _addGameTitle();
    await _addButtonStart();
    await _addButtonSettings();
/*
    final img = game.images.fromCache('Menu/splash.png');

    final s = SpriteComponent(
        sprite: Sprite(
      img,
      srcSize: Vector2(640, 360),
    ),
      position: Vector2.zero(),

    );

    add(s);

 */

    return super.onLoad();
  }

  Future<void> _addGameTitle() async {
    final  img = game.images.fromCache('Menu/title.png');
    titleImage = SpriteComponent(
        sprite: Sprite(
            img,
          // srcSize: Vector2(1024, 277),
        ),
        anchor: Anchor.topLeft,
        position: Vector2((game.size.x / 2) - (400 / 2), yStartPos),
        size: Vector2(400, 173));

    await add(titleImage);
  }

  Future<void> _addButtonStart() async {
    spriteButton = SpriteButtonComponent(
      button: Sprite(
        game.images.fromCache('Menu/Buttons/button_start.png'),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(
          titleImage.position.x + (titleImage.size.x / 2) - (150 / 2),
          titleImage.position.y + titleImage.size.y + 5),
      size: Vector2(150, 50),
      onPressed: _onPressed,
    );

    await add(spriteButton);
  }

  Future<void> _addButtonSettings() async {
    final SpriteButtonComponent b = SpriteButtonComponent(
      button: Sprite(
        game.images.fromCache('Menu/Buttons/button_settings.png'),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(spriteButton.x, spriteButton.y + 50 + buttonSpaceSize),
      size: Vector2(150, 50),
      onPressed: _onPressed,
    );

    await add(b);
  }

  void _onPressed() {
    game.router.pushNamed('play');
    game.gamePlay.startGame(); //await removed
  }
}


class SplashScreen extends Component with HasGameRef<MyGame> {
 // late CameraComponent cam;

  @override
  Future<void> onLoad() async {
    World world = SplashWorld();
    game.sound.stop();
    game.sound.playBgm('menu');

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


}


