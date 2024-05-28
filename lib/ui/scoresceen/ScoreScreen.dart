// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScoresScreenState createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  int lastScore = 0;  // Variable to store the last score
  int recordScore = 0;  // Variable to store the record score

  @override
  void initState() {
    super.initState();
    _loadScores();  // Load scores from SharedPreferences when the widget is initialized
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastScore = prefs.getInt('lastScore') ?? 0;
      recordScore = prefs.getInt('bestValues') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the structure for the scores screen
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
          // Card to display the scores and the Play game button
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Rounded corners for the card
            ),
            elevation: 5, // Elevation for shadow effect
            margin: const EdgeInsets.all(20), // Margin around the card
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding inside the card
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title text
                  const Text(
                    'Scores',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing
                  // Last score label
                  const Text(
                    'LAST SCORE',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // Display the last score value
                  Text(
                    '$lastScore',
                    style: const TextStyle(
                      fontSize: 48,
                      color: Color(0xFFB01EFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing
                  // Record score label
                  const Text(
                    'RECORD SCORE',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // Display the record score value
                  Text(
                    '$recordScore',
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
                  // Play game button
                  child: ElevatedButton(
                            onPressed: () {
                              // Navigate to the game screen when pressed
                              Navigator.pushNamed(context, 'gamescreen');
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
                              'Play game',
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
                                // Navigate to the menu screen when pressed
                                Navigator.of(context).popUntil((route) => route.isFirst);  // Navigate back to the home screen
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
                                'Return',
                                style: TextStyle(fontSize: 18), // Button text style
                              )
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}