import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  int level = 1;
  int currentXP = 0;
  int requiredXP = 100;
  GameMode selectedGameMode = GameMode.fixedAmount;
  GameDifficulty selectedGameDifficulty = GameDifficulty.easy;

  void selectGameMode(GameMode mode) {
    selectedGameMode = mode;
    notifyListeners();
  }

  void selectGameDifficulty(GameDifficulty difficulty) {
    selectedGameDifficulty = difficulty;
    notifyListeners();
  }

  void gainXP(int xp) {
    currentXP += xp;
    if (currentXP >= requiredXP) {
      levelUp();
    }
    notifyListeners();
  }

  void levelUp() {
    level += 1;
    currentXP -= requiredXP;
    requiredXP = (requiredXP * 1.1).toInt();
    notifyListeners();
  }
}

enum GameMode { fixedAmount, continuous }

extension GameModeExt on GameMode {
  static final _code = {
    GameMode.fixedAmount: 0, GameMode.continuous: 1
  };
  static final _name = {
    GameMode.fixedAmount: "빨리빨리 수학", GameMode.continuous: "어디까지 수학"
  };

  int get code => _code[this]!;
  String get name => _name[this]!;

  static GameMode fromCode(int code) {
    if (code == 0){
      return GameMode.fixedAmount;
    }
    else {
      return GameMode.continuous;
    }
  }
}

enum GameDifficulty { easy, normal, timesTable }

extension GameDifficultyExt on GameDifficulty {
  static final _code = {
    GameDifficulty.easy: 0, GameDifficulty.normal: 1, GameDifficulty.timesTable: 2
  };
  static final _name = {
    GameDifficulty.easy: "쉬움", GameDifficulty.normal: "보통", GameDifficulty.timesTable: "구구단"
  };

  int get code => _code[this]!;
  String get name => _name[this]!;

  static GameDifficulty fromCode(int code) {
    if (code == 0){
      return GameDifficulty.easy;
    }
    else if (code == 1) {
      return GameDifficulty.normal;
    } else {
      return GameDifficulty.timesTable;
    }
  }
}