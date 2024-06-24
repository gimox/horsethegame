/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:horsethegame/my_game.dart';

enum GameSound {
  jump,
  hit,
  disappear,
  pickup,
}

class AudioManager extends Component with HasGameRef<MyGame> {
  static const String audioExt = '.wav';

  Future<void> init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache
        .loadAll(['jump.wav', 'hit.wav', 'disappear.wav', 'pickup.wav']);
  }

  void play(GameSound gameSound) {
    if (game.playSounds) {
      FlameAudio.play(gameSound.name + audioExt, volume: game.soundVolume);
    }
  }
}
