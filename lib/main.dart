import 'package:flutter/material.dart';
import 'package:math_time/screen/main_screen.dart';
import 'package:provider/provider.dart';

import 'data/game_data_manager.dart';
import 'data/game_provider.dart';

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
// why
