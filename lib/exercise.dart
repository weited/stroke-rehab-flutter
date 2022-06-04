import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise
{
  String? id;
  String gameType = 'type';

  Exercise({this.id, required this.gameType})

  Exercise.fromJson(Map<String, dynamic> json, String id)
      :
        id = id,
        gameType = json['gameType'],
        // year = json['year'],
        // duration = json['duration'];

  // Map<String, dynamic> toJson() =>
  //     {
  //       // 'id': id,
  //       'title': title,
  //       'year': year,
  //       'duration' : duration
  //     };
}