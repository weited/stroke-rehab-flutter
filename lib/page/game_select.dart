import 'package:flutter/material.dart';
import 'package:stroke_rehab/page/game_mode.dart';
import 'package:stroke_rehab/page/game_play.dart';
import 'package:stroke_rehab/widgets/large_selection_button.dart';

class GameSelect extends StatelessWidget {
  const GameSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Game'))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LargeSelectionButton(
            buttonTitle: 'Game One',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamePlay()),
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          LargeSelectionButton(
              buttonTitle: 'Game Two',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameMode(isPescGame: false,)),
                );
                print('Game two');
              })
        ],
      ),
    );
  }


}
