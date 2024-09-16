// memory_game.dart

import 'dart:math';

class MemoryGame {
  final List<String> _sequence = [];
  final List<String> _userSequence = [];

  List<String> get sequence => _sequence;

  int score = 0;
  int level = 1;
  bool isCompleted = false;

  void addToSequence(String item) {
    _sequence.add(item);
  }

  void addToUserSequence(String item) {
    _userSequence.add(item);
    if (_userSequence.length == _sequence.length) {
      checkSequence();
    }
  }

  void checkSequence() {
    if (_sequence == _userSequence) {
      score += 10;
      level++;
      _userSequence.clear();
      addToSequence(generateRandomItem());
    } else {
      endGame();
    }
  }

  String generateRandomItem() {
    // Implement logic to generate a random item
    return 'Item';
  }

  void startGame() {
    _sequence.clear();
    _userSequence.clear();
    score = 0;
    level = 1;
    isCompleted = false;
    addToSequence(generateRandomItem());
  }

  void endGame() {
    isCompleted = true;
  }
}
