/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
import 'package:horsethegame/my_game.dart';

class LevelBlockHud extends PositionComponent with HasGameRef<MyGame> {
  double positionY;
  double spriteHealthSize;

  LevelBlockHud({
    this.positionY = 10,
    this.spriteHealthSize = 22,
    super.children,
    super.priority,
  });

  late final TextComponent levelTextComponent;
  late SpriteComponent levelImage;

  Future<void> addLevelText() async {
    levelTextComponent = TextComponent(
      text: 'Level:',
      position: Vector2(
          game.hud.healthBlockHud.healthTextComponent.size.x +
              game.hud.healthBlockHud.healthTextComponent.position.x +
              (spriteHealthSize * game.playerData.health.value + 30),
          positionY),
      textRenderer: regular,
    );
    await add(levelTextComponent);

    addLevelImage();
  }

  Future<void> addLevelImage() async {
    if (game.playerData.level.value > GameVars.levelNames.length ||
        game.playerData.level.value <= 0) {
      return;
    }

    String imageFileName = game.playerData.level.value.toString();

    if (game.playerData.level.value < 10) {
      imageFileName = '0${game.playerData.level.value}';
    }

    levelImage = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('Menu/Levels/$imageFileName.png'),
        srcSize: Vector2(32, 32),
      ),
      position: Vector2(
        levelTextComponent.position.x + levelTextComponent.size.x + 2,
        levelTextComponent.position.y + (levelTextComponent.size.y / 2) - 7,
      ),
    );
    await add(levelImage);
  }

  Future<void> replaceLevelImage() async {
    //    levelTextComponent.text = 'Level: ${game.playerData.level.value}';
    levelImage.removeFromParent();
    await addLevelImage();
  }
}
