import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  int level = 1;
  int score = 0;
  List<int> sequence = [];
  List<int> userSequence = [];
  bool isShowingSequence = false;
  bool isUserTurn = false;
  int currentHighlight = 0;
  String sequenceText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showGameExplanation();
    });
  }

  void showGameExplanation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('게임 설명'),
          content: const Text('1. 화면에 나타나는 색상 순서를 잘 기억하세요.\n'
              '2. 색상이 모두 표시된 후, 같은 순서대로 색상을 눌러주세요.\n'
              '3. 순서를 맞추면 다음 레벨로 넘어갑니다.\n'
              '4. 틀리면 게임이 종료됩니다.\n\n'
              '준비되셨나요? 시작해볼까요?'),
          actions: <Widget>[
            TextButton(
              child: const Text('시작하기'),
              onPressed: () {
                Navigator.of(context).pop();
                startNewRound();
              },
            ),
          ],
        );
      },
    );
  }

  void startNewRound() {
    setState(() {
      sequence.add(Random().nextInt(4) + 1);
      isShowingSequence = true;
      isUserTurn = false;
      userSequence.clear();
      sequenceText = '';
    });
    showSequence();
  }

  void showSequence() async {
    await Future.delayed(const Duration(seconds: 1));
    for (int i = 0; i < sequence.length; i++) {
      int color = sequence[i];
      setState(() {
        currentHighlight = color;
        sequenceText = '${i + 1}번째';
      });
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        currentHighlight = 0;
        sequenceText = '';
      });
      await Future.delayed(const Duration(milliseconds: 300));
    }
    setState(() {
      isShowingSequence = false;
      isUserTurn = true;
      sequenceText = '순서대로 입력하세요';
    });
  }

  void checkUserInput(int tappedColor) {
    if (!isUserTurn) return;

    setState(() {
      currentHighlight = tappedColor;
    });
    HapticFeedback.lightImpact();

    userSequence.add(tappedColor);
    if (userSequence.last != sequence[userSequence.length - 1]) {
      gameOver();
      return;
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        currentHighlight = 0;
      });
    });

    if (userSequence.length == sequence.length) {
      score += 10;
      level++;
      setState(() {
        sequenceText = '정답입니다!';
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        startNewRound();
      });
    } else {
      setState(() {
        sequenceText = '${userSequence.length}번째 입력 완료';
      });
    }
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('게임 오버'),
          content: Text('최종 점수: $score\n최종 레벨: $level'),
          actions: <Widget>[
            TextButton(
              child: const Text('다시 시작'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  level = 1;
                  score = 0;
                  sequence.clear();
                  userSequence.clear();
                });
                startNewRound();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기억력 게임'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('레벨: $level',
                    style: Theme.of(context).textTheme.titleLarge),
                Text('점수: $score',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildColorButton(Colors.red, 1),
                _buildColorButton(Colors.green, 2),
                _buildColorButton(Colors.blue, 3),
                _buildColorButton(Colors.yellow, 4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              sequenceText,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color, int colorIndex) {
    return GestureDetector(
      onTap: () => checkUserInput(colorIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:
              currentHighlight == colorIndex ? color : color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            currentHighlight == colorIndex ? sequenceText : '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
