import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'game.dart';

class Terrain extends PositionComponent
    with
        TapCallbacks,
        HasGameRef<EndlessRunnerGame>,
        CollisionCallbacks {
  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 0;

  @override
  void onLoad() async {
    position = Vector2(gameRef.size.x/2, gameRef.size.y - 140);
    size = Vector2(gameRef.size.x, 275.0);
    anchor = Anchor.center;

    super.onLoad();

    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {

  }

  @override
  void update(double dt) {

  }
}