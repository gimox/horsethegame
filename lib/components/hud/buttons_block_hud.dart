/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:horsethegame/my_game.dart';
import 'package:horsethegame/overlays/pause_menu.dart';

class ButtonsBlockHud extends PositionComponent with HasGameRef<MyGame> {
  double positionY;
  double spriteHealthSize;

  ButtonsBlockHud({
    this.positionY = 10,
    this.spriteHealthSize = 22,
    super.children,
    super.priority,
  });

  late final Image pauseImage;

  Future<void> addPauseImage() async {
    pauseImage = game.images.fromCache('Menu/Buttons/Play.png');
    final pauseButton = SpriteButtonComponent(
      onPressed: () => game.router.pushOverlay(PauseMenu.id),
      button: Sprite(
        pauseImage,
        srcSize: Vector2.all(32),
        srcPosition: Vector2(0, 0),
      ),
      size: Vector2.all(32),
      anchor: Anchor.topCenter,
      position: Vector2(game.size.x / 2, positionY),
    );

    await add(pauseButton);
  }

  Future<void> addSoundImage() async {
    final image = game.images.fromCache('Menu/Buttons/Volume.png');

    final button = SpriteButtonComponent(
      onPressed: () => game.gamePlay.soundToggle(),
      button: Sprite(
        image,
        srcSize: Vector2.all(32),
        srcPosition: Vector2(0, 0),
      ),
      size: Vector2.all(32),
      anchor: Anchor.topCenter,
      position: Vector2(game.size.x / 2 +32, positionY),
    );

    await add(button);
  }

}
