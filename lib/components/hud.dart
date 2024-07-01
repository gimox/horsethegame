import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:horsethegame/app/app_theme.dart';
import 'package:horsethegame/my_game.dart';
import 'package:horsethegame/overlays/pause_menu.dart';

class Hud extends PositionComponent with HasGameRef<MyGame> {
  late final TextComponent scoreTextComponent;
  late final TextComponent healthTextComponent;
  late final TextComponent levelTextComponent;

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

    levelTextComponent = TextComponent(
      text: 'Level: ${game.playerData.level.value}',
      position: Vector2.all(10),
      textRenderer: regular,
    );
    await add(levelTextComponent);



    healthTextComponent = TextComponent(
      text: 'x${game.playerData.health.value}',
      position:
          Vector2(levelTextComponent.size.x + levelTextComponent.width, 10),
      textRenderer: regular,
    );
    await add(healthTextComponent);

    scoreTextComponent = TextComponent(
      text: 'Score: ${game.playerData.score.value}',
      anchor: Anchor.topRight,
      position: Vector2(game.size.x - 10, 10),
      textRenderer: regular,
    );
    await add(scoreTextComponent);

    game.playerData.score.addListener(onScoreChange);
    game.playerData.health.addListener(onHealthChange);
    game.playerData.level.addListener(onLevelChange);

    final Image pauseImage = await game.images.load('Menu/Buttons/Play.png');

    final pauseButton = SpriteButtonComponent(
      onPressed: () {

        game.router.pushOverlay(PauseMenu.id);
        //game.pauseEngine();
       // game.overlays.add(PauseMenu.id);
      },
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
  }

  void onLevelChange() {
    levelTextComponent.text = 'Level: ${game.playerData.level.value}';
  }
}
