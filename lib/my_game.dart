/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';
import 'package:horsethegame/components/jump_button.dart';
import 'package:horsethegame/components/level.dart';
import 'components/player.dart';

class MyGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showControls = false;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = ['level_01', 'level_01'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    _canShowControls();

    // load all image into cache
    await images.loadAllImages();

    _loadLevel();

    if (showControls) {
      addJoystick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      //    knobRadius: 64,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        //idle
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        height: 360,
        width: 640,
      );
      cam.viewfinder.anchor = Anchor.topLeft;
      cam.priority = 1;

      addAll([cam, world]);
    });
  }

  void _canShowControls() {
    if (Platform.isAndroid || Platform.isIOS) {
      showControls = true;
    }
  }
}
