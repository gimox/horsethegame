import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:horsethegame/components/audio_manager.dart';
import 'package:horsethegame/components/custom_hitbox.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
import 'package:horsethegame/my_game.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final String fruit;

  Fruit({
    this.fruit = 'Apple',
    super.position,
    super.size,
  });

  final double stepTime = 0.05;
  final hitBox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = GameVars.fruitDebug;
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitBox.offsetX, hitBox.offsetY),
        size: Vector2(hitBox.width, hitBox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          '${GameVars.itemsDir}/${GameVars.fruitsDir}/$fruit${GameVars.fruitsImgFileExt}'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      game.sound.play(GameSound.pickup);
      game.playerData.score.value += 1;

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            '${GameVars.itemsDir}/${GameVars.fruitsDir}/Collected${GameVars.fruitsImgFileExt}'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );

      await animationTicker?.completed;
      animationTicker?.reset();

      removeFromParent();
    }
  }
}
