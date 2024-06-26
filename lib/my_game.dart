/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';
import 'dart:io';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';
import 'package:horsethegame/components/audio_manager.dart';
import 'package:horsethegame/components/joystick/jump_button.dart';
import 'package:horsethegame/components/level.dart';
import 'components/hud.dart';
import 'components/joystick/joystick.dart';
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
  late AudioManager sound;

  Player player = Player(character: 'Mask Dude');

  bool showControls = false;
  final Joystick joystick = Joystick();

  bool playSounds = false;
  double soundVolume = 1.0;

  List<String> levelNames = ['level_01', 'level_01'];
  int currentLevelIndex = 0;

  final fixedResolution = Vector2(640, 360);

  final Hud hud = Hud(priority: 1);
  List<Component> hudComponents = [];

  int lives = 3;
  late ComponentsNotifier<Player> playerNotifier;

  @override
  FutureOr<void> onLoad() async {
    _canShowControls();

    // set hud default
    hudComponents = [hud];

    // init audio
    sound = AudioManager();
    await sound.init();
    add(sound);

    // load all image into cache
    await images.loadAllImages();

    // fix resize
    camera.viewport = FixedResolutionViewport(resolution: fixedResolution);

    _initJoystick();

    await _loadLevel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateJoystick();

    super.update(dt);
  }

  void loadNextLevel() async {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      await _loadLevel();
    } else {
      currentLevelIndex = 0;
      await _loadLevel();
    }
  }

  FutureOr<void> _loadLevel() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: fixedResolution.x,
        height: fixedResolution.y,
        hudComponents: hudComponents,
      );

      cam.viewfinder.anchor = Anchor.topLeft;
      cam.priority = 1;

      await addAll([cam, world]);
    });
  }

  void _canShowControls() {
    if (Platform.isAndroid || Platform.isIOS) {
      showControls = true;
    }
  }

  void _initJoystick() {
    if (showControls) {
      final Sprite knob = Sprite(images.fromCache('HUD/knob.png'));
      final Sprite joystickHud = Sprite(images.fromCache('HUD/joystick.png'));
      add(joystick);

      hudComponents = [
        hud,
        joystick.getJoystick(knob, joystickHud),
        JumpButton()
      ];
    }
  }

  void _updateJoystick() {
    if (showControls) {
      joystick.updateJoystick();
    }
  }

}
