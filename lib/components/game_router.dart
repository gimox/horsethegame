/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:horsethegame/my_game.dart';
import 'package:horsethegame/screens/game_over_screen.dart';
import 'package:horsethegame/screens/game_text_overlay_screen.dart';
import 'package:horsethegame/screens/play_screen.dart';
import 'package:horsethegame/screens/sound_toggle_screen.dart';
import 'package:horsethegame/screens/splash_screen.dart';
import 'package:horsethegame/screens/win_screen.dart';

class GameRouter extends Component with HasGameRef<MyGame> {
  RouterComponent getRoutes() {
    return RouterComponent(
      routes: {
        'splash': Route(SplashScreen.new),
        'play': Route(PlayScreen.new),
        'gameOver': Route(GameOverScreen.new),
        'win': Route(WinScreen.new),
        'message': GameTextOverlayScreenRoute(),
        'soundToggle': SoundToggleScreenRoute(),
      },
      initialRoute: 'splash',
    );
  }
}
