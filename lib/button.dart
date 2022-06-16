import 'package:flutter/material.dart';

class Button {
  String title;
  int? tag;
  Color color;
  double positionX;
  double positionY;
  Function() btnOnPressed;

  Button(
      {required this.title,
      this.tag,
      required this.color,
      required this.positionX,
      required this.positionY,
      required this.btnOnPressed});
}
