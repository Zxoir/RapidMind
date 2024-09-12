import 'package:flutter/material.dart';
import 'dart:math';

class MathQuizPage extends StatefulWidget {
  const MathQuizPage({super.key});

  @override
  State<MathQuizPage> createState() => _MathQuizPageState();
}

class _MathQuizPageState extends State<MathQuizPage> {
  late String _question;
  late List<String> _options;
  late String _correctAnswer;
  late String _selectedAnswer;
  bool _isButtonDisabled = false;
  int _correctStreak = 0;
  String _feedbackMessage = '';
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    const int minRange = 1;
    const int maxRange = 10;
    int num1 = _random.nextInt(maxRange) + minRange;
    int num2 = _random.nextInt(maxRange) + minRange;
    String operator = _random.nextBool() ? '+' : 'x';
    int correctAnswer;

    if (operator == '+') {
      correctAnswer = num1 + num2;
    } else {
      correctAnswer = num1 * num2;
    }

    List<int> options = [correctAnswer];
    while (options.length < 4) {
      // If its addition then it generates a random number between 1-19
      // If its multiplication it generates a random number between 1-99
      int option = operator == '+' ? _random.nextInt(19) + 1 : _random.nextInt(99) + 1;
      if (!options.contains(option)) {
        options.add(option);
      }
    }
    options.shuffle();

    setState(() {
      _question = '$num1 $operator $num2 = ?';
      _options = options.map((e) => e.toString()).toList();
      _correctAnswer = correctAnswer.toString();
      _selectedAnswer = '';
      _feedbackMessage = '';
      _isButtonDisabled = false;
    });
  }

  Color _getButtonColor(String option) {
    if (_selectedAnswer.isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }
    if (option == _correctAnswer) {
      return Colors.green;
    } else if (option == _selectedAnswer) {
      return Colors.red;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getTextColor(String option) {
    return Colors.white;
  }

  void _checkAnswer(String answer) {
    if (_isButtonDisabled) {
      return;
    }

    setState(() {
      if (answer == _correctAnswer) {
        _feedbackMessage = 'Correct!';
        _correctStreak++;
      } else {
        _feedbackMessage = 'Wrong! The correct answer is $_correctAnswer.';
        _correctStreak = 0;
      }
      _selectedAnswer = answer;
    });

    _isButtonDisabled = true;

    Future.delayed(const Duration(seconds: 2), () {
      _generateQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Quiz'),
      ),
      body: Center(
        child: _question.isEmpty
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _question,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: TextStyle(
                color: _feedbackMessage.startsWith('Correct') ? Colors.green : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (_correctStreak >= 3)
              Text(
                'Streak: $_correctStreak 🔥',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                    color: Colors.amber
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(option),
                      minimumSize: const Size(60, 60),
                    ),
                    onPressed: () => _checkAnswer(option),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: _getTextColor(option),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}