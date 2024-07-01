import 'package:flutter/material.dart';
import 'package:horsethegame/my_game.dart';
import 'package:horsethegame/overlays/settings_menu.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';
  final MyGame game;

  const MainMenu({required this.game, super.key});

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

                //  game.currentLevelIndex = 0;
                 // game.worldLevel.loadNextLevel();
                  game.overlays.remove(id);
                 // game.add(MyGame());
                },
                child: const Text('Play'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                //  game.overlays.add(SettingsMenu.id);
                },
                child: const Text('Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
