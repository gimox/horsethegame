
import 'package:flutter/material.dart' hide Route;
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.pixelifySansTextTheme(baseTheme.textTheme),
  );
}
