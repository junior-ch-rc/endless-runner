import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappybird/person.dart';
import 'package:flappybird/static_enemy.dart';
import 'package:flappybird/terrain.dart';
import 'package:flutter/material.dart';

class EndlessRunnerGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Person _person;
  late Terrain _terrain;
  late StaticEnemy _enemy1;

  static bool gameOver = false;
  static double gameSpeed = 1.0;
  double score = 1;
  int velocityScore = 2;
  late TextComponent tc;

  // MENU
  final regular = TextPaint(
    style: const TextStyle(
      color: Color(0xee352b42),
      fontSize: 50,
      fontFamily: 'Permanent Marker',
    ),
  );

  late PlayButton playButton;
  late TextComponent initialText;
  late TextComponent replayText;
  bool playClicked = false;
  bool aux = true;

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.initialize();

    final images = [
      loadParallaxImage('bg.png', repeat: ImageRepeat.repeat),
      loadParallaxImage(
        'platform.png',
        repeat: ImageRepeat.repeatX,
        alignment: Alignment.bottomCenter,
        fill: LayerFill.none,
      ),
    ];

    final layers = images.map((image) async => ParallaxLayer(
      await image,
      velocityMultiplier: Vector2((images.indexOf(image) + 1) * 2.0, 0),
    ));

    final parallaxComponent = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(50, 0),
      ),
    );

    add(parallaxComponent);

    buildMenu();

    FlameAudio.bgm.play('musica.mp3', volume: 0.8);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (playClicked) {
      if (gameSpeed <= 5.0) {
        gameSpeed += 0.01 * dt;
      }

      if (gameOver == true) {
        if (aux == true) {
          playClicked = false;
          FlameAudio.play('dano.mp3');
          tc.text = "GAME OVER\n SCORE: ${score.floor()}";
          gameSpeed = 0.0;
          replayText = TextComponent(
            text: "REPLAY",
            anchor: Anchor.topCenter,
            textRenderer: regular,
            position: Vector2(size.x / 2, size.y/2 - 100),
          );
          add(replayText);

          playButton = PlayButton();
          add(playButton);

          aux = false;
        }
      } else {
        tc.text = score.floor().toString();
        score += velocityScore * dt;
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (playClicked) {
      _person.jump();
      FlameAudio.play('pulo.mp3');
    }
  }

  void buildMenu() {
    initialText = TextComponent(
        text: 'Endless Runner',
        textRenderer: regular,
        position: Vector2(size.x/2, size.y/2 - 150),
        angle: -0.20,
        anchor: Anchor.center
    );
    add(initialText);

    playButton = PlayButton();
    add(playButton);
  }

  void destroyMenuAndBuildGame() {
    if (gameOver) {
      remove(_person);
      remove(_enemy1);
      remove(replayText);
      remove(tc);
      gameOver = false;
      gameSpeed = 1.0;
      score = 1;
      aux = true;
    } else {
      remove(initialText);
    }

    remove(playButton);

    //cria personagem principal
    _person = Person();
    add(_person);

    //cria texto de pontos
    tc = TextComponent(
      text: score.floor().toString(),
      anchor: Anchor.topCenter,
      textRenderer: regular,
      position: Vector2(size.x / 2, 50),
    );
    add(tc);

    _terrain = Terrain();
    add(_terrain);

    _enemy1 = StaticEnemy();
    add(_enemy1);

    playClicked = true;
  }
}

class PlayButton extends SpriteComponent with HasGameRef<EndlessRunnerGame>, TapCallbacks {
  @override
  void onLoad() async {
    sprite = await gameRef.loadSprite('play-button.png');
    size = Vector2(54.0, 54.0);
    anchor = Anchor.center;
    position = Vector2(gameRef.size.x/2, gameRef.size.y/2);
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.destroyMenuAndBuildGame();
  }
}