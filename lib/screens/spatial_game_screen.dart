import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_fitness/models/spatial_game.dart';

class SpatialGameScreen extends StatelessWidget {
  const SpatialGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SpatialGame()..startGame(),
      child: const _SpatialGameView(),
    );
  }
}

class _SpatialGameView extends StatelessWidget {
  const _SpatialGameView();

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<SpatialGame>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('공간 지각 게임'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('레벨: ${game.level}',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('점수: ${game.score}',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '아래 도형과 같은 모양을 찾으세요',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: _buildShapeGrid(game.baseShape, large: true),
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(8.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () => _checkAnswer(context, game, index),
                    child: _buildShapeGrid(game.options[index]),
                  );
                }),
              ),
            ),
          ],
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

  void _checkAnswer(BuildContext context, SpatialGame game, int selectedIndex) {
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
        barrierDismissible: false, // 사용자가 다이얼로그 바깥을 터치해도 닫히지 않도록 설정
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('틀렸습니다'),
            content: const Text('게임을 다시 시작합니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('다시 시작'),
                onPressed: () {
                  game.startGame(); // 게임을 처음부터 다시 시작
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
