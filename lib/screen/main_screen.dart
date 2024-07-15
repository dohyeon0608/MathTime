import 'package:flutter/material.dart';
import 'package:math_time/main.dart';
import 'package:math_time/screen/problem_screen.dart';
import 'package:math_time/style/text_styles.dart';
import 'package:math_time/widgets/selector_widget.dart';
import 'package:provider/provider.dart';

import '../data/game_data_manager.dart';
import '../data/game_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen._privateConstructor();
  static const MainScreen _instance = MainScreen._privateConstructor();

  factory MainScreen() => _instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Math Challenge'),
              ),
              body: Center(
                child: Text(
                  "Now Loading...",
                  style: TextStyles.title,
                ),
              ));
        } else if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Math Challenge'),
              ),
              body: Center(
                child: Text(
                  "데이터를 불러오는 데 실패했습니다.",
                  style: TextStyles.title,
                ),
              ));
        } {
          return Scaffold(
            appBar: AppBar(
              title: Text('Math Challenge'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CurrentLevelAndXP(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text("게임 모드 선택",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          GameModeSelector(
                            options: [
                              GameMode.fixedAmount.name,
                              GameMode.continuous.name
                            ],
                            images: [
                              'assets/fixed_amount.png',
                              'assets/continuous.png'
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 300,
                              child: Text(
                                  style: TextStyles.regular,
                                  '"빨리빨리 수학"은 주어진 문제들을 시간 내에 풀어야 하는 모드이고, "어디까지 수학"은 문제들을 정확하게 계속 풀어나가야 하는 모드입니다.')),
                          const SizedBox(height: 20),
                          const Text("난이도 선택",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          GameDifficultySelector(
                            options: [
                              GameDifficulty.easy.name,
                              GameDifficulty.normal.name,
                              GameDifficulty.timesTable.name
                            ],
                            images: [
                              'assets/easy.png',
                              'assets/normal.png',
                              'assets/times_table.png'
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 300,
                              child: Text(
                                  style: TextStyles.regular,
                                  '"쉬움" 난이도는 초등학교 2학년 수준의 문제가 출제되며, "보통" 난이도는 초등학교 3학년 수준의 문제가 출제됩니다. "구구단"은 오직 구구단 문제만 나옵니다.')),
                        ],
                      ),
                    ),
                  ),
                  StartButton(),
                ],
              ),
            ),
          );
        }
      },
      future: GameDataManager(context).loadData(),
    );
  }
}

class CurrentLevelAndXP extends StatelessWidget {
  const CurrentLevelAndXP({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        double progress = provider.currentXP / provider.requiredXP;
        return Column(
          children: [
            Text(
              '레벨 ${provider.level}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      color: Colors.lightBlue,
                      value: progress,
                      minHeight: 20,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${provider.currentXP}/${provider.requiredXP} (${(progress * 100).floor()}%)',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class GameModeSelector extends SelectorWidget {
  GameModeSelector(
      {required List<String> options, required List<String> images, super.key})
      : super(options, images, 150);

  @override
  SelectorWidgetState createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends SelectorWidgetState<GameModeSelector> {
  @override
  void onSelected(int index) {
    Provider.of<GameProvider>(context, listen: false)
        .selectGameMode(GameModeExt.fromCode(index));
  }
}

class GameDifficultySelector extends SelectorWidget {
  GameDifficultySelector(
      {required List<String> options, required List<String> images, super.key})
      : super(options, images, 100);

  @override
  SelectorWidgetState createState() => _GameDifficultySelectorState();
}

class _GameDifficultySelectorState
    extends SelectorWidgetState<GameDifficultySelector> {
  @override
  void onSelected(int index) {
    Provider.of<GameProvider>(context, listen: false)
        .selectGameDifficulty(GameDifficultyExt.fromCode(index));
  }
}

class StartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(8.0),
          width: 500,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false)
                  .resetProblemIndex();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProblemScreen(difficulty: provider.difficulty),
                ),
              );
            },
            child: Text('게임 시작'),
          ),
        );
      },
    );
  }
}
