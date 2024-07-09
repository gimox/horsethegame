/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/my_game.dart';

class GameTextOverlayScreenRoute extends Route {
  GameTextOverlayScreenRoute()
      : super(GameTextOverlayScreen.new, transparent: true);

  @override
  void onPush(Route? previousRoute) {
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

class GameTextOverlayScreen extends Component with HasGameReference<MyGame> {
  @override
  void onMount() async {
    await Future.delayed(
      Duration(seconds: game.overlayDuration),
      () {
        // avoid router pop on other route | need more debug!
        if (game.router.currentRoute.name == null) {
          game.router.pop();
        }
      },
    );
    super.onMount();
  }

  @override
  Future<void> onLoad() async {
    // final game = findGame()!;

    await addAll([
      TextComponent(
        text: game.overlayMessage,
        position: game.canvasSize / 2,
        textRenderer: big,
        anchor: Anchor.center,
        children: [
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(
              duration: 0.3,
              alternate: true,
              infinite: true,
            ),
          ),
        ],
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;
}
