import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_time/data/game_data_manager.dart';
import 'package:math_time/data/game_provider.dart';
import 'package:math_time/style/text_styles.dart';
import 'package:math_time/util/util.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'main_screen.dart';

class ResultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    GameProvider provider = Provider.of<GameProvider>(context, listen: false);
    GameDataManager(context).saveData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '게임 종료',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            DataTable(columns: <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    '게임 통계',
                    style: TextStyles.title2,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    '',
                    style: TextStyles.title2,
                  ),
                ),
              ),
            ], rows: <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('게임 모드')),
                  DataCell(Text(provider.gameMode.name)),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('난이도')),
                  DataCell(Text(provider.difficulty.name)),
                ],
              ),
              if(provider.gameMode == GameMode.fixedAmount)
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('총 문제')),
                    DataCell(Text('${provider.submittedProblems}')),
                  ],
                ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('맞힌 문제')),
                  DataCell(Text('${provider.correctProblems}')),
                ],
              ),
              if(provider.gameMode == GameMode.fixedAmount)
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('남은 시간')),
                    DataCell(Text(Util.timeFormat(provider.leftSeconds))),
                  ],
                ),
            ]),
            SizedBox(height: 10),
            Text('EXP +${provider.exp}', style: TextStyles.regular,),
            SizedBox(height: 10),
            Text('정답 제출 +${provider.correctXP} XP', style: TextStyles.small,),
            if(provider.gameMode == GameMode.fixedAmount)
              Text('오답 제출 +${provider.incorrectXP} XP', style: TextStyles.small,),
            Text('난이도 정확도 +${provider.difficultyXP} XP', style: TextStyles.small,),
            if(provider.gameMode == GameMode.fixedAmount)
              Text('시간 정확도 +${provider.timeXP} XP', style: TextStyles.small,),
            if(provider.gameMode == GameMode.continuous)
              Text('연속 정확도 +${provider.continuousXP} XP', style: TextStyles.small,),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text('메인 화면으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
