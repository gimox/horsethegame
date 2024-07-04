import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:horsethegame/my_game.dart';

class PlayScreen extends Component with HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    if (kDebugMode) {
      print('* onLoad PlayScreen called');
    }

    if (game.currentLevelIndex != game.playerData.startLevel ||
        game.playerData.health.value != game.playerData.startHealth ||
        game.playerData.score.value != game.playerData.startScore) {
      if (kDebugMode) {
        print('PlayScreen load startGame');
      }
      await game.gamePlay.startGame();
    }

    return super.onLoad();
  }
}
