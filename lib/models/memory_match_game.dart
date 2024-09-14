import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:mental_fitness/models/game.dart';

class Card {
  final String content;
  bool isFlipped;
  bool isMatched;

  Card(this.content, {this.isFlipped = false, this.isMatched = false});
}

//TODO:  게임하다가 뒤로가기 했을때 에러 처리 해야함 FlutterError (A MemoryMatchGame was used after being disposed.
// Once you have called dispose() on a MemoryMatchGame, it can no longer be used.)

class MemoryMatchGame extends Game {
  List<Card> cards = [];
  Card? firstSelectedCard;
  Card? secondSelectedCard;
  late Timer timer;
  int remainingTime = 60;
  bool isGameOver = false;

  static const List<String> cardContents = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  ];

  MemoryMatchGame() {
    startGame();
  }

  @override
  void startGame() {
    setScore(0);
    setLevel(1);
    setIsCompleted(false);
    isGameOver = false;
    remainingTime = 60;
    initializeCards();
    startTimer();
  }

  void initializeCards() {
    cards = [];
    int numPairs = min(2 + level, 18);
    List<String> selectedContents = cardContents.sublist(0, numPairs);
    List<String> allContents = [...selectedContents, ...selectedContents];
    allContents.shuffle(Random());
    for (var content in allContents) {
      cards.add(Card(content));
    }
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        notifyListeners();
      } else {
        endGame();
      }
    });
  }

  void selectCard(int index) {
    if (isGameOver || cards[index].isFlipped || cards[index].isMatched) return;

    if (firstSelectedCard == null) {
      firstSelectedCard = cards[index];
      firstSelectedCard!.isFlipped = true;
    } else if (secondSelectedCard == null) {
      secondSelectedCard = cards[index];
      secondSelectedCard!.isFlipped = true;

      if (firstSelectedCard!.content == secondSelectedCard!.content) {
        firstSelectedCard!.isMatched = true;
        secondSelectedCard!.isMatched = true;
        incrementScore(10);
        firstSelectedCard = null;
        secondSelectedCard = null;

        if (cards.every((card) => card.isMatched)) {
          if (level < 9) {
            nextLevel();
            initializeCards();
            remainingTime = 60;
            notifyListeners();
          } else {
            endGame();
            setIsCompleted(true);
            notifyListeners();
          }
        }
      } else {
        decrementScore(1);
        Future.delayed(const Duration(milliseconds: 500), () {
          firstSelectedCard?.isFlipped = false;
          secondSelectedCard?.isFlipped = false;
          firstSelectedCard = null;
          secondSelectedCard = null;
          notifyListeners();
        });
      }
    }

    notifyListeners();
  }

  void decrementScore(int amount) {
    setScore(max(0, score - amount));
  }

  @override
  void endGame() {
    isGameOver = true;
    timer.cancel();
    completeGame();
  }
}
