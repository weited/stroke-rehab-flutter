import 'package:flutter/material.dart';
import 'package:stroke_rehab/page/game_customization.dart';
import 'package:stroke_rehab/widgets/large_selection_button.dart';

class GameMode extends StatelessWidget {

  final bool isPescGame;

  const GameMode({Key? key, this.isPescGame = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Game Mode')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LargeSelectionButton(
            buttonTitle: 'Set Game Goals',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameCustom()),
              );
              print('abc');
            },
          ),
          SizedBox(
            height: 15,
          ),
          LargeSelectionButton(
              buttonTitle: 'Play Free Mode',
              onPressed: () {
                print('Game two');
              })
        ],
      ),
    );

  }
}
