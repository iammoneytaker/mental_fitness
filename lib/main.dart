import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mental_fitness/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:mental_fitness/screens/home_screen.dart';
import 'package:mental_fitness/providers/game_provider.dart';
import 'package:mental_fitness/services/ad_service.dart';
import 'package:mental_fitness/providers/game_system_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => GameSystemProvider()),
        Provider(create: (context) => AdService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final adService = Provider.of<AdService>(context, listen: false);
    adService.initBannerAd();
    adService.initInterstitialAd();
    adService.initRewardedAd();

    return MaterialApp(
      title: 'Mental Fitness',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
