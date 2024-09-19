import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int _fastestReactionTime = 99999999;

  @override
  void initState() {
    super.initState();
    _loadFastestReactionTime();
    _startGame();
  }

  void _loadFastestReactionTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fastestReactionTime = prefs.getInt('fastestReactionTime') ?? 0;
    });
  }

  void _saveFastestReactionTime(int reactionTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (reactionTime < _fastestReactionTime) {
      _fastestReactionTime = reactionTime;
      await prefs.setInt('fastestReactionTime', _fastestReactionTime);
    }
  }

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
        int reactionTime = _stopwatch.elapsedMilliseconds;
        if (!_stopwatch.isRunning) {
          _resultMessage = 'You lost!';
        } else if (reactionTime < 1000) {
          if (reactionTime < _fastestReactionTime) {
            _saveFastestReactionTime(reactionTime);
          }

          _resultMessage = 'You won! Reaction time: $reactionTime ms';
        } else {
          _resultMessage = 'You lost! Reaction time: $reactionTime ms';
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
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: _tapScreen,
              child: Container(
                color: _isGameActive && _stopwatch.isRunning
                    ? Colors.green
                    : Colors.grey,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: Text(
                    _isGameActive && !_stopwatch.isRunning
                        ? 'Wait for it...'
                        : _resultMessage,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Text(
              'Fastest Reaction: $_fastestReactionTime ms',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startGame,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
