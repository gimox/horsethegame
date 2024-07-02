/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:horsethegame/my_game.dart';

class GameOverScreen extends Component with HasGameRef<MyGame>, TapCallbacks {
  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) {
    game.router.pop();
    game.router.pushNamed('splash');
  }
}

class GameOverRoute extends Route {
  GameOverRoute() : super(GameOverRoute.new, transparent: true);

  @override
  void onPush(Route? previousRoute) {
    // print("name: ${previousRoute?.name}");
    previousRoute!
      ..stopTime()
      ..addRenderEffect(
        PaintDecorator.grayscale(opacity: 0.2)..addBlur(3.0),
      );
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute
      ..resumeTime()
      ..removeRenderEffect();
  }
}
