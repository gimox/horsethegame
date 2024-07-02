import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:horsethegame/app/app_theme.dart';
import 'package:horsethegame/components/game_vars.dart';
import 'package:horsethegame/my_game.dart';
import 'package:horsethegame/overlays/pause_menu.dart';

class Hud extends PositionComponent with HasGameRef<MyGame> {
  late final TextComponent scoreTextComponent;
  late final TextComponent healthTextComponent;
  late final TextComponent levelTextComponent;
  late final SpriteComponent spriteHealthComponent;
  late final List<SpriteComponent> spriteHealthList;
  late final Image spriteImage;
  late final Image pauseImage;

  double spriteHealthSize = 22;

  Hud({super.children, super.priority});

  @override
  void onRemove() {
    //all object are removed, but not reloaded, uncoment when fixed.

    // game.playerData.score.removeListener(onScoreChange);
    // game.playerData.health.removeListener(onHealthChange);
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    spriteHealthList = [];

    // evaluate hud images
    _getImages();

    await _addHealthTextComponent();
    await _addSpriteHealth();
    await _addLevelText();
    await _addScoreTextComponent();
    await _addPauseImage();
  }

  void _getImages() {
    pauseImage = game.images.fromCache('Menu/Buttons/Play.png');
    spriteImage = game.images.fromCache(
        '${GameVars.charactersDir}/${game.player.character}/Idle (32x32)${GameVars.charactersImgFileExt}');
  }

  Future<void> _addHealthTextComponent() async {
    healthTextComponent = TextComponent(
      text: 'x${game.playerData.health.value}',
      position: Vector2.all(10),
      textRenderer: regular,
    );
    await add(healthTextComponent);

    game.playerData.health.addListener(onHealthChange);
  }

  Future<void> _addLevelText() async {
    levelTextComponent = TextComponent(
      text: 'Level: ${game.playerData.level.value}',
      position: Vector2(
          healthTextComponent.size.x +
              healthTextComponent.position.x +
              (spriteHealthSize * game.playerData.health.value + 30),
          10),
      textRenderer: regular,
    );
    await add(levelTextComponent);

    game.playerData.level.addListener(onLevelChange);
  }

  Future<void> _addScoreTextComponent() async {
    scoreTextComponent = TextComponent(
      text: 'Score: ${game.playerData.score.value}',
      anchor: Anchor.topRight,
      position: Vector2(game.size.x - 10, 10),
      textRenderer: regular,
    );
    await add(scoreTextComponent);

    game.playerData.score.addListener(onScoreChange);
  }

  Future<void> _addSpriteHealth() async {
    for (int i = 0; i < game.playerData.health.value; i++) {
      spriteHealthList.add(
        SpriteComponent(
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
        ),
      );
    }

    await addAll(spriteHealthList);
  }

  Future<void> _addPauseImage() async {
    final pauseButton = SpriteButtonComponent(
      onPressed: () => game.router.pushOverlay(PauseMenu.id),
      button: Sprite(
        pauseImage,
        srcSize: Vector2.all(32),
        srcPosition: Vector2(0, 0),
      ),
      size: Vector2.all(32),
      anchor: Anchor.topCenter,
      position: Vector2(game.size.x / 2, 10),
    );

    await add(pauseButton);
  }

  void onScoreChange() {
    scoreTextComponent.text = 'Score: ${game.playerData.score.value}';
  }

  void onHealthChange() {
    healthTextComponent.text = 'x${game.playerData.health.value}';
    _updateSpriteHealth();
  }

  void onLevelChange() {
    levelTextComponent.text = 'Level: ${game.playerData.level.value}';
  }

  void _updateSpriteHealth() {
    if (spriteHealthList.length > game.playerData.health.value) {
      // remove
      if (kDebugMode) {
        print('-> remove');
      }
      spriteHealthList.last.removeFromParent();
      spriteHealthList.removeLast();

      if (kDebugMode) {
        print('-> ${spriteHealthList.length}');
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
      _addSpriteHealth();
    }

    if (game.playerData.health.value == 0){
      game.router.pushNamed('gameOver');
    }
  }

  void _blinkSpriteHealth() {
    if (kDebugMode) {
      print('-> add blink effect to sprite health');
    }
    SpriteComponent newSprite = spriteHealthList.last;

    spriteHealthList.last.removeFromParent();

    newSprite.add(
      OpacityEffect.to(
        0.2,
        EffectController(duration: 0.75, infinite: true),
      ),
    );
    add(newSprite);
  }
}
