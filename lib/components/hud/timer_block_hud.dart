/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
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
  late final Effect fx;

  @override
  FutureOr<void> onLoad() {
    fx = ScaleEffect.to(
      Vector2.all(1.1),
      EffectController(
        duration: 0.3,
        alternate: true,
        infinite: true,
      ),
    );

    game.gameTimer.countDownTime.addListener(onTimerChange);

    return super.onLoad();
  }

  Future<void> addTimer() async {
    timerTextComponent = TextComponent(
        text: 'TIME: -',
        anchor: Anchor.topRight,
        position: Vector2(game.size.x - 150, positionY),
        textRenderer: regular,
        children: []);
    await add(timerTextComponent);
  }

  void onTimerChange() {
    late String prefix =
    game.gameTimer.countDownTime.value < GameVars.hurryUpStartTime
        ? 'HURRY UP:'
        : 'TIME:';


    if(game.gameTimer.countDownTime.value == 290 ){
      timerTextComponent.textRenderer = regularRed;
      timerTextComponent.add(fx);
    }
/*
    if(game.gameTimer.countDownTime.value == 285 ){
      timerTextComponent.textRenderer = regular;
      timerTextComponent.remove(fx);
    }

 */

    timerTextComponent.text =
    '$prefix ${game.gameTimer.countDownTime.value.toString()}';
  }
}
