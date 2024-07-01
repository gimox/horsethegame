import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:horsethegame/my_game.dart';

class PlayScreen extends Component with HasGameRef<MyGame> {

  @override
  Future<void> onLoad() async {

    if (kDebugMode) {
      print('play screen called');
    }

    await game.worldLevel.loadLevel();

    return super.onLoad();
  }
}
