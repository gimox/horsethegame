import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'package:horsethegame/my_game.dart';

import 'jump_button.dart';

class Joystick extends Component with HasGameRef<MyGame>, TapCallbacks {
  String knobImg;
  String joystickImg;

  Joystick({
    this.knobImg = 'HUD/knob.png',
    this.joystickImg = 'HUD/joystick.png',
  });

  final int marginButton = 32;
  final int buttonSize = 64;

  final int joystickPriority = 10;
  late JoystickComponent joystick;

  @override
  void update(double dt) {
    if (game.showControls) {
      _updateJoystick();
    }

    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    _canShowControls();
    initJoystick();

    return super.onLoad();
  }

  void initJoystick() {
    if (game.showControls) {
      game.hudComponents = [game.hud, _getJoystick(), JumpButton()];
    }
  }

  JoystickComponent _getJoystick() {
    joystick = JoystickComponent(
      priority: joystickPriority,
      knob: SpriteComponent(sprite: Sprite(game.images.fromCache(knobImg))),
      background: SpriteComponent(
        sprite: Sprite(game.images.fromCache(joystickImg)),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    return joystick;
  }

  void _updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        game.player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        game.player.horizontalMovement = 1;
        break;
      default:
        game.player.horizontalMovement = 0;
        //idle
        break;
    }
  }

  void _canShowControls() {
    if (Platform.isAndroid || Platform.isIOS) {
      game.showControls = true;
    }
  }
}
