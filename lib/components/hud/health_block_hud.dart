/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
import 'package:horsethegame/my_game.dart';

class HealthBlockHud extends PositionComponent with HasGameRef<MyGame> {
  double positionY;
  double spriteHealthSize;

  HealthBlockHud({
    this.positionY = 10,
    this.spriteHealthSize = 22,
    super.children,
    super.priority,
  });

  late final TextComponent healthTextComponent;
  List<SpriteComponent> spriteHealthList = [];
  late final Image spriteImage;

  @override
  FutureOr<void> onLoad() {
    _getImages();
    game.playerData.health.addListener(_onHealthChange);

    return super.onLoad();
  }

  void _onHealthChange() async {
    healthTextComponent.text = 'x${game.playerData.health.value}';

    await updateSpriteHealth();
  }

  void _getImages() {
    spriteImage = game.images.fromCache(
        '${GameVars.charactersDir}/${game.player.character}/Idle (${GameVars.playerSpriteSize.toInt()}x${GameVars.playerSpriteSize.toInt()})${GameVars.charactersImgFileExt}');
  }

  Future<void> addHealthTextComponent() async {
    healthTextComponent = TextComponent(
      text: 'x${game.playerData.health.value}',
      position: Vector2.all(positionY),
      textRenderer: regular,
    );

    await add(healthTextComponent);
    return;
  }

  SpriteComponent _getSprite(int i) {
    return SpriteComponent(
      sprite: Sprite(
        spriteImage,
        srcSize: Vector2(32, 32),
      ),
      size: Vector2(spriteHealthSize, spriteHealthSize),
      anchor: Anchor.topCenter,
      position: Vector2(
          healthTextComponent.position.x +
              healthTextComponent.size.x +
              (22 / 2) +
              (i * spriteHealthSize),
          healthTextComponent.position.y - 2),
    );
  }

  Future<void> addSpriteHealth() async {
    for (int i = 0; i < game.playerData.health.value; i++) {
      spriteHealthList.add(_getSprite(i));
    }
    await addAll(spriteHealthList);

    return;
  }

  Future<void> updateSpriteHealth() async {
    if (spriteHealthList.length > game.playerData.health.value) {
      // remove
      if (kDebugMode) {
        print('-> remove');
      }
      spriteHealthList.last.removeFromParent();
      spriteHealthList.removeLast();

      if (kDebugMode) {
        print('-> health value ${spriteHealthList.length}');
      }
      if (spriteHealthList.length == 1) _blinkSpriteHealth();
    } else {
      // add
      // this can be to excessive...but it's called once at restart.
      if (kDebugMode) {
        print('-> add');
      }
      removeAll(spriteHealthList);
      spriteHealthList.clear();

      await addSpriteHealth();
    }
  }

  void _blinkSpriteHealth() {
    if (kDebugMode) {
      print('-> add blink effect to sprite health');
    }
    if (spriteHealthList.isNotEmpty) {
      SpriteComponent newSprite = spriteHealthList.last;

      newSprite.add(
        OpacityEffect.to(
          0.2,
          EffectController(duration: 0.75, infinite: true),
        ),
      );

      spriteHealthList.last.removeFromParent();
      add(newSprite);
    }
  }
}
