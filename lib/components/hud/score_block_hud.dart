/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
import 'package:horsethegame/my_game.dart';

class ScoreBlockHud extends PositionComponent with HasGameRef<MyGame> {
  double positionY;
  double spriteSize;

  ScoreBlockHud({
    this.spriteSize = 32,
    this.positionY = 10,
    super.children,
    super.priority,
  });


  late final Image spriteImage;

  late final TextComponent scoreTextComponent;

  void _getImages() {
    spriteImage = game.images.fromCache(
        '${GameVars.itemsDir}/${GameVars.fruitsDir}/${GameVars.hudFruitsItem}');
  }

  Future<void> addScoreTextComponent() async {

    scoreTextComponent = TextComponent(
      text: '${game.playerData.score.value}',
      anchor: Anchor.topRight,
      position: Vector2(game.size.x - (20), positionY),
      textRenderer: regular,
    );
    await add(scoreTextComponent);
    await _getSprite();
  }


  Future<void>  _getSprite() async {
    _getImages();
    final spriteFruit =  SpriteComponent(
      sprite: Sprite(
        spriteImage,
        srcSize: Vector2(32, 32),
      ),
      size: Vector2(spriteSize, spriteSize),
      anchor: Anchor.topCenter,
      position: Vector2(
          game.size.x - 10,
          scoreTextComponent.position.y - 2),
    );

    await add(spriteFruit);
  }
}
