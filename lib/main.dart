import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:singleplayerpong/ui/main_menu/MainMenu.dart';
import 'package:singleplayerpong/ui/scoresceen/ScoreScreen.dart';
import 'package:singleplayerpong/ui/gamescreen/GameScreen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:io' show Platform;


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized

  // Initialize the window manager
  await windowManager.ensureInitialized();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final Size screenSize = await DesktopWindow.getWindowSize();

    // Set the desired percentage of the screen size
    const double widthPercentage = 0.5;
    const double heightPercentage = 1;

    // Calculate the window size based on the screen size percentage
    final double windowWidth = screenSize.width * widthPercentage;
    final double windowHeight = screenSize.height * heightPercentage;

    // Set the window size and disable resizing
    await DesktopWindow.setWindowSize(Size(windowWidth, windowHeight));
    await DesktopWindow.setMinWindowSize(Size(windowWidth - 1, windowHeight - 1));
    await DesktopWindow.setMaxWindowSize(Size(windowWidth + 1, windowHeight + 1));
  }
  WindowOptions windowOptions = const WindowOptions(
    title: 'Singeplayer Pong',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const Pong());  
}

class Pong extends StatelessWidget {
  const Pong({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainMenu(), // Set MainMenu as the home screen
      onGenerateRoute: (settings) {
        if (settings.name == 'scores') {
          return MaterialPageRoute(
            builder: (context) => const ScoresScreen(),
          );
        } else if (settings.name == 'gamescreen') {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final game = BouncingBallGame();
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: GameWidget(game: game),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            game.pauseEngine(); // Pause the game
                            game.resetGame(); // Reset the game state
                            // Navigate to the menu screen when pressed
                            Navigator.of(context).popUntil((route) => route.isFirst);  // Navigate back to the home screen
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                'X',
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
        return null;
      },
    );
  }
}