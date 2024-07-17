/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
  late TextComponent timerTimeComponent;
  late final Effect fx;

  @override
  FutureOr<void> onLoad() {
    _setFx();

    game.gameTimer.countDownTime.addListener(_onTimerChange);
    game.gameState.addListener(_onGameState);

    return super.onLoad();
  }

  _setFx() {
    fx = ScaleEffect.to(
      Vector2.all(1.1),
      EffectController(
        duration: 0.3,
        alternate: true,
        infinite: true,
      ),
    );
  }

  _onGameState() {
    if (game.gameState.value == GameState.hurryUpTime) {
      timerTextComponent.text = "HURRY UP";
      timerTextComponent.textRenderer = regularRed;
      timerTextComponent.add(fx);
    } else if (game.gameState.value == GameState.resetTime) {
      timerTextComponent.text = "TIME:";
      timerTextComponent.textRenderer = regular;
      if (timerTextComponent.hasChildren) {
        timerTextComponent.remove(fx);
      }
    }
  }

  void _onTimerChange() {
    timerTimeComponent.text = game.gameTimer.countDownTime.value.toString();
  }

  Future<void> addTimer() async {
    await _addTextTimer();

    timerTimeComponent = TextComponent(
        text: 'TIME:',
        anchor: Anchor.topRight,
        position: Vector2(
            timerTextComponent.position.x + timerTextComponent.size.x - 10,
            positionY),
        textRenderer: regular,
        children: []);
    await add(timerTimeComponent);
  }

  Future<void> _addTextTimer() async {
    timerTextComponent = TextComponent(
        text: 'TIME:',
        anchor: Anchor.topRight,
        position: Vector2(game.size.x - 150, positionY),
        textRenderer: regular,
        children: []);
    await add(timerTextComponent);
  }
}
