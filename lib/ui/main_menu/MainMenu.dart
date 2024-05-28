// lib/home_page.dart
import 'package:flutter/material.dart';

// MainMenu screen that provides navigation to the game screen and scores screen
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the structure for the main menu screen
      body: Container(
        // Container with a gradient background decoration
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF645AFF), Color(0xFFB01EFF)], // Gradient colors
          ),
        ),
        // Center the child widget
        child: Center(
          // Column to arrange the buttons vertically
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Button width
              SizedBox(
                width: 300,
              // Start button
                child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the game screen when pressed
                          Navigator.pushNamed(context, 'gamescreen');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Button background color
                          foregroundColor: Colors.black, // Button text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20), // Button padding
                        ),
                        child: const Text(
                          'Start',
                          style: TextStyle(fontSize: 18), // Button text style
                        ),
                      ),
              ),
              const SizedBox(height: 20), // Spacing between the buttons
              // Button width
              SizedBox(
                width: 300,
              // Scores button
                child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the scores screen when pressed
                          Navigator.pushNamed(context, 'scores');
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
            ],
          ),
        ),
      ),
    );
  }
}