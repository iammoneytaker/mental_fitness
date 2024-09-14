import 'package:flutter/material.dart';
import 'package:mental_fitness/screens/memory_game_screen.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Game'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildGameCard(context, 'Memory Game', MemoryGameScreen()),
          _buildGameCard(context, 'Spatial Game', null),
          _buildGameCard(context, 'Language Game', null),
          _buildGameCard(context, 'Rotation Game', null),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, Widget? screen) {
    return Card(
      child: InkWell(
        onTap: screen != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              }
            : null,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
