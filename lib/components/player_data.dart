/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flutter/foundation.dart';

class PlayerData {
  final int startHealth;
  final int startScore;
  final int startLevel;

  PlayerData(this.startHealth, this.startScore, this.startLevel);

  late ValueNotifier<int> score;
  late ValueNotifier<int> health;
  late ValueNotifier<int> level;

  void initNotifier() {
    score = ValueNotifier<int>(startScore);
    health = ValueNotifier<int>(startHealth);
    level = ValueNotifier<int>(startLevel);
  }

  void removeHealth() {
    if (health.value > 0) {
      health.value -= 1;
    } else {
      health.value = 0;
    }
  }
}
