import 'package:flutter/foundation.dart';

abstract class Game with ChangeNotifier {
  int _score = 0;
  int _level = 1;
  bool _isCompleted = false;

  int get score => _score;
  int get level => _level;
  bool get isCompleted => _isCompleted;

  void setScore(int value) {
    _score = value;
    notifyListeners();
  }

  void setLevel(int value) {
    _level = value;
    notifyListeners();
  }

  void setIsCompleted(bool value) {
    _isCompleted = value;
    notifyListeners();
  }

  void incrementScore(int amount) {
    _score += amount;
    notifyListeners();
  }

  void nextLevel() {
    _level++;
    notifyListeners();
  }

  void completeGame() {
    _isCompleted = true;
    notifyListeners();
  }

  void startGame();
  void endGame();
}
