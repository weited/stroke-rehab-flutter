import 'package:flutter/material.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/page/game_customization.dart';
import 'package:stroke_rehab/widgets/large_action_button.dart';

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
          SizedBox(
            height: 80,
            child: LargeSelectionButton(
              buttonTitle: 'Game One',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GameCustom(gameName: GameName.pGame)),
                );
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 80,
            child: LargeSelectionButton(
              buttonTitle: 'Game Two',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GameCustom(gameName: GameName.dGame)),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
