/*
 * Copyright (c) 2024.
 * Giorgio Modoni <modogio@gmail.com>
 */

import 'package:flutter/material.dart';
import 'package:horsethegame/my_game.dart';

class GameoverMenu extends StatelessWidget {
  static const id = 'GameoverMenu';
  final MyGame game;

  const GameoverMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  // game.add(GamePlay());
                },
                child: const Text('----'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  //  game.overlays.add(Settings.id);
                },
                child: const Text('-------'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
