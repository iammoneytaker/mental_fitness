// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:mental_fitness/screens/game_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('두뇌 트레이닝'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '두뇌 트레이닝에 오신 것을 환영합니다!',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              child: const Text('훈련 시작하기'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameSelectionScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
