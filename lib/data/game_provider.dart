import 'dart:math';

import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameMode _gameMode = GameMode.fixedAmount;
  GameDifficulty _difficulty = GameDifficulty.easy;

  int _level = 1;
  int _currentXP = 0;
  int _requiredXP = 100;

  void addXP(int xp) {
    _currentXP += xp;
    while(_currentXP >= _requiredXP) {
      _currentXP -= _requiredXP;
      _level += 1;
      _requiredXP = 100 + 10 * _level;
    }
    notifyListeners();
  }

  int _currentProblemIndex = 1;

  get currentProblemIndex => _currentProblemIndex;

  static const Map<GameDifficulty, int> _totalProblemsPerDifficulty = {
    GameDifficulty.easy: 10,
    GameDifficulty.normal: 15,
    GameDifficulty.timesTable: 20,
  };

  static const Map<GameDifficulty, int> _totalSecondPerDifficulty = {
    GameDifficulty.easy: 150,
    GameDifficulty.normal: 240,
    GameDifficulty.timesTable: 100,
  };

  static const Map<GameDifficulty, int> _extraExpPerDifficulty = {
    GameDifficulty.easy: 0,
    GameDifficulty.normal: 4,
    GameDifficulty.timesTable: 2,
  };

  int leftSeconds = 0;

  int submittedProblems = 0;
  int correctProblems = 0;

  GameMode get gameMode => _gameMode;
  GameDifficulty get difficulty => _difficulty;
  int get level => _level;
  int get currentXP => _currentXP;
  int get requiredXP => _requiredXP;
  int get totalProblems => _totalProblemsPerDifficulty[_difficulty]!;
  int get totalSeconds => _totalSecondPerDifficulty[_difficulty]!;
  int get extraExp => _extraExpPerDifficulty[_difficulty]!;

  int get incorrectProblems => submittedProblems - correctProblems;

  int get correctXP => correctProblems * 5;
  int get difficultyXP => correctProblems * extraExp;
  int get incorrectXP => incorrectProblems * 2;
  int get timeXP {
    if (leftSeconds <= 0 || correctProblems < 0 || submittedProblems <= 0) {
      return 0; // 기본값 설정
    }
    return ((leftSeconds / 4) * pow((correctProblems / submittedProblems), 3)).round();
  }
  int get continuousXP => (pow(correctProblems * 5, 0.7)).round();

  int get exp {
    int result = correctXP + difficultyXP;
    if(gameMode == GameMode.fixedAmount) {
      result += incorrectXP + timeXP;
    } else {
      result += continuousXP;
    }
    return result;
  }

  void selectGameMode(GameMode mode) {
    _gameMode = mode;
    notifyListeners();
  }

  void selectGameDifficulty(GameDifficulty difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }

  Map<String, String> generateQuestion() {
    Random random = Random();
    String question = "";
    String answer = "";
    int next(int min, int max) => min + random.nextInt(max - min);

    switch (_difficulty) {
      case GameDifficulty.easy:
        int type = random.nextInt(2); // 0: 덧셈, 1: 뺄셈, 2: 곱셈
        if (type == 0) {
          int a = next(1, 99);
          int b = next(0, 10);
          question = "$a + $b = ?";
          answer = "${a + b}";
        } else if (type == 1) {
          int a = next(1, 99);
          int b = next(0, 10);
          question = "$a - $b = ?";
          answer = "${a - b}";
        } else if (type == 2) {
          int a = random.nextInt(10);
          int b = random.nextInt(10);
          question = "$a x $b = ?";
          answer = "${a * b}";
        }
        break;

      case GameDifficulty.normal:
        int type = random.nextInt(4); // 0: 덧셈, 1: 뺄셈, 2: 곱셈, 3: 나눗셈
        if (type == 0) {
          int a = random.nextInt(1000);
          int b = random.nextInt(1000);
          question = "$a + $b = ?";
          answer = "${a + b}";
        } else if (type == 1) {
          int a = random.nextInt(1000);
          int n = random.nextInt(a+1);
          int b = a - n;
          question = "$a - $b = ?";
          answer = "$n";
        } else if (type == 2) {
          int a = random.nextInt(100);
          int b = random.nextInt(10);
          question = "$a x $b = ?";
          answer = "${a * b}";
        } else if (type == 3) {
          int b = random.nextInt(9) + 1;
          int n = random.nextInt(10);
          int a = b * n;
          question = "$a ÷ $b = ?";
          answer = "$n";
        }
        break;

      case GameDifficulty.timesTable:
        int a = random.nextInt(9) + 1;
        int b = random.nextInt(9) + 1;
        question = "$a x $b = ?";
        answer = "${a * b}";
        break;
    }

    return {'question': question, 'answer': answer};
  }

  void incrementProblemIndex() {
    _currentProblemIndex++;
    notifyListeners();
  }

  bool isLastProblem() {
    return _currentProblemIndex >= totalProblems;
  }

  void resetProblemIndex() {
    _currentProblemIndex = 1;
    submittedProblems = 0;
    correctProblems = 0;
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