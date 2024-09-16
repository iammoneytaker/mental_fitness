import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mental_fitness/ad_helper.dart';
import 'package:mental_fitness/models/math_game.dart';

class MathGameScreen extends StatefulWidget {
  const MathGameScreen({super.key});

  @override
  _MathGameScreenState createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  late MathGame game;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    game = MathGame();
    game.startGame();
    _initBannerAd();
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('숫자 계산 게임'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_isAdLoaded)
              SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '레벨: ${game.level}  점수: ${game.score}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${game.num1} ${game.operator} ${game.num2} = ?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: game.options.map((option) {
                        return ElevatedButton(
                          child: Text(option.toString()),
                          onPressed: () {
                            setState(() {
                              if (game.checkAnswer(option)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('정답입니다!')),
                                );
                              } else {
                                game.endGame();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('게임 오버'),
                                    content: Text('최종 점수: ${game.score}'),
                                    actions: [
                                      TextButton(
                                        child: const Text('다시 시작'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            game.startGame();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
