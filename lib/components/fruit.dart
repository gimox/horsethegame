import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:horsethegame/components/audio_manager.dart';
import 'package:horsethegame/components/custom_hitbox.dart';
import 'package:horsethegame/components/game_vars.dart';
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
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    //  debugMode = true;
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
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
