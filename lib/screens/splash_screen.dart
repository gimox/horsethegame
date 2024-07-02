/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'package:horsethegame/components/utils/bsckground_util.dart';
import 'package:horsethegame/my_game.dart';

class SplashScreen extends Component with HasGameRef<MyGame>, TapCallbacks {
  @override
  Future<void> onLoad() async {

    addAll([
      BackgroundUtil(const Color(0xff282828)),
      TextBoxComponent(
        text: '[Router demo]',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0x66ffffff),
            fontSize: 16,
          ),
        ),
        align: Anchor.center,
        size: game.canvasSize,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  Future<void> onTapUp(TapUpEvent event) async {
    await game.worldLevel.startGame();
    game.router.pushNamed('play');
  }
}


