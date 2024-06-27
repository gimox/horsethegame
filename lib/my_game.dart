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
import 'package:horsethegame/components/level.dart';
import 'package:horsethegame/components/world_level.dart';
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

  Player player = Player(character: 'Mask Dude');

  // joystick
  bool showControls = false;
  late final Joystick joystickCtrl;

  // sound
  late AudioManager sound;
  bool playSounds = false;
  double soundVolume = 1.0;

  // level
  List<String> levelNames = ['level_01', 'level_01'];
  int currentLevelIndex = 0;

  // resolution & camera
  final fixedResolution = Vector2(640, 360);
  late CameraComponent cam;

  // hud
  late final Hud hud;
  List<Component> hudComponents = [];

  // level loading
  late final WorldLevel worldLevel;

  // score & lives
  int lives = 0;
  int startLives = 3;
  int score = 0;
  late TextComponent livesText = TextComponent();
  late TextComponent scoreText = TextComponent();

  @override
  FutureOr<void> onLoad() async {
    // set hud default
    hud = Hud(priority: 1);
    hudComponents = [hud];

    // init audio
    sound = AudioManager();
    await sound.init(); // cache all audio files
    add(sound);

    // load all image into cache
    await images.loadAllImages();

    // fix resize
    camera.viewport = FixedResolutionViewport(resolution: fixedResolution);

    // display joystick if needed, add joystick image to hud
    add(Joystick());

    // manage level loading
    worldLevel = WorldLevel();
    add(worldLevel);

    // load game level
    await worldLevel.loadLevel();

    return super.onLoad();
  }

  void removeLives() {
    if (lives > 0) {
      lives -= 1;
    } else {
      lives = 0;
    }
  }
}
