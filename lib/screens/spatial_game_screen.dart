import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mental_fitness/ad_helper.dart';
import 'package:mental_fitness/models/spatial_game.dart';

class SpatialGameScreen extends StatefulWidget {
  const SpatialGameScreen({super.key});
  @override
  _SpatialGameScreenState createState() => _SpatialGameScreenState();
}

class _SpatialGameScreenState extends State<SpatialGameScreen> {
  late SpatialGame game;

  late BannerAd _bannerAd;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    game = SpatialGame();
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
        title: const Text('공간 지각 게임'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight -
                (_isAdLoaded ? _bannerAd.size.height : 0);
            return Column(
              children: [
                if (_isAdLoaded)
                  SizedBox(
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: availableHeight * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('레벨: ${game.level}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text('점수: ${game.score}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: availableHeight * 0.1,
                        child: Center(
                          child: Text(
                            '아래 도형과 같은 모양을 찾으세요',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: availableHeight * 0.3,
                        child: Center(
                          child: _buildShapeGrid(game.baseShape, large: true),
                        ),
                      ),
                      SizedBox(
                        height: availableHeight * 0.5,
                        child: GridView.count(
                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(4.0),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 1,
                          children: List.generate(4, (index) {
                            return GestureDetector(
                              onTap: () => _checkAnswer(index),
                              child: _buildShapeGrid(game.options[index]),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildShapeGrid(List<List<bool>> shape, {bool large = false}) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: EdgeInsets.all(large ? 8.0 : 4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: shape.length,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemCount: shape.length * shape.length,
          itemBuilder: (context, index) {
            int row = index ~/ shape.length;
            int col = index % shape.length;
            return Container(
              decoration: BoxDecoration(
                color: shape[row][col] ? Colors.blue : Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
            );
          },
        ),
      ),
    );
  }

  void _checkAnswer(int selectedIndex) {
    setState(() {
      if (game.checkAnswer(selectedIndex)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('정답입니다!'),
              content: const Text('다음 레벨로 넘어갑니다.'),
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
              content: const Text('게임을 다시 시작합니다.'),
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
