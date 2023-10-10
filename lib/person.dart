import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flappybird/static_enemy.dart';
import 'package:flappybird/terrain.dart';

import 'game.dart';
import 'main.dart';

class Person extends SpriteAnimationComponent
    with
        TapCallbacks,
        HasGameRef<EndlessRunnerGame>,
        CollisionCallbacks {
  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 1500;

  int countApple = 0;
  bool isOnGround = false;
  bool isJumping = true;

  late SpriteSheet hurtSpriteSheet, jumpSpriteSheet, walkSpriteSheet;
  late SpriteAnimation hurtAnimation, jumpAnimation, walkAnimation;

  @override
  void onLoad() async {
    position = Vector2(40.0, gameRef.size.y/2);
    size = Vector2(72.0, 97.0);
    anchor = Anchor.center;

    jumpSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('p1_jump.png'),
      srcSize: Vector2(72.0, 97.0),
    );

    walkSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('p1_walk.png'),
      srcSize: Vector2(72.0, 97.0),
    );

    hurtSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('p1_hurt.png'),
      srcSize: Vector2(72.0, 97.0),
    );

    jumpAnimation = jumpSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 1, loop: true);
    hurtAnimation = hurtSpriteSheet.createAnimation(
        row: 0, stepTime: 0.4, from: 0, to: 1, loop: true);
    walkAnimation = walkSpriteSheet.createAnimation(
        row: 0, stepTime: 0.05, from: 0, to: 11, loop: true);

    //define a animação atual
    animation = jumpAnimation;
    super.onLoad();

    add(RectangleHitbox(size: Vector2(66, 90))..collisionType = CollisionType.active);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Terrain) {
      position.y = gameRef.size.y - 323.5;
      isOnGround = true;
      isJumping = false;
    }

    if (other is StaticEnemy) {
      EndlessRunnerGame.gameOver = true;
      vx = 0;
      vy = 0;
      other.vx = 0;
    }
  }

  @override
  void onTapUp(TapUpEvent event) async {

  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
  }

  void jump() {
    if (!isJumping) {
      vy = -1000;
      isOnGround = false;
      animation = jumpAnimation;
      isJumping = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isOnGround && !EndlessRunnerGame.gameOver) {
      vy = 0; // Zere a velocidade vertical quando o personagem está no chão
      animation = walkAnimation;
    } else if (EndlessRunnerGame.gameOver) {
      animation = hurtAnimation;
    } else {
      vy += ay * dt; // Aplique a aceleração vertical
    }

    position.y += vy * dt;
  }
}
