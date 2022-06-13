import 'package:flutter/material.dart';
import 'package:stroke_rehab/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? id;
  final bool isFreeMode;
  final GameGoalType gameGoalType;
  final int? repetitionLimit;
  final int? timeLimit = 0;
  final bool? completed = false;
  final int repetitionDone = 0;
  final int timeTakenForRepe = 0;
  final String startAt;
  final String endAt;
  List<Map<String, int>>? btnPressed = [];

  Exercise({this.id,
    required this.isFreeMode,
    required this.gameGoalType,
    required this.repetitionLimit,
    required this.startAt,
    this.endAt = '',
    this.btnPressed,
  });

  // Exercise.fromJson(Map<String, dynamic> json, String id)
  //     :
  //       id = id,
  //       gameType = json['gameType']
  //
  // ,
// year = json['year'],
// duration = json['duration'];

  Map<String, dynamic> toJson() =>
  {
  'id': id,
  'isFreeMode':isFreeMode,
  'gameGoalType': gameGoalType,
  'repetitionLimit': repetitionLimit,
  'timeLimit': timeLimit,
  'completed': completed,
  'repetitionDone': repetitionDone,
  'timeTakenForRepe': timeTakenForRepe,
  'startAt': startAt,
  'endAt': endAt,
  // List<Map<String, int>>? btnPressed = [];
};
// @override
//   String toString() {
//     // TODO: implement toString
//     return '{}';
//   }
}