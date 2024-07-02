/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flutter/material.dart' hide Route;
import 'package:horsethegame/my_game.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseMenu';
  final MyGame game;

  const PauseMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    game.pauseEngine();

    return Scaffold(
      backgroundColor: Colors.black.withAlpha(100),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  // game.overlays.remove(id);
                  game.resumeEngine();
                  game.router.pop();
                },
                child: const Text('Resume'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () async {
                  game.router.pop();
                  game.resumeEngine();
                  game.router.pushReplacementNamed('splash');
                },
                child: const Text('Exit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
