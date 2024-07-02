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
import 'package:horsethegame/components/game_play.dart';
import 'package:horsethegame/screens/pause_screen.dart';
import 'package:horsethegame/screens/play_screen.dart';
import 'package:horsethegame/screens/splash_screen.dart';
import 'components/game_vars.dart';
import 'components/hud.dart';
import 'components/joystick/joystick.dart';
import 'components/level.dart';
import 'components/player.dart';

class MyGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  Player player = Player(character: GameVars.characters);

  // joystick
  bool showControls = false;
  late final Joystick joystickCtrl;

  // sound
  late AudioManager sound;
  bool playSounds = GameVars.playSound;
  double soundVolume = GameVars.soundMusicVolumes;

  // level
  List<String> levelNames = GameVars.levelNames;
  int currentLevelIndex = GameVars.startLevelIndex;

  // resolution & camera
  final Vector2 fixedResolution =
      Vector2(GameVars.resolution['width']!, GameVars.resolution['height']!);
  late CameraComponent cam;

  // hud
  late final Hud hud;
  List<Component> hudComponents = [];

  // level loading
  late final GamePlay worldLevel;

  // score & lives
  late final PlayerData playerData;

  // add routing
  late final RouterComponent router;

  late Level worldGameLevel;

  @override
  FutureOr<void> onLoad() async {
    // player
    playerData = PlayerData(
      GameVars.playerStartHealth,
      GameVars.playerStartScore,
      GameVars.playerStartLevel,
    )..initNotifier();

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
    worldLevel = GamePlay();
    add(worldLevel);

    if (kDebugMode) {
      print("* onLoad my_game call");
    }

    // load router
    await _addRouter();

    return super.onLoad();
  }

  @override
  void onRemove() {
    //   hud?.removeFromParent();

    super.onRemove();
  }

  Future<void> _addRouter() async {
    await add(
      router = RouterComponent(
        routes: {
          'splash': Route(SplashScreen.new),
          'play': Route(PlayScreen.new),
          'pause': PauseRoute(),
        },
        initialRoute: 'splash',
      ),
    );
  }
}
