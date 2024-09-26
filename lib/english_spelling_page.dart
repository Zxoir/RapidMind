import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:word_generator/word_generator.dart';

class EnglishSpellingPage extends StatefulWidget {
  const EnglishSpellingPage({super.key});

  @override
  State<EnglishSpellingPage> createState() => _EnglishSpellingState();
}

class _EnglishSpellingState extends State<EnglishSpellingPage> {
  final FlutterTts flutterTts = FlutterTts();
  final wordGenerator = WordGenerator();
  final TextEditingController _controller = TextEditingController();
  String _randomWord = "";
  int _attempts = 0;
  final int _MAX_ATTEMPTS = 3;

  @override
  void initState() {
    super.initState();
    _randomWord = wordGenerator.randomNoun();
    _speak();
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(_randomWord);
  }

  void _checkSpelling() {
    if (_controller.text.toLowerCase() == _randomWord) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Correct!"),
          duration: Duration(seconds: 2),
        ),
      );
      _randomWord = WordGenerator().randomNoun();
      _speak();
      _controller.clear();
      _attempts = 0;
    } else {
      if (_attempts >= _MAX_ATTEMPTS) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Incorrect! The correct spelling was $_randomWord"),
            duration: Duration(seconds: 2),
          ),
        );
        _randomWord = WordGenerator().randomNoun();
        _speak();
        _controller.clear();
        _attempts = 0;
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try Again!")),
      );

      _attempts++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("English Spelling Quiz"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Type the word here',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _checkSpelling(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkSpelling,
              child: Text("Check Spelling"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _speak();
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
