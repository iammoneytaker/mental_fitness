import 'package:flutter/material.dart';
import 'package:mental_fitness/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:mental_fitness/screens/home_screen.dart';
import 'package:mental_fitness/providers/game_provider.dart';
import 'package:mental_fitness/providers/game_system_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 광고 구현하기 ( 힌트? 목숨? )

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => GameSystemProvider()),
      ],
      child: const MyApp(),
    ),
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
