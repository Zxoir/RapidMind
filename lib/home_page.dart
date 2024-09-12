import 'package:flutter/material.dart';
import 'math_quiz_page.dart';
import 'gunslinger_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: const Text(
                '🎮 Games',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('✖️ Math Quiz'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathQuizPage()),
                );
              },
            ),
            ListTile(
              title: const Text('🔫 Gunslinger'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GunslingerPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: const Text('Welcome to the games app by Zxoir'),
      ),
    );
  }
}