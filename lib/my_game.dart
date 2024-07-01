/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:horsethegame/components/audio_manager.dart';
import 'package:horsethegame/components/player_data.dart';
import 'package:horsethegame/components/world_level.dart';
import 'package:horsethegame/screens/pause_screen.dart';
import 'package:horsethegame/screens/play_screen.dart';
import 'package:horsethegame/screens/splash_screen.dart';
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

  final PlayerData playerData = PlayerData(3, 0, 0);

  late final RouterComponent router;

  @override
  FutureOr<void> onLoad() async {
    playerData.initNotifier();

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

    if (kDebugMode) {
      print("game onload");
    }
    // load game level


    add(
      router = RouterComponent(
        routes: {
          'splash': Route(SplashScreen.new),
          'play': Route(PlayScreen.new),
          'pause':PauseRoute(),
        },
        initialRoute: 'splash',
      ),
    );

    return super.onLoad();
  }

  @override
  void onRemove() {
    //   hud?.removeFromParent();

    super.onRemove();
  }
}
