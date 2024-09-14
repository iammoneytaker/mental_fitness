import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_fitness/models/memory_match_game.dart';

class MemoryMatchGameScreen extends StatelessWidget {
  const MemoryMatchGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MemoryMatchGame(),
      child: const _MemoryMatchGameView(),
    );
  }
}

class _MemoryMatchGameView extends StatelessWidget {
  const _MemoryMatchGameView();

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<MemoryMatchGame>(context);

    if (game.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog(context, game);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('카드 짝 맞추기 게임'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('점수: ${game.score}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('시간: ${game.remainingTime}초',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: game.cards.length,
                itemBuilder: (context, index) {
                  return _buildCard(context, game, index);
                },
              ),
            ),
            if (game.isGameOver)
              ElevatedButton(
                child: const Text('다시 시작'),
                onPressed: () => game.startGame(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, MemoryMatchGame game, int index) {
    return GestureDetector(
      onTap: () => game.selectCard(index),
      child: Container(
        decoration: BoxDecoration(
          color: game.cards[index].isFlipped || game.cards[index].isMatched
              ? Colors.blue
              : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            game.cards[index].isFlipped || game.cards[index].isMatched
                ? game.cards[index].content
                : '',
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

  void _showCompletionDialog(BuildContext context, MemoryMatchGame game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('축하합니다!'),
          content: Text('모든 레벨을 클리어했습니다!\n최종 점수: ${game.score}'),
          actions: [
            TextButton(
              child: const Text('처음부터 다시 시작'),
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
