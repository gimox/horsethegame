import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'package:horsethegame/my_game.dart';

class Joystick extends Component with HasGameRef<MyGame>, TapCallbacks {
  Joystick();

  bool showControls = false;
  final marginButton = 32;
  final buttonSize = 64;
  late JoystickComponent joystick;

  JoystickComponent getJoystick(Sprite knob, Sprite joystickHud) {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(sprite: knob),
      background: SpriteComponent(
        sprite: joystickHud,
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    return joystick;
  }

  void updateJoystick() {
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
}
