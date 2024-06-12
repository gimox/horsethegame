/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:horsethegame/my_game.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyGame> {
  String character;
  Player({position, required this.character}): super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    return super.onLoad();
  }

  void _loadAllAnimations() {

    idleAnimation =_spriteAnimation("Idle",11);
    runningAnimation = _spriteAnimation("Run",12);

    // list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount){
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/$character/$state (32x32).png"),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
