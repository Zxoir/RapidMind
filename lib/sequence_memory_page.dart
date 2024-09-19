import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SequenceMemoryPage extends StatefulWidget {
  const SequenceMemoryPage({super.key});

  @override
  State<SequenceMemoryPage> createState() => _SequenceMemoryState();
}

class _SequenceMemoryState extends State<SequenceMemoryPage> {
  final List<int> _sequence = [];
  final List<int> _userSequence = [];
  bool _isAnimating = true;
  final List<Color> _cellColors = List.generate(9, (_) => Colors.grey);
  int _level = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _sequence.clear();
      _userSequence.clear();
      _generateSequence();
      _animateSequence();
      _level = 0;
    });
  }

  void _generateSequence() {
    _sequence.add(Random().nextInt(9)); // Add a random cell index
  }

  Future<void> _animateSequence() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isAnimating = true;
    });

    for (int index in _sequence) {
      _highlightCell(index, Colors.blue);
      await Future.delayed(const Duration(milliseconds: 500));
      _highlightCell(index, Colors.grey);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      _isAnimating = false;
    });
  }

  void _highlightCell(int index, Color color) {
    setState(() {
      _cellColors[index] = color;
    });
  }

  void _handleTap(int index) {
    if (_isAnimating) return;

    setState(() {
      _userSequence.add(index);
      _highlightCell(index, Colors.green);
    });

    // Delay to revert the color after the user taps
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _cellColors[index] = Colors.grey; // Revert color
      });
    });

    if (_sequence.isNotEmpty) {
      _checkSequence();
    }
  }

  void _checkSequence() {
    if (_userSequence[_userSequence.length - 1] !=
        _sequence[_userSequence.length - 1]) {
      _showGameOverDialog();
      return;
    }

    if (_userSequence.length == _sequence.length) {
      _level++;
      _userSequence.clear();
      _generateSequence();
      _animateSequence();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('You failed to match the sequence.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startNewGame();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Sequence'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gridSize =
                    min(constraints.maxWidth, constraints.maxHeight) * 0.8;
                return SizedBox(
                  width: gridSize,
                  height: gridSize,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _handleTap(index),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          color: _cellColors[index],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16), // Space between grid and text
          Text(
            'Level: $_level',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
