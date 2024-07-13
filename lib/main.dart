import 'package:flutter/material.dart';
import 'package:math_time/style/text_styles.dart';
import 'package:math_time/widgets/selector_widget.dart';
import 'package:provider/provider.dart';

import 'data/game_data_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Math Challenge',
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Challenge'),
      ),
      body: Column(
        children: [
          CurrentLevelAndXP(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text("게임 모드 선택", style: TextStyles.title2,),
                  const SizedBox(height: 10),
                  GameModeSelector(),
                  const SizedBox(height: 20),
                  Text("난이도 선택", style: TextStyles.title2,),
                  const SizedBox(height: 10),
                  GameDifficultySelector(),
                ],
              ),
            ),
          ),
          StartButton(),
        ],
      ),
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
  GameModeSelector({super.key}) : super([GameMode.fixedAmount.name, GameMode.continuous.name]);

  @override
  SelectorWidgetState<GameModeSelector> createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends SelectorWidgetState<GameModeSelector> {
  @override
  void onSelected(int index) {
    Provider.of<GameProvider>(context, listen: false).selectGameMode(GameModeExt.fromCode(index));
  }
}

class GameDifficultySelector extends SelectorWidget {
  GameDifficultySelector({super.key}) : super([GameDifficulty.easy.name, GameDifficulty.normal.name, GameDifficulty.timesTable.name]);

  @override
  SelectorWidgetState<GameDifficultySelector> createState() => _GameDifficultySelectorState();
}

class _GameDifficultySelectorState extends SelectorWidgetState<GameDifficultySelector> {
  @override
  void onSelected(int index) {
    Provider.of<GameProvider>(context, listen: false).selectGameDifficulty(GameDifficultyExt.fromCode(index));
  }
}

class StartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => {},
            child: Text('게임 시작'),
          ),
        );
      },
    );
  }
}
