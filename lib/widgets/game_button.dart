import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final bool showTitle;
  final double btnSize;
  final String title;
  final Color btnColor;
  final Function() onPressed;

  const GameButton(
      {Key? key,
      required this.btnSize,
      required this.title,
      required this.btnColor,
      required this.onPressed,
      required this.showTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: showTitle
          ? Text(
              title,
              style: TextStyle(fontSize: btnSize / 3),
            )
          : null,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: btnColor,
        fixedSize: Size(btnSize, btnSize),
        shape: const CircleBorder(),
      ),
    );
  }
}
