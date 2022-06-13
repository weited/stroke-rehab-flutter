import 'package:flutter/material.dart';

class Button {
  String title;
  Color color;
  // List<double> position;
  double positionX;
  double positionY;
  Function() btnOnPressed;

  Button(
      {required this.title,
      required this.color,
      // required this.position,
      required this.positionX,
      required this.positionY,
      required this.btnOnPressed});
}
