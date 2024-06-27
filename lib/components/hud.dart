import 'package:flame/components.dart';
import 'package:horsethegame/app/app_theme.dart';
import 'package:horsethegame/my_game.dart';

class Hud extends PositionComponent with HasGameRef<MyGame> {
  Hud({super.children, super.priority});

  @override
  void update(double dt) {
    game.livesText.text = 'Lives: ${game.lives}';
    game.scoreText.text = 'Score: ${game.score}';

    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    game.scoreText = TextComponent(
      text: 'Score: ${game.score}',
      position: Vector2.all(10),
      textRenderer: regular,
    );
    await add(game.scoreText);

    game.livesText = TextComponent(
      text: 'Lives: ${game.lives}',
      anchor: Anchor.topRight,
      position: Vector2(game.fixedResolution.x - 10, 10),
      textRenderer: regular,
    );
    await add(game.livesText);
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
