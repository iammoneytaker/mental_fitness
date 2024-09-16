import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mental_fitness/ad_helper.dart';
import 'package:mental_fitness/models/language_game.dart';

class LanguageGameScreen extends StatefulWidget {
  const LanguageGameScreen({super.key});

  @override
  _LanguageGameScreenState createState() => _LanguageGameScreenState();
}

class _LanguageGameScreenState extends State<LanguageGameScreen> {
  late BannerAd _bannerAd;

  bool _isAdLoaded = false;
  late LanguageGame game;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    game = LanguageGame();
    game.startGame();
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
        title: const Text('언어 능력 게임'),
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
                  Text('레벨: ${game.level}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('점수: ${game.score}',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                game.level <= 6 ? '단어의 철자를 맞춰보세요' : '문장을 올바르게 배열하세요',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    game.shuffledPieces.length,
                    (index) => _buildAnswerTile(context, index),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: game.shuffledPieces
                    .map((piece) => _buildPieceTile(context, piece))
                    .toList(),
              ),
            ),
            ElevatedButton(
              child: const Text('확인', style: TextStyle(fontSize: 24)),
              onPressed: () => _checkAnswer(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (game.userAnswer[index].isNotEmpty) {
            game.removeLetterFromAnswer(index);
          }
        });
      },
      child: Container(
        width: game.level <= 6 ? 60 : 120,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          game.userAnswer[index],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPieceTile(BuildContext context, String piece) {
    return GestureDetector(
      onTap: () {
        setState(() {
          int emptyIndex = game.userAnswer.indexOf('');
          if (emptyIndex != -1) {
            game.updateUserAnswer(emptyIndex, piece);
          }
        });
      },
      child: Container(
        width: game.level <= 6 ? 60 : 120,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          piece,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _checkAnswer(BuildContext context) {
    setState(() {
      if (game.checkAnswer()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('정답입니다!'),
              content: const Text('다음 단어로 넘어갑니다.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('계속하기'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('틀렸습니다'),
              content: Text('정답은 "${game.currentPuzzle}"입니다. 게임을 다시 시작합니다.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('다시 시작'),
                  onPressed: () {
                    game.startGame();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
}
