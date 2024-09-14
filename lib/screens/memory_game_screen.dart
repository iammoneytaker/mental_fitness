import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_fitness/models/memory_game.dart';

class MemoryGameScreen extends StatelessWidget {
  const MemoryGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MemoryGame(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Memory Game'),
        ),
        body: Consumer<MemoryGame>(
          builder: (context, game, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Level: ${game.level}',
                          style: Theme.of(context).textTheme.displayMedium),
                      Text('Score: ${game.score}',
                          style: Theme.of(context).textTheme.displayMedium),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: game.isCompleted
                        ? _buildGameOverView(context, game)
                        : _buildGameView(context, game),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameView(BuildContext context, MemoryGame game) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Remember this sequence:',
            style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              game.sequence.map((item) => _buildSequenceItem(item)).toList(),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text('Start'),
          onPressed: () {
            // Implement the logic to start the sequence display
          },
        ),
      ],
    );
  }

  Widget _buildSequenceItem(String item) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(item,
            style: const TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }

  Widget _buildGameOverView(BuildContext context, MemoryGame game) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Game Over', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 20),
        Text('Final Score: ${game.score}',
            style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text('Play Again'),
          onPressed: () {
            game.startGame();
          },
        ),
      ],
    );
  }
}
