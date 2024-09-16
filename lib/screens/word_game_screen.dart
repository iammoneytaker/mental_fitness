import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mental_fitness/ad_helper.dart';
import 'package:mental_fitness/models/word_association_game.dart';
import 'dart:async';

class WordAssociationGameScreen extends StatefulWidget {
  const WordAssociationGameScreen({super.key});

  @override
  _WordAssociationGameScreenState createState() =>
      _WordAssociationGameScreenState();
}

class _WordAssociationGameScreenState extends State<WordAssociationGameScreen> {
  late WordAssociationGame game;
  Timer? _debounce;
  List<bool> _buttonStates = List.generate(4, (_) => false);

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    game = WordAssociationGame();
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
    _debounce?.cancel();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 연상 게임'),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '레벨: ${game.level}  점수: ${game.score}',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '주어진 단어: ${game.currentWord}',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '어울리지 않는 단어를 찾으세요',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ...game.options.asMap().entries.map((entry) {
                        int index = entry.key;
                        String option = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonStates[index]
                                  ? Colors.red
                                  : Theme.of(context).primaryColor,
                            ),
                            child: Text(option),
                            onPressed: () => _checkAnswer(index),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAnswer(int selectedIndex) {
    if (_debounce?.isActive ?? false) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (game.checkAnswer(selectedIndex)) {
          if (game.isCompleted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('게임 완료'),
                content: Text('축하합니다! 최종 점수: ${game.score}'),
                actions: [
                  TextButton(
                    child: const Text('다시 시작'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        game.startGame();
                        _resetButtonStates();
                      });
                    },
                  ),
                ],
              ),
            );
          } else {
            _resetButtonStates();
          }
        } else {
          _buttonStates[selectedIndex] = true;
        }
      });
    });
  }

  void _resetButtonStates() {
    _buttonStates = List.generate(4, (_) => false);
  }
}
