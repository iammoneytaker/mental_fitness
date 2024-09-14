import 'package:mental_fitness/models/game.dart';
import 'package:flutter/foundation.dart';

class MemoryGame extends Game {
  final List<String> _sequence = [];
  final List<String> _userSequence = [];

  List<String> get sequence => _sequence;

  void addToSequence(String item) {
    _sequence.add(item);
    notifyListeners();
  }

  void addToUserSequence(String item) {
    _userSequence.add(item);
    if (_userSequence.length == _sequence.length) {
      checkSequence();
    }
    notifyListeners();
  }

  void checkSequence() {
    if (listEquals(_sequence, _userSequence)) {
      incrementScore(10);
      nextLevel();
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

  @override
  void startGame() {
    _sequence.clear();
    _userSequence.clear();
    setScore(0);
    setLevel(1);
    setIsCompleted(false);
    addToSequence(generateRandomItem());
  }

  @override
  void endGame() {
    completeGame();
  }
}
