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
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:horsethegame/components/audio_manager.dart';
import 'package:horsethegame/components/game_router.dart';
import 'package:horsethegame/components/game_timer.dart';
import 'package:horsethegame/components/player_data.dart';
import 'package:horsethegame/components/game_play.dart';
import 'components/utils/game_vars.dart';
import 'components/hud/hud.dart';
import 'components/joystick/joystick.dart';
import 'components/level.dart';
import 'components/player.dart';

enum GameState {
  idle,
  loading,
  startingGame,
  start,
  removeHealth,
}

class MyGame extends FlameGame
    with DragCallbacks, HasCollisionDetection, KeyboardEvents, TapCallbacks {
  @override
  Color backgroundColor() => GameVars.defaultBackgroundColorTile;

  Player player = Player(character: GameVars.characters);

  // joystick
  bool showControls = GameVars.defaultShowControl;
  late final Joystick joystickCtrl;

  // sound
  late AudioManager sound;
  bool playSounds = GameVars.playSound;
  double soundSfxVolumes = GameVars.soundSfxVolumes;
  double soundMusicVolumes = GameVars.soundMusicVolumes;

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
  late final GamePlay gamePlay;

  // score & lives
  late final PlayerData playerData;

  // add routing
  late final RouterComponent router;

  late Level gameLevel;
  late final Image spriteImage;

  String overlayMessage = '';
  int overlayDuration = 3;


  late final GameTimer gameTimer;

  late GameState gameState;
  late ValueNotifier<GameState> gameStateNotifier;

  @override
  FutureOr<void> onLoad() async {
    if (kDebugMode) {
      print("* myGame onLoad called");
    }

    // game event
    gameState = GameState.idle;
    gameStateNotifier = ValueNotifier<GameState>(gameState);

    gameTimer = GameTimer();
    add(gameTimer);
    gameTimer.loadTimer();


    // load all image into cache
    await images.loadAllImages();

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

    // fix resize
    camera.viewport = FixedResolutionViewport(resolution: fixedResolution);

    // display joystick if needed, add joystick image to hud
    add(Joystick());

    // manage level loading
    gamePlay = GamePlay();
    add(gamePlay);

    // load router
    router = GameRouter().getRoutes();
    await add(router);

    return super.onLoad();
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.resetMovement();

    if (keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      player.hasJumped = true;
    } else {
      player.hasJumped = false;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player.moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player.moveRight();
    }

    return KeyEventResult.handled;
  }
}
