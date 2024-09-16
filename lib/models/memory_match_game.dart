import 'dart:async';
import 'dart:math';

class Card {
  final String content;
  bool isFlipped;
  bool isMatched;

  Card(this.content, {this.isFlipped = false, this.isMatched = false});
}

class MemoryMatchGame {
  List<Card> cards = [];
  Card? firstSelectedCard;
  Card? secondSelectedCard;
  late Timer timer;
  int remainingTime = 60;
  bool isGameOver = false;
  int score = 0;
  int level = 1;
  bool isCompleted = false;

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

  void startGame() {
    score = 0;
    level = 1;
    isCompleted = false;
    isGameOver = false;
    remainingTime = 60;
    initializeCards();
    startTimer();
  }

  void initializeCards() {
    cards = [];
    int numPairs = min(2 + level, 12);
    List<String> selectedContents = cardContents.sublist(0, numPairs);
    List<String> allContents = [...selectedContents, ...selectedContents];
    allContents.shuffle(Random());
    for (var content in allContents) {
      cards.add(Card(content));
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
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
        score += 10;
        firstSelectedCard = null;
        secondSelectedCard = null;

        if (cards.every((card) => card.isMatched)) {
          endGame();
          if (level < 9) {
            level++;
            initializeCards();
            remainingTime = 60;
          } else {
            isCompleted = true;
          }
        }
      } else {
        score = max(0, score - 1);
        Future.delayed(const Duration(milliseconds: 500), () {
          firstSelectedCard?.isFlipped = false;
          secondSelectedCard?.isFlipped = false;
          firstSelectedCard = null;
          secondSelectedCard = null;
        });
      }
    }
  }

  void endGame() {
    isGameOver = true;
    timer.cancel();
  }
}
