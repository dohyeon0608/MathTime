import 'package:flutter/cupertino.dart';
import 'package:math_time/data/game_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class GameDataManager {
  late SharedPreferences _prefs;
  BuildContext context;

  GameDataManager(this.context) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> loadData() async {
    await _initPrefs();
    if (!context.mounted) return;
    Provider.of<GameProvider>(context, listen: false).level = _prefs.getInt('level') ?? 0;
    Provider.of<GameProvider>(context, listen: false).currentXP = _prefs.getInt('exp') ?? 0;
    Provider.of<GameProvider>(context, listen: false).refresh();
  }

  Future<void> saveData() async {
    await _initPrefs();
    if (!context.mounted) return;
    _prefs.setInt('level', Provider.of<GameProvider>(context, listen: false).level);
    _prefs.setInt('exp', Provider.of<GameProvider>(context, listen: false).level);
  }

}