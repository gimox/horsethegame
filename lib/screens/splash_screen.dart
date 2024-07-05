/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/components/utils/bsckground_util.dart';
import 'package:horsethegame/my_game.dart';



class SplashWorld extends World  with HasGameRef<MyGame>{
  @override
  FutureOr<void> onLoad() async {
    final TextBoxComponent t = TextBoxComponent(
      text: '[START GAME]',
    //  position: Vector2(640 / 2 - 150, 360 / 2 - 50),
      textRenderer: big,
      align: Anchor.center,
    //  size: Vector2(300, 100),
      size: game.canvasSize
    );

    await add(t);
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
}

class SplashScreen extends Component with HasGameRef<MyGame>, TapCallbacks {
  late CameraComponent cam;



  @override
  Future<void> onLoad() async {
    World world = SplashWorld();
    game.sound.playBgm('menu');

    cam = CameraComponent.withFixedResolution(
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
  Future<void> onTapUp(TapUpEvent event) async {
    game.router.pushNamed('play');
    await game.gamePlay.startGame();
  }
}
