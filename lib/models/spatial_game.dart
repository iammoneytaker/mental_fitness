import 'package:mental_fitness/models/game.dart';
import 'dart:math';

class SpatialGame extends Game {
  late List<List<bool>> baseShape;
  late List<List<List<bool>>> options;
  late int correctAnswer;

  @override
  void startGame() {
    setScore(0);
    setLevel(1);
    setIsCompleted(false);
    generateNewPuzzle();
  }

  @override
  void endGame() {
    completeGame();
  }

  void generateNewPuzzle() {
    int size = 3 + (level ~/ 3); // 레벨이 올라갈수록 도형 크기 증가
    baseShape = generateRandomShape(size);
    options = List.generate(4, (_) => transformShape(baseShape));
    correctAnswer = Random().nextInt(4);
    options[correctAnswer] =
        List.from(baseShape.map((row) => List<bool>.from(row)));
    notifyListeners();
  }

  List<List<bool>> generateRandomShape(int size) {
    return List.generate(
        size, (_) => List.generate(size, (_) => Random().nextBool()));
  }

  List<List<bool>> transformShape(List<List<bool>> shape) {
    List<List<bool>> transformed =
        List.from(shape.map((row) => List<bool>.from(row)));
    int operation = Random().nextInt(3);
    switch (operation) {
      case 0: // 회전
        transformed = rotateShape(transformed);
        break;
      case 1: // 대칭
        transformed = mirrorShape(transformed);
        break;
      case 2: // 이동
        transformed = shiftShape(transformed);
        break;
    }
    return transformed;
  }

  List<List<bool>> rotateShape(List<List<bool>> shape) {
    int n = shape.length;
    var rotated = List.generate(n, (_) => List<bool>.filled(n, false));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        rotated[j][n - 1 - i] = shape[i][j];
      }
    }
    return rotated;
  }

  List<List<bool>> mirrorShape(List<List<bool>> shape) {
    return shape.map((row) => row.reversed.toList()).toList();
  }

  List<List<bool>> shiftShape(List<List<bool>> shape) {
    int n = shape.length;
    int shiftX = Random().nextInt(2) - 1;
    int shiftY = Random().nextInt(2) - 1;
    var shifted = List.generate(n, (_) => List<bool>.filled(n, false));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        int newI = (i + shiftY + n) % n;
        int newJ = (j + shiftX + n) % n;
        shifted[newI][newJ] = shape[i][j];
      }
    }
    return shifted;
  }

  bool checkAnswer(int selectedIndex) {
    if (selectedIndex == correctAnswer) {
      incrementScore(10);
      nextLevel();
      generateNewPuzzle();
      return true;
    }
    return false;
  }
}
