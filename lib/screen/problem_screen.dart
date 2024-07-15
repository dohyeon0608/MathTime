import 'dart:async';

import 'package:flutter/material.dart';
import 'package:math_time/screen/result_screen.dart';
import 'package:math_time/style/text_styles.dart';
import 'package:provider/provider.dart';

import '../data/game_provider.dart';
import '../util/util.dart';

class ProblemScreen extends StatefulWidget {
  final GameDifficulty difficulty;

  const ProblemScreen({required this.difficulty, super.key});

  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  String question = "";
  String answer = "";
  String userAnswer = "";

  bool isPaused = false;
  bool isAnswered = false;
  bool isCorrect = false;
  int correctProblems = 0;
  int submittedProblems = 0;

  // 빨리빨리 수학
  bool _isRunning = false;
  int _leftTime = 100;
  int _totalTime = 100;
  late Timer _timer;
  late GameMode _gameMode;

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_leftTime <= 0) {
        endGame();
      }
      setState(() {
        _leftTime--;
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer.cancel();
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
      if (_isRunning) {
        _isRunning = false;
        _stopTimer();
      } else {
        _isRunning = true;
        _startTimer();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _gameMode = Provider.of<GameProvider>(context, listen: false).gameMode;
    if (_gameMode == GameMode.fixedAmount) {
      _leftTime = _totalTime =
          Provider.of<GameProvider>(context, listen: false).totalSeconds;
      _startTimer();
    }
    correctProblems = 0;
    submittedProblems = 0;
    generateQuestion();
  }

  void generateQuestion() {
    Map<String, String> problem =
        Provider.of<GameProvider>(context, listen: false).generateQuestion();
    setState(() {
      question = problem['question']!;
      answer = problem['answer']!;
    });
  }

  void endGame() {
    if (_gameMode == GameMode.fixedAmount) {
      _stopTimer();
      Provider.of<GameProvider>(context, listen: false).endedByPause = isPaused;
      if (isPaused) _leftTime = 0;
      Provider.of<GameProvider>(context, listen: false).leftSeconds = _leftTime;
    }
    Provider.of<GameProvider>(context, listen: false).correctProblems =
        correctProblems;
    Provider.of<GameProvider>(context, listen: false).submittedProblems =
        submittedProblems;
    Provider.of<GameProvider>(context, listen: false)
        .addXP(Provider.of<GameProvider>(context, listen: false).exp);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen()),
    );
  }

  void checkAnswer() {
    bool doEndGame = false;
    setState(() {
      isAnswered = true;
      isCorrect = userAnswer == answer;
      submittedProblems += 1;
      if (isCorrect) correctProblems += 1;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isAnswered = false;
      });
      if (_gameMode == GameMode.continuous && !isCorrect) {
        doEndGame = true;
      }
      if (_gameMode == GameMode.fixedAmount &&
          Provider.of<GameProvider>(context, listen: false).isLastProblem()) {
        doEndGame = true;
      }
      if (doEndGame) {
        endGame();
      } else {
        Provider.of<GameProvider>(context, listen: false)
            .incrementProblemIndex();
        generateQuestion();
        setState(() {
          userAnswer = "";
        });
      }
    });
  }

  Widget extraInfoWidget() {
    if (_gameMode == GameMode.fixedAmount) {
      return Expanded(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: 300,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      color: Colors.lightBlue,
                      value: (_leftTime / _totalTime),
                      minHeight: 30,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${Util.timeFormat(_leftTime)} 남음',
                      style: const TextStyle(color: Colors.black38),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {}
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Problem'),
        actions: [
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              if (!isAnswered) {
                togglePause();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    (_gameMode == GameMode.fixedAmount)
                        ? '문제 ${Provider.of<GameProvider>(context, listen: false).currentProblemIndex}/${Provider.of<GameProvider>(context, listen: false).totalProblems}'
                        : '문제 ${Provider.of<GameProvider>(context, listen: false).currentProblemIndex}',
                    textAlign: TextAlign.center,
                    style: TextStyles.problemTitle),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(question,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24)),
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 70,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(width: 1, color: Colors.lightBlueAccent),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10.0) // POINT
                            )),
                    child: Center(
                        child: Text(userAnswer,
                            style: TextStyles.answer,
                            textAlign: TextAlign.center)),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 350,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        if (index < 10) {
                          int key = ((index + 1) % 10);
                          return KeyPadButtonWidget(
                            onPressed: () {
                              if (!isAnswered) {
                                setState(() {
                                  userAnswer += key.toString();
                                });
                              }
                              ;
                            },
                            child: Text(key.toString(),
                                style: TextStyles.buttonNumber),
                          );
                        } else if (index == 10) {
                          return KeyPadButtonWidget(
                            onPressed: () {
                              if (!isAnswered) {
                                setState(() {
                                  if (userAnswer.isNotEmpty) {
                                    userAnswer = userAnswer.substring(
                                        0, userAnswer.length - 1);
                                  }
                                });
                              }
                            },
                            child: Icon(Icons.backspace),
                          );
                        } else {
                          return KeyPadButtonWidget(
                            onPressed: () {
                              if (!isAnswered) {
                                checkAnswer();
                              }
                            },
                            child: Text("확인", style: TextStyles.buttonNumber),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              extraInfoWidget()
            ],
          ),
          if (isAnswered)
            Center(
                child: Text(
              isCorrect ? "O" : "X",
              style: TextStyle(
                  fontSize: 150,
                  fontWeight: FontWeight.bold,
                  color: (isCorrect)
                      ? Colors.lightBlueAccent.withAlpha(127)
                      : Colors.pinkAccent.withAlpha(127)),
            )),
          if (isPaused)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '일시 정지됨',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: togglePause,
                        child: Text('계속하기'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          endGame();
                        },
                        child: Text('그만두기'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KeyPadButtonWidget extends StatelessWidget {
  const KeyPadButtonWidget(
      {super.key, required this.child, required this.onPressed});

  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
        ));
  }
}
