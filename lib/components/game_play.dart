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
    game.playerData.health.addListener(onHealthChange);

    if (kDebugMode) print("* gamePlay onLoad called");

    return super.onLoad();
  }

  // call this to only on start game
  FutureOr<void> startGame() async {
    if (kDebugMode) {
      print('* gamePlay startGame call');
    }

    game.gameState = GameState.startingGame;

    removeWhere((component) => component is Level);
    _initGame();

    await _loadLevel();
  }

  // call to change level
  FutureOr<void> loadNextLevel() async {
    removeWhere((component) => component is Level);

    if (game.currentLevelIndex < game.levelNames.length - 1) {
      game.currentLevelIndex++;
    } else {
      // no more level
      winRoute();
      return;
    }

    await _loadLevel();
  }

  FutureOr<void> _loadLevel() async {
    game.playerData.level.value = game.currentLevelIndex + 1;

    _playLevelSong();

    if (kDebugMode) {
      print('');
      print('');
      print('-------------------------------------------------');
      print('current index level: ${game.currentLevelIndex}');
      print('player level: ${game.playerData.level.value}');
      print('player score: ${game.playerData.score.value}');
      print('player health: ${game.playerData.health.value}');
      print('-------------------------------------------------\n');
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
      setCountdownTimeFromTile();
      // display start level message
      startLevelMessageRoute();
    });
  }

  void _initGame() {
    if (kDebugMode) print('* gamePlay _initGame call');

    game.currentLevelIndex = 0;
    game.playerData.health.value = game.playerData.startHealth;
    game.playerData.score.value = game.playerData.startScore;
    game.playerData.level.value = game.playerData.startLevel;
  }

  void _playLevelSong() {
    if (game.sound.isPlayBsm) game.sound.stop();
    game.sound.playBgm('level_${game.playerData.level.value}');
  }

  void setCountdownTimeFromTile() {
    game.gameTimer.interval.start();
    game.gameTimer.countDownTime.value =
        game.gameLevel.getPropertyString('CountdownTimer')!;
    // game.gameTimer.countDownTime.value = 20;
  }

  _onTimerChange() {
    if (game.gameTimer.countDownTime.value == GameVars.hurryUpStartTime) {
      game.sound.playBgm('hurryup');
    }

    if (game.gameTimer.countDownTime.value == 0) {
      setCountdownTimeFromTile();
      game.player.respawn();
    }
  }

  void onRespawn() {
    setCountdownTimeFromTile();
    _playLevelSong();
  }

  void removeHealth() {
    if (game.playerData.health.value > 0) {
      game.playerData.health.value -= 1;
      game.gameState = GameState.removeHealth;
    } else {
      game.playerData.health.value = 0;
    }
  }

  Future<void> onHealthChange() async {
    if (game.playerData.health.value == 0) {
      onGameOver();
    }
  }

  Future<void> onChangeLevel() async {
    levelCompletedMessageRoute();

    const waitToChangeDuration =
        Duration(seconds: GameVars.changeLevelDuration);
    await Future.delayed(waitToChangeDuration, () => loadNextLevel());
  }

  void onCheckPoint() {
    game.gameTimer.interval.stop();
    game.sound.stop();
    game.sound.playBgm('victorious');
  }

  void levelCompletedMessageRoute() {
    game.overlayDuration = GameVars.changeLevelDuration;
    game.overlayMessage = "LEVEL COMPLETED";
    game.router.pushRoute(GameTextOverlayScreenRoute());
  }

  void startLevelMessageRoute() {
    game.overlayDuration = GameVars.startLevelOverlayDuration;
    game.overlayMessage = "LEVEL ${game.playerData.level.value}";
    game.router.pushRoute(GameTextOverlayScreenRoute());
  }

  Future<void> onGameOver() async {
    game.gameTimer.interval.stop();
    game.sound.stop();

    game.sound.playBgm('gameOver');
    game.gamePlay.gameOverRoute();
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
    game.router.pushReplacementNamed('splash');
  }

  void gameOverRoute() {
    game.router.pushNamed('gameOver');
  }

  void winRoute() {
    game.gameTimer.interval.stop();
    game.sound.stop();

    game.sound.playBgm('win');
    game.router.pushReplacementNamed('win');
  }
}
