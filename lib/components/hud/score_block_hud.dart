/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/components.dart';
import 'package:horsethegame/app/game_theme.dart';
import 'package:horsethegame/my_game.dart';

class ScoreBlockHud extends PositionComponent with HasGameRef<MyGame> {
  double positionY;

  ScoreBlockHud({
    this.positionY = 10,
    super.children,
    super.priority,
  });

  late final TextComponent scoreTextComponent;

  Future<void> addScoreTextComponent() async {
    scoreTextComponent = TextComponent(
      text: 'Score: ${game.playerData.score.value}',
      anchor: Anchor.topRight,
      position: Vector2(game.size.x - 10, positionY),
      textRenderer: regular,
    );
    await add(scoreTextComponent);
  }
}
