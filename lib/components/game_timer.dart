/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:horsethegame/my_game.dart';

class GameTimer extends Component with HasGameRef<MyGame> {
  GameTimer({super.priority, super.children});

  late Timer interval;

  late ValueNotifier<int> countDownTime;

  @override
  FutureOr<void> onLoad() {
    countDownTime = ValueNotifier<int>(0);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    interval.update(dt);
   /*
    if (kDebugMode) {
        print('* game timer: ${countDownTime.value}');
    }

    */
    super.update(dt);
  }

  Future<void> loadTimer({int startTime = 0}) async {
    countDownTime.value = startTime;

    interval = Timer(
      1,
      onTick: () => countDownTime.value > 0 ? countDownTime.value -= 1 : 0,
      repeat: true,
    );
  }
}
