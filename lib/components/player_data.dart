/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flutter/foundation.dart';

class PlayerData {
  final int startHealth;
  final int startScore;
  final int levelHud;

  PlayerData(this.startHealth, this.startScore, this.levelHud);

  late final ValueNotifier<int> score;
  late final ValueNotifier<int> health;
  late final ValueNotifier<int> level;

  void initNotifier() {
    score = ValueNotifier<int>(startScore);
    health = ValueNotifier<int>(startHealth);
    level = ValueNotifier<int>(levelHud);
  }

  void removeHealth() {
    if (health.value > 0) {
      health.value -= 1;
    } else {
      health.value = 0;
    }
  }
}
