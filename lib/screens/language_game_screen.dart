import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_fitness/models/language_game.dart';

class LanguageGameScreen extends StatelessWidget {
  const LanguageGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageGame()..startGame(),
      child: const _LanguageGameView(),
    );
  }
}

class _LanguageGameView extends StatelessWidget {
  const _LanguageGameView();

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<LanguageGame>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('언어 능력 게임'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('레벨: ${game.level}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('점수: ${game.score}',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                game.level <= 6 ? '단어의 철자를 맞춰보세요' : '문장을 올바르게 배열하세요',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    game.shuffledPieces.length,
                    (index) => _buildAnswerTile(context, game, index),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: game.shuffledPieces
                    .map((piece) => _buildPieceTile(context, game, piece))
                    .toList(),
              ),
            ),
            ElevatedButton(
              child: const Text('확인', style: TextStyle(fontSize: 24)),
              onPressed: () => _checkAnswer(context, game),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerTile(BuildContext context, LanguageGame game, int index) {
    return GestureDetector(
      onTap: () {
        if (game.userAnswer[index].isNotEmpty) {
          game.removeLetterFromAnswer(index);
        }
      },
      child: Container(
        width: game.level <= 6 ? 60 : 120,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          game.userAnswer[index],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPieceTile(
      BuildContext context, LanguageGame game, String piece) {
    return GestureDetector(
      onTap: () {
        int emptyIndex = game.userAnswer.indexOf('');
        if (emptyIndex != -1) {
          game.updateUserAnswer(emptyIndex, piece);
        }
      },
      child: Container(
        width: game.level <= 6 ? 60 : 120,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          piece,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _checkAnswer(BuildContext context, LanguageGame game) {
    if (game.checkAnswer()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('정답입니다!'),
            content: const Text('다음 단어로 넘어갑니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('계속하기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('틀렸습니다'),
            content: Text('정답은 "${game.currentPuzzle}"입니다. 게임을 다시 시작합니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('다시 시작'),
                onPressed: () {
                  game.startGame();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
