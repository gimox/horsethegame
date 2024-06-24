/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/rendering.dart';



class BackgroundTile extends ParallaxComponent {
  final String color;

  BackgroundTile({this.color = 'Gray', super.position});

  final double scrollSpeed = 40;

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64);
    parallax = await game.loadParallax(
      [ParallaxImageData('Background/$color.png')],
      baseVelocity: Vector2(0, -scrollSpeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );

    /*
    parallax = await game.loadParallax[
      [ParallaxImageData('Background/$color.png')],
    baseVelocity: Vector2(0, -scrollSpeed),
    repeat: ImageRepeat.repeat,
    fill: LayerFill.onLoad(),
    ]);
    */

    //sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

/*
  @override
  void updateTree(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64;
    int scrollHeight = (game.size.y / tileSize).floor();
    if (position.y > scrollHeight * tileSize) position.y = -tileSize;
    super.updateTree(dt);
  }

   */
}
