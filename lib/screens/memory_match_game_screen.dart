import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mental_fitness/ad_helper.dart';
import 'package:mental_fitness/models/memory_match_game.dart';

class MemoryMatchGameScreen extends StatefulWidget {
  const MemoryMatchGameScreen({super.key});

  @override
  _MemoryMatchGameScreenState createState() => _MemoryMatchGameScreenState();
}

class _MemoryMatchGameScreenState extends State<MemoryMatchGameScreen> {
  late BannerAd _bannerAd;

  bool _isAdLoaded = false;
  late MemoryMatchGame game;

  @override
  void initState() {
    super.initState();
    game = MemoryMatchGame();
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
    if (game.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('카드 짝 맞추기 게임'),
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
                  crossAxisCount: 4, // 여기서 카드의 개수를 결정합니다.
                  childAspectRatio: 1, // 1:1 비율로 카드가 표시되도록 설정
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: game.cards.length,
                itemBuilder: (context, index) {
                  return _buildCard(context, index);
                },
              ),
            ),
            if (game.isGameOver)
              ElevatedButton(
                child: const Text('다시 시작'),
                onPressed: () {
                  setState(() {
                    game.startGame();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          game.selectCard(index);
        });
      },
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

  void _showCompletionDialog(BuildContext context) {
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
                setState(() {
                  game.startGame();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
