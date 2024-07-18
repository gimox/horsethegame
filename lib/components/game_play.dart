/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:horsethegame/components/level.dart';
import 'package:horsethegame/components/utils/game_vars.dart';
import 'package:horsethegame/my_game.dart';
import 'package:horsethegame/screens/game_text_overlay_screen.dart';

class GamePlay extends Component with HasGameRef<MyGame>, Notifier {
  GamePlay();

  @override
  FutureOr<void> onLoad() {
    game.gameTimer.countDownTime.addListener(_onTimerChange);
    game.playerData.health.addListener(_onHealthChange);
    game.gameState.addListener(_onGameState);

    if (kDebugMode) print("* gamePlay onLoad called");

    return super.onLoad();
  }

  void _onGameState() {
    switch (game.gameState.value) {
      case GameState.reachedCheckpoint:
        _onCheckPoint();
        break;

      case GameState.respawn:
        _onRespawn();
        break;

      case GameState.gameOver:
        _onGameOver();
        break;

      case GameState.win:
        _onWin();
        break;

      default:
        break;
    }
  }

  // call this to only on start game
  FutureOr<void> startGame() async {
    if (kDebugMode) {
      print('* gamePlay startGame call');
    }

    game.gameState.value = GameState.startGame;

    removeWhere((component) => component is Level);
    _initGame();

    await _loadLevel();
  }

  void _initGame() {
    if (kDebugMode) print('* gamePlay _initGame call');

    game.currentLevelIndex = 0;
    game.playerData.health.value = game.playerData.startHealth;
    game.playerData.score.value = game.playerData.startScore;
    game.playerData.level.value = game.playerData.startLevel;
  }

  // call to change level
  FutureOr<void> loadNextLevel() async {
    removeWhere((component) => component is Level);

    if (game.currentLevelIndex < game.levelNames.length - 1) {
      game.currentLevelIndex++;
      await _loadLevel();
    } else {
      // no more level = win
      game.gameState.value = GameState.win;
      return;
    }
  }

  FutureOr<void> _loadLevel() async {
    game.playerData.level.value = game.currentLevelIndex + 1;

    _playLevelSong();

    if (kDebugMode) {
      print('');
      print('\n-------------------------------------------------');
      print('current index level: ${game.currentLevelIndex}');
      print('player level: ${game.playerData.level.value}');
      print('player score: ${game.playerData.score.value}');
      print('player health: ${game.playerData.health.value}');
      print('\n-------------------------------------------------');
    }

    const Duration startLevelDuration =
        Duration(milliseconds: GameVars.startLevelMilliseconds);

    await Future.delayed(startLevelDuration, () async {
      game.gameLevel = Level(
        player: game.player,
        levelName: game.levelNames[game.currentLevelIndex],
      );

      game.cam = CameraComponent.withFixedResolution(
        world: game.gameLevel,
        width: game.fixedResolution.x,
        height: game.fixedResolution.y,
        hudComponents: game.hudComponents,
      );

      game.cam.viewfinder.anchor = Anchor.topLeft;
      game.cam.priority = 1;

      await addAll([
        game.cam,
        game.gameLevel,
      ]);

      // reset timer
      _setCountdownTimeFromTile();
      // display start level message
      _startLevelMessageRoute();
    });
  }

  // set game countdown to initial value
  void _setCountdownTimeFromTile() {
    game.gameState.value = GameState.resetTime;

    game.gameTimer.interval.start();
    game.gameTimer.countDownTime.value =
        game.gameLevel.getPropertyString('CountdownTimer')!;
  }

  // display message for level
  void _startLevelMessageRoute() {
    game.overlayDuration = GameVars.startLevelOverlayDuration;
    game.overlayMessage = "LEVEL ${game.playerData.level.value}";
    game.router.pushRoute(GameTextOverlayScreenRoute());
  }

  // play song for level
  void _playLevelSong() {
    if (game.sound.isPlayBsm) game.sound.stop();
    game.sound.playBgm('level_${game.playerData.level.value}');
  }

  // event on game timer
  _onTimerChange() {
    // hurry up!
    if (game.gameTimer.countDownTime.value == GameVars.hurryUpStartTime) {
      game.gameState.value = GameState.hurryUpTime;
      game.sound.playBgm('hurryup');
    }

    // timers is over
    if (game.gameTimer.countDownTime.value == 0) {
      _setCountdownTimeFromTile();
      game.player.respawn();
    }
  }

  // event on health change
  Future<void> _onHealthChange() async {
    // check if health is 0
    if (game.playerData.health.value == 0) {
      game.gameState.value = GameState.gameOver;
      //_onGameOver();
    }
  }

  // event when player reach checkPoint
  void _onCheckPoint() {
    // stop timer
    game.gameTimer.interval.stop();
    game.sound.stop();

    // play victory sound
    game.sound.playBgm('victorious');

    // go to next level
    game.gamePlay._changeLevel();
  }

  Future<void> _changeLevel() async {
    _levelCompletedMessageRoute();

    const waitToChangeDuration =
        Duration(seconds: GameVars.changeLevelDuration);
    await Future.delayed(waitToChangeDuration, () => loadNextLevel());
  }

  void _levelCompletedMessageRoute() {
    game.overlayDuration = GameVars.changeLevelDuration;
    game.overlayMessage = "LEVEL COMPLETED";
    game.router.pushRoute(GameTextOverlayScreenRoute());
  }

  void _onRespawn() {
    _removeHealth();
    if (game.gameState.value != GameState.gameOver) {
      _setCountdownTimeFromTile();
      _playLevelSong();
    }
  }

  void _removeHealth() {
    if(game.playerData.health.value > 0)game.playerData.health.value -= 1;

    /*
    game.playerData.health.value = game.playerData.health.value > 0
        ? game.playerData.health.value -= 1
        : 0;

     */
  }

  Future<void> _onGameOver() async {
    if (kDebugMode) {
      print('* gamePlay onGameOver');
    }
    game.gameTimer.interval.stop();
    game.sound.stop();

    game.sound.playBgm('gameOver');
    game.router.pushNamed('gameOver');
  }

  void _onWin() {
    game.gameTimer.interval.stop();
    game.sound.stop();

    game.sound.playBgm('win');
    game.router.pushNamed('win');
  }

  void soundToggleRoute() {
    // fix route error, enable button only if route is  not null
    // when overlay route display: name== null,
    String? routeName = game.router.currentRoute.name;
    if (routeName == null) return;

    game.overlayDuration = GameVars.soundOverlayDuration;
    if (game.playSounds) {
      game.overlayMessage = "Sound OFF";
      game.playSounds = false;
      game.sound.pause();
    } else {
      game.overlayMessage = "Sound ON";
      game.playSounds = true;
      if (!game.sound.isPlayBsm) {
        game.sound.playBgm('level_${game.playerData.level.value}');
      } else {
        game.sound.resume();
      }
    }

    game.router.pushRoute(GameTextOverlayScreenRoute());
  }

  void splashRoute() {
    game.gameTimer.interval.stop();
    game.sound.stop();

    game.sound.playBgm('menu');
    game.router.pushNamed('splash');
  }
}
