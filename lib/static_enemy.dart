import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'game.dart';
import 'main.dart';

class StaticEnemy extends SpriteComponent
    with TapCallbacks, HasGameRef<EndlessRunnerGame>, CollisionCallbacks{
    late double vx;

  @override
  void onLoad() async {
    vx = 200;
    sprite = await gameRef.loadSprite('pokerMad.png');
    position = Vector2(gameRef.size.x + 48, gameRef.size.y/2 + 130);
    size = Vector2(48.0, 116.0);
    anchor = Anchor.center;
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }

  @override
  void onTapUp(TapUpEvent event)async {

  }

  @override
  void update(double dt) {
    super.update(dt);

    vx = 200 * EndlessRunnerGame.gameSpeed;

    position.x -= vx*dt;

    if(position.x < -24){
      position.x = gameRef.size.x + 48;
      Vector2(gameRef.size.x + 25, gameRef.size.y - 140);
    }

  }
}