import 'package:flutter/material.dart';

class GameSelect extends StatelessWidget {
  const GameSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {},
            child: Center(
              child: Text('Game One'),
            )),
        ElevatedButton(
            onPressed: () {},
            child: Center(
              child: Text('Game Two'),
            ))
      ],
    );
  }
}
