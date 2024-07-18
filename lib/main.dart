/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horsethegame/my_game.dart';
import 'package:horsethegame/app/app_theme.dart';
import 'package:horsethegame/overlays/pause_menu.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await windowManager.ensureInitialized();

  // add Fonts licence
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // disable fonts fetching. Check locale assets
  GoogleFonts.config.allowRuntimeFetching = false;

  // for desktop only, add more platform...
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(640, 360),
      // this can be changed in my_game
      center: true,
      title: "HORSE THE GAME",
      backgroundColor: Colors.transparent,
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.normal,
      windowButtonVisibility: true,
      minimumSize: Size(320, 180),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAspectRatio(1.78); // aspect ratio for 640x360
    });
  }

  //MyGame game = MyGame();
  // runApp(GameWidget<MyGame>(game: kDebugMode ? MyGame() : game));
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
      theme: buildTheme(Brightness.dark),
      home: Scaffold(
        body: GameWidget<MyGame>(
          game: kDebugMode ? MyGame() : game,
          overlayBuilderMap: {
            PauseMenu.id: (context, game) => PauseMenu(game: game),
          },
          //  initialActiveOverlays: const [MainMenu.id],
        ),
      ),
    );
  }
}
