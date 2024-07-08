/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:ui';

class GameVars {

  //debug
  static const bool playerDebug = false;
  static const bool sawDebug = false;
  static const bool fruitDebug = false;
  static const bool checkpointDebug = false;

  //players
  static const String characters = 'Mask Dude';
  static const String charactersDir = 'Main Characters';
  static const String charactersImgFileExt = '.png';
  static const double stepTime = 0.05;
  static const double gravity = 9.8;
  static const double jumpForce = 260;
  static const double terminalVelocity = 300;
  static const double moveSpeed = 100;
  static const double playerSpriteSize = 32;


  static const int playerStartHealth = 3;
  static const int playerStartScore = 0;
  static const int playerStartLevel = 0;


  // hud
  static const double hudPositionY = 5;
  static const double hudPlayerHealthSize = 20;


  //items
  static const String itemsDir = 'Items';

  // levels
  static const int startLevelIndex = 0;
  static const List<String> levelNames = ['level_01', 'level_01'];
  static const Color defaultBackgroundColorTile = Color(0xFF211F30);
  static const int changeLevelDuration = 3;

  //resolution
  static const Map<String, double> resolution = {'width': 640, 'height': 360};

  // sound
  static const bool playSound = false;
  static const double soundMusicVolumes = 0.7;
  static const double soundSfxVolumes = 0.9;

  // joystick
  static const bool defaultShowControl = false;

  // fruit
  static const String fruitsDir = 'Fruits';
  static const String fruitsImgFileExt = '.png';

  static const String trapsDir = 'Traps';
  static const String checkpointDir = 'Checkpoints';
}
