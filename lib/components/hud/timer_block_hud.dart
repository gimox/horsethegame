/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/my_game.dart';

class TimerBlockHud extends PositionComponent
    with HasGameRef<MyGame>, Notifier {
  double positionY;

  TimerBlockHud({
    this.positionY = 10,
    super.children,
    super.priority,
  });

  late TextComponent timerTextComponent;

  Future<void> addTimer() async {
    timerTextComponent = TextComponent(
      text: 'TIME: -',
      anchor: Anchor.topRight,
      position: Vector2(game.size.x - 150, positionY),
      textRenderer: regular,
    );
    await add(timerTextComponent);
  }
}
