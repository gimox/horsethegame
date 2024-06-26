import 'package:flame/components.dart';
import 'package:horsethegame/app/app_theme.dart';
import 'package:horsethegame/my_game.dart';

//import 'package:flame/game.dart';

class Hud extends PositionComponent with HasGameRef<MyGame> {
  late final TextComponent scoreTextComponent;
  late final TextComponent healthTextComponent;

  Hud({super.children, super.priority});

  @override
  Future<void> onLoad() async {
    scoreTextComponent = TextComponent(
      text: 'Score: 0',
      position: Vector2.all(10),
      textRenderer: regular,
    );
    await add(scoreTextComponent);

    healthTextComponent = TextComponent(
      text: 'x5',
      anchor: Anchor.topRight,
      position: Vector2(game.fixedResolution.x - 10, 10),
      textRenderer: regular,
    );
    await add(healthTextComponent);
/*
    var spriteSheet = await images.load('Spritesheet.png');

    final playerSprite = SpriteComponent.fromImage(
      image: spriteSheet,
      srcPosition: Vector2.zero(),
      srcSize: Vector2.all(32),
      anchor: Anchor.topRight,
      position: Vector2(
        healthTextComponent.position.x - healthTextComponent.size.x - 5,
        5,
      ),
    );
    await add(playerSprite);
*/

    /*
    game.playerData.score.addListener(onScoreChange);
    game.playerData.health.addListener(onHealthChange);

     */

    /*
    final pauseButton = SpriteButtonComponent(
      onPressed: () {
        AudioManager.pauseBgm();
        game.pauseEngine();
        game.overlays.add(PauseMenu.id);
      },
      button: Sprite(
        game.spriteSheet,
        srcSize: Vector2.all(32),
        srcPosition: Vector2(32 * 4, 0),
      ),
      size: Vector2.all(32),
      anchor: Anchor.topCenter,
      position: Vector2(game.fixedResolution.x / 2, 5),
    );
    await add(pauseButton);

     */
  }
}
