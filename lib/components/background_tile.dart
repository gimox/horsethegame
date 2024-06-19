import 'dart:async';

import 'package:flame/components.dart';
import 'package:horsethegame/my_game.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<MyGame> {
  final String color;

  BackgroundTile({this.color = 'Gray', super.position});

  final double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void updateTree(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64;
    int scrollHeight = (game.size.y / tileSize).floor();
    if (position.y > scrollHeight * tileSize) position.y = -tileSize;
    super.updateTree(dt);
  }
}
