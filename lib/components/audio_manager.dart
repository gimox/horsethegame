/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:horsethegame/my_game.dart';

enum GameSoundSfx {
  jump,
  hit,
  disappear,
  pickup,
}

class AudioManager extends Component with HasGameRef<MyGame> {
  static const String audioExt = '.wav';
  bool isPlayBsm = false;

  Future<void> init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'jump.wav',
      'hit.wav',
      'disappear.wav',
      'pickup.wav',
      'menu.mp3',
      'win.mp3',
      'gameOver.mp3',
      'hurryup.mp3',
      'victorious.mp3',
    ]);
  }

  void playSfx(GameSoundSfx gameSound) {
    if (game.playSounds) {
      FlameAudio.play(
        gameSound.name + audioExt,
        volume: game.soundSfxVolumes,
      );
    }
  }

  void playBgm(String fileName) {
    if (game.playSounds) {
      isPlayBsm = true;
      FlameAudio.bgm.play(
        '$fileName.mp3',
        volume: game.soundMusicVolumes,
      );
    }
  }

  void stop() {
    FlameAudio.bgm.stop();
  }

  void pause() {
    FlameAudio.bgm.pause();
  }

  void resume() {
    FlameAudio.bgm.resume();
  }
}
