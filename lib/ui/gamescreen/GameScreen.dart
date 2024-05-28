// ignore: file_names
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


// In your game class, add the onTapDown handler to handle taps
class BouncingBallGame extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  late Paddle paddle;
  late Ball ball;
  late TextComponent scoreText;  // TextComponent for the score counter
  int score = 0;  // Variable to keep track of the score

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Set the background color gradient
    add(Background());

    // Initialize the paddle and ball components once
    paddle = Paddle();
    ball = Ball(this, paddle);  // Pass the game and paddle instance to the Ball component

    add(paddle);
    add(ball);

    add(ScreenHitbox());

    // Initialize and add the score text component
    scoreText = TextComponent(
      text: 'Score: $score',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      position: Vector2(10, 10),
    );
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (ball.position.y > size.y) {
      pauseEngine(); // Pause the game engine
      _saveScores(); // Save the scores
      _showGameOverDialog(); // Show the game-over dialog
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        paddle.move(-1);  // Move left
      } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
        paddle.move(1);  // Move right
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA || event.logicalKey == LogicalKeyboardKey.keyD) {
        paddle.move(0);  // Stop moving
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void onTapDown(TapDownInfo info) {
    final touchPosition = info.eventPosition.global;
    if (touchPosition.x < paddle.position.x) {
      paddle.move(-1);  // Move left towards the edge of the screen
    } else {
      paddle.move(1);  // Move right towards the edge of the screen
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    paddle.move(0);
  }

  // Function to save the latest and best scores
  Future<void> _saveScores() async {
    final scoreStored = await SharedPreferences.getInstance();
    await scoreStored.setInt('lastScore', score);

    final bestScore = scoreStored.getInt('bestValues') ?? 0;
    if (score > bestScore) {
      await scoreStored.setInt('bestValues', score);
    }
  }

  // Function to show the game-over dialog
  void _showGameOverDialog() {
    showDialog(
      context: buildContext!, // Use the game's build context
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners for the dialog
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Spacing
              const Text(
                'SCORE',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 48,
                  color: Color(0xFFB01EFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Spacing
              // Button width
              SizedBox(
                width: 300,
                child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'scores'); // Navigate to the scores screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Button background color
                            foregroundColor: Colors.white, // Button text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20), // Button padding
                          ),
                          child: const Text(
                            'Scores',
                            style: TextStyle(fontSize: 18), // Button text style
                          ),
                        ),
              ),
              const SizedBox(height: 20), // Spacing
              // Button width
              SizedBox(
                width: 300,
                child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          _restartGame(); // Restart the game
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB01EFF), // Button background color
                          foregroundColor: Colors.white, // Button text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20), // Button padding
                        ),
                        child: const Text(
                          'Play again',
                          style: TextStyle(fontSize: 18), // Button text style
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to restart the game
  void _restartGame() {
    resumeEngine(); // Resume the game engine
    resetGame(); // Reset game state
    updateScoreText(); // Update the score text
  }

  // Function to increment the score
  void incrementScore() {
    score += 1; // Increment score by 1
    updateScoreText(); // Update the score text
  }

  // Function to update the score text
  void updateScoreText() {
    scoreText.text = 'Score: $score';
  }

  // Function to reset the game state
  void resetGame() {
    score = 0;
    ball.reset();
    paddle.move(0);
    updateScoreText();
  }
}

// Background component to render the gradient background
class Background extends Component with HasGameRef {
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF645AFF), Color(0xFFB01EFF)],
      ).createShader(Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y));
    canvas.drawRect(Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y), paint);  // Draw the background gradient
  }

  @override
  void update(double dt) {}
}


class Paddle extends PositionComponent with HasGameRef, CollisionCallbacks, KeyboardHandler {
  late RectangleHitbox hitbox;  // Hitbox for collision detection
  static const double speed = 300;  // Speed of the paddle
  double moveDirection = 0;  // Direction the paddle is moving: -1 (left), 1 (right), 0 (stationary)

  Paddle() {
    position = Vector2(200, 550);  // Initial position of the paddle
    size = Vector2(100, 20);  // Size of the paddle
    anchor = Anchor.center;  // Anchor point of the paddle
    hitbox = RectangleHitbox();  // Initialize hitbox
    add(hitbox);  // Add hitbox to the component
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = Colors.black);  // Draw the paddle
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += moveDirection * speed * dt;  // Update position based on moveDirection and speed
    position.x = position.x.clamp(0 + size.x/2, gameRef.size.x - size.x/2);  // Ensure the paddle stays within the screen bounds
  }

  // Method to move the paddle in a specified direction
  void move(double direction) {
    moveDirection = direction;
  }
}

// Ball component
class Ball extends CircleComponent with HasGameRef, CollisionCallbacks {
  late Vector2 velocity;  // Velocity of the ball
  final BouncingBallGame game;  // Reference to the game instance
  final Paddle paddle; // Reference to the paddle instance

  Ball(this.game, this.paddle) {
    radius = 10;  // Radius of the ball
    position = Vector2(250, 300);  // Initial position of the ball
    anchor = Anchor.center;  // Anchor point of the ball
    velocity = Vector2(200, -200);  // Initial velocity of the ball
    add(CircleHitbox());  // Add hitbox for collision detection
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;  // Update the position of the ball

    // Bounce off the left and right walls
    if (position.x <= 0 || position.x >= gameRef.size.x) {
      velocity.x = -velocity.x;
    }
    // Bounce off the top wall
    if (position.y <= 0) {
      velocity.y = -velocity.y;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Bounce off the paddle
    if (other is Paddle) {
      // Calculate the relative hit position on the paddle
      double relativeIntersectX = (paddle.position.x - position.x) / (paddle.size.x / 2);
      double bounceAngle = relativeIntersectX * 40; // Max bounce angle of 40 degrees

      // Convert bounce angle to radians
      double bounceAngleRad = bounceAngle * (pi / 180);

      // Update ball velocity based on the bounce angle
      velocity = Vector2(
        velocity.length * -sin(bounceAngleRad),
        velocity.length * -cos(bounceAngleRad),
      );

      game.incrementScore(); // Increment score when the ball hits the paddle
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, radius, Paint()..color = Colors.white);  // Draw the ball
  }

  // Method to reset the ball's position and velocity
  void reset() {
    position = Vector2(250, 300);  // Reset the ball position
    velocity = Vector2(200, -200);  // Reset the ball velocity
  }
}
