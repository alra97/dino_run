//COINS ERROR IN CALCULATIONS, WORKS WHEN IT HITS TARGET, POINTS JUMP 15?????
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_data.g.dart';

// This class stores the player progress persistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 5;

  int get lives => _lives;
  set lives(int value) {
    if (value <= 5 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  @HiveField(2)
  int boopCounter = 0; // Assuming this is used for coins

  int get coins => boopCounter;
  set coins(int value) {
    boopCounter = value;
    notifyListeners();
    save();
  }

  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    notifyListeners();
    save();
  }
}
