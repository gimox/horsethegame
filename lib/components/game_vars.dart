/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

class GameVars {
  //players
  static const String characters = 'Mask Dude';
  static const String charactersDir = 'Main Characters';
  static const String charactersImgFileExt = '.png';

  static const int playerStartHealth = 3;
  static const int playerStartScore = 0;
  static const int playerStartLevel = 0;

  // levels
  static const int startLevelIndex = 0;
  static const List<String> levelNames = ['level_01', 'level_01'];

  //resolution
  static const Map<String, double> resolution = {'width': 640, 'height': 360};

  // sound
  static const bool playSound = false;
  static const double soundMusicVolumes = 1.0;

  // fruit
  static const String itemsDir = 'Items';

  static const String fruitsDir = 'Fruits';
  static const String fruitsImgFileExt = '.png';

  static const String trapsDir = 'Traps';
}
