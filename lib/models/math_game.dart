import 'dart:math';

class MathGame {
  int score = 0;
  int level = 1;
  bool isCompleted = false;
  late int num1;
  late int num2;
  late String operator;
  late int correctAnswer;
  List<int> options = [];

  void startGame() {
    score = 0;
    level = 1;
    isCompleted = false;
    generateNewProblem();
  }

  void generateNewProblem() {
    Random random = Random();
    num1 = random.nextInt(10 * level) + 1;
    num2 = random.nextInt(10 * level) + 1;

    List<String> operators = ['+', '-', '*'];
    operator = operators[random.nextInt(operators.length)];

    switch (operator) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
        correctAnswer = num1 - num2;
        break;
      case '*':
        correctAnswer = num1 * num2;
        break;
    }

    options = [correctAnswer];
    while (options.length < 4) {
      int wrongAnswer = correctAnswer + random.nextInt(21) - 10;
      if (!options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }
    options.shuffle();
  }

  bool checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      score += 10;
      level++;
      generateNewProblem();
      return true;
    }
    return false;
  }

  void endGame() {
    isCompleted = true;
  }
}
