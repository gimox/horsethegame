/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:horsethegame/components/hud/buttons_block_hud.dart';
import 'package:horsethegame/components/hud/level_block_hud.dart';
import 'package:horsethegame/components/hud/health_block_hud.dart';
import 'package:horsethegame/components/hud/score_block_hud.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
import 'package:horsethegame/my_game.dart';

class Hud extends PositionComponent with HasGameRef<MyGame> {
  final double spriteHealthSize = GameVars.hudPlayerHealthSize;
  final double hudPositionY = GameVars.hudPositionY;

  late final HealthBlockHud healthBlockHud;
  late final LevelBlockHud levelBlockHud;
  late final ButtonsBlockHud buttonsBlockHud;
  late final ScoreBlockHud scoreBlockHud;

  Hud({super.children, super.priority});

  @override
  Future<void> onLoad() async {
    healthBlockHud = HealthBlockHud(
      priority: 1,
      positionY: hudPositionY,
      spriteHealthSize: spriteHealthSize,
    );
    add(healthBlockHud);

    levelBlockHud = LevelBlockHud(
      priority: 1,
      positionY: hudPositionY,
      spriteHealthSize: spriteHealthSize,
    );
    add(levelBlockHud);

    buttonsBlockHud = ButtonsBlockHud(
      priority: 1,
      positionY: hudPositionY,
      spriteHealthSize: spriteHealthSize,
    );
    add(buttonsBlockHud);

    scoreBlockHud = ScoreBlockHud(
      priority: 1,
      positionY: hudPositionY,
    );
    add(scoreBlockHud);

    await healthBlockHud.addHealthTextComponent();
    await healthBlockHud.addSpriteHealth();
    await levelBlockHud.addLevelText();
    await scoreBlockHud.addScoreTextComponent();
    await buttonsBlockHud.addPauseImage();
    await buttonsBlockHud.addSoundImage();

    game.playerData.health.addListener(onHealthChange);
    game.playerData.level.addListener(onLevelChange);
    game.playerData.score.addListener(onScoreChange);
  }

  void onScoreChange() {
    scoreBlockHud.scoreTextComponent.text = '${game.playerData.score.value}';
  }

  void onHealthChange() {
    healthBlockHud.healthTextComponent.text =
        'x${game.playerData.health.value}';

    healthBlockHud.updateSpriteHealth();

    if (game.playerData.health.value == 0) {
      game.gamePlay.onGameOver();
    }
  }

  void onLevelChange() {
    levelBlockHud.replaceLevelImage();
  }
}
