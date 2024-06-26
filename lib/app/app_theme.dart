import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.pixelifySansTextTheme(baseTheme.textTheme),
  );
}

final regular = TextPaint(
  style: TextStyle(
    fontSize: 18.0,
    color: BasicPalette.white.color,

  ),
);
