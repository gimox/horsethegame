/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horsethegame/my_game.dart';

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  MyGame game = MyGame();
  runApp(GameWidget(
    game: kDebugMode ? MyGame() : game,
  ));
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MyApp());
}

// A single instance to avoid creation of
// multiple instances in every build.
final MyGame game = MyGame();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Horse The Game',
      theme: ThemeData.light(),
      home: Scaffold(
        body: GameWidget<MyGame>(
          game: kDebugMode ? MyGame() : game,
          overlayBuilderMap: const {},
        ),
      ),
    );
  }
}
