import 'package:flutter/material.dart';

const kCollectionName = "exercisesFlutter";

const kBtnNormalColor = Colors.blue;
const kBtnIndicatorColor = Colors.pinkAccent;

const kBtnColor1 = Color(0xFFFF6B6B);
const kBtnColor2 = Color(0xFFFFD93D);
const kBtnColor3 = Color(0xFF6BCB77);

// enum GameName { prescribed, design }
// enum GameGoalType { repetitionLimit, timeLimit, freeMode }
enum TimeFormat {
  gameDocId,
  gameDuration,
  btnPressed
}

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kDetailRowTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

const kBottomContainerHeight = 80.0;

abstract class GameGoalType {
  static String repetitionLimit = 'Repetition Limit';
  static String timeLimit = 'Time Limit';
  static String freeMode = 'Free Mode';
}

abstract class GameName {
  static String pGame = 'Prescribed Game';
  static String dGame = 'Designed Game';
}