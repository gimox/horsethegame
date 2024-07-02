/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:horsethegame/components/utils/bsckground_util.dart';
import 'package:horsethegame/my_game.dart';
import 'package:flutter/rendering.dart';


class GameOverScreen extends Component with TapCallbacks, HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      BackgroundUtil(const Color(0xff282828)),
      TextBoxComponent(
        text: '[GAME OVER]',
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
  void onTapUp(TapUpEvent event) {
    game.router.pushReplacementNamed('splash');
  }
}
