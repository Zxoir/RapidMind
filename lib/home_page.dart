import 'package:flutter/material.dart';
import 'package:rapid_mind/english_spelling_page.dart';
import 'package:rapid_mind/sequence_memory_page.dart';

import 'gunslinger_page.dart';
import 'math_quiz_page.dart';

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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
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
                  MaterialPageRoute(
                      builder: (context) => const GunslingerPage()),
                );
              },
            ),
            ListTile(
              title: const Text('🧩 Memory Sequence'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SequenceMemoryPage()),
                );
              },
            ),
            ListTile(
              title: const Text('✍ English Spelling'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EnglishSpellingPage()),
                );
              },
            )
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to the games app by Zxoir'),
      ),
    );
  }
}
