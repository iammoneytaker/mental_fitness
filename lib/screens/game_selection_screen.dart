// lib/screens/game_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:mental_fitness/screens/language_game_screen.dart';
import 'package:mental_fitness/screens/memory_game_screen.dart';
import 'package:mental_fitness/screens/memory_match_game_screen.dart';
import 'package:mental_fitness/screens/spatial_game_screen.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게임 선택'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          _buildGameCard(context, '기억력 게임', const MemoryGameScreen()),
          _buildGameCard(context, '카드 짝 맞추기', const MemoryMatchGameScreen()),
          _buildGameCard(context, '공간 지각 게임', const SpatialGameScreen()),
          _buildGameCard(context, '언어 능력 게임', const LanguageGameScreen()),
          _buildGameCard(context, '회전 능력 게임', null),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, Widget? screen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
