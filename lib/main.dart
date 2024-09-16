import 'package:flutter/material.dart';
import 'package:mental_fitness/theme/app_theme.dart';
import 'package:mental_fitness/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 광고 구현하기 ( 힌트? 목숨? )

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '두뇌 트레이닝',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
