/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:ui';

import 'package:flame/components.dart';

class BackgroundUtil extends Component {
  BackgroundUtil(this.color);

  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
  }
}
