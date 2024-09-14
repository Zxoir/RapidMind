import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GunslingerPage extends StatefulWidget {
  const GunslingerPage({super.key});

  @override
  State<GunslingerPage> createState() => _GunslingerPageState();
}

class _GunslingerPageState extends State<GunslingerPage> {
  String _resultMessage = ''; // Initialize with an empty string
  bool _isGameActive = false;
  late Stopwatch _stopwatch;
  late Timer _timer;

  void _startGame() {
    setState(() {
      _resultMessage = ''; // Reset result message
      _isGameActive = true;
      _stopwatch = Stopwatch();
      _timer = Timer(Duration(seconds: Random().nextInt(5) + 1), () {
        if (_isGameActive) {
          setState(() {
            _stopwatch.start();
            _resultMessage = 'Tap the screen!';
          });
        }
      });
    });
  }

  void _tapScreen() {
    if (_isGameActive) {
      _isGameActive = false;
      setState(() {
        if (!_stopwatch.isRunning) {
          _resultMessage = 'You lost!';
        } else if (_stopwatch.elapsedMilliseconds < 1000) {
          _resultMessage = 'You won! Reaction time: ${_stopwatch.elapsedMilliseconds} ms';
        } else {
          _resultMessage = 'You lost! Reaction time: ${_stopwatch.elapsedMilliseconds} ms';
        }
      });
      _stopwatch.stop();
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gunslinger'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _tapScreen,
          child: Container(
            color: _isGameActive && _stopwatch.isRunning ? Colors.green : Colors.grey,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                _isGameActive && !_stopwatch.isRunning ? 'Wait for it...' : _resultMessage,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startGame,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}