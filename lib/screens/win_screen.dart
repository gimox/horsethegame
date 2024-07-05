
/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/components/utils/bsckground_util.dart';
import 'package:horsethegame/my_game.dart';
import 'package:flutter/rendering.dart';


class WinScreen extends Component with TapCallbacks, HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      BackgroundUtil(const Color(0xff282828)),
      TextBoxComponent(
        text: '[YOU WIN]',
        textRenderer: big,
        align: Anchor.center,
        size: game.canvasSize,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) {
    game.gamePlay.splashRoute();
  }
}
