import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stroke_rehab/page/game_play.dart';

import '../constants.dart';
import '../widgets/large_selection_button.dart';

class GameCustom extends StatefulWidget {
  const GameCustom({Key? key}) : super(key: key);

  @override
  State<GameCustom> createState() => _GameCustomState();
}

class _GameCustomState extends State<GameCustom> {
  bool isFreeMode = false;
  GameGoalType goalType = GameGoalType.repetitionLimit;
  int repeLimit = 1;
  int timeLimit = 30;
  bool isBtnRandom = true;
  bool isBtnIndicator = true;
  int btnNum = 2;
  double btnSize = 80.0;

  List<bool> isSelected = [true, false, false];
  final repeRange = [for (var i = 1; i < 21; i += 1) i];
  final timeRange = [
    "30 s",
    "1 min",
    "1 min 30 s",
    "2 min",
    "2 min 30 s",
    "3 min",
    "3 min 30 s",
    "4 min",
    "4 min 30 s",
    "5 min 30 s",
    "5 min"
  ];
  final btnNumRange = [2, 3, 4, 5];
  final goalTypeRange = [
    GameGoalType.repetitionLimit,
    GameGoalType.timeLimit,
    GameGoalType.freeMode
  ];

  // late FixedExtentScrollController scrollController;

  // [
  //   2,3,4,5,6,7,8,9,10
  //
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // scrollController = FixedExtentScrollController(initialItem: 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Game Customization'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 70,
              margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ToggleButtons(
                    // color: Colors.blue,
                    fillColor: Colors.blue,
                    selectedColor: Colors.white,
                    isSelected: isSelected,
                    borderRadius: BorderRadius.circular(15),

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Repetition'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Time Limit'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Free  Mode'),
                      )
                    ],
                    onPressed: (int selectedIndex) {
                      setState(() {
                        for (int index = 0;
                            index < isSelected.length;
                            index++) {
                          if (index == selectedIndex) {
                            isSelected[index] = true;
                          } else {
                            isSelected[index] = false;
                          }
                        }
                        goalType = goalTypeRange[selectedIndex];
                      });
                    },
                  ),
                  if (isSelected[0] == true)
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        onSelectedItemChanged: (item) {
                          setState(() {
                            repeLimit = repeRange[item];
                          });

                          print('selected $repeLimit');
                        },
                        children: repeRange
                            .map((e) => Center(
                                    child: Text(
                                  '$e',
                                  style: TextStyle(fontSize: 28),
                                )))
                            .toList(),
                      ),
                    ),
                  if (isSelected[1] == true)
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController:
                            FixedExtentScrollController(initialItem: 3),
                        onSelectedItemChanged: (item) {
                          setState(() {
                            timeLimit = (item + 1) * 30;
                          });
                        },
                        children: timeRange
                            .map((e) => Center(
                                    child: Text(
                                  e,
                                  style: TextStyle(fontSize: 25),
                                )))
                            .toList(),
                      ),
                    ),
                  if (isSelected[2] == true)
                    const Expanded(
                        child: Center(child: Text('Play Game in Free Mode'))),
                ],
              ),
              decoration: BoxDecoration(
                // color: Color(0xFFFF2222),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Randomization button order:'),
                      Switch(
                          value: isBtnRandom,
                          onChanged: (value) => setState(() {
                                isBtnRandom = value;
                              })),
                      // Text('With'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Next-button indication:'),
                      Switch(
                          value: isBtnIndicator,
                          onChanged: (value) => setState(() {
                                isBtnIndicator = value;
                              })),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Number of buttons:'),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (item) {
                            setState(() {
                              btnNum = btnNumRange[item];
                            });

                            print('selected $repeLimit');
                          },
                          children: btnNumRange
                              .map((e) => Center(
                                      child: Text(
                                    '$e',
                                    style: TextStyle(fontSize: 20),
                                  )))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Button size:'),
                      Slider(
                        value: btnSize.toDouble(),
                        min: 60.0,
                        max: 100.0,
                        onChanged: (double newValue) {
                          setState(() {
                            btnSize = newValue.floorToDouble();
                          });
                          print(btnSize.toString());
                        },
                      ),
                    ],
                  ),
                  Container(
                    height: 100,
                    child: Center(
                      child: ElevatedButton(
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: btnSize / 3),
                        ),
                        onPressed: () {
                          print('hell');
                          print('repe: $repeLimit, '
                              'time: $timeLimit, '
                              'isRand: $isBtnRandom, '
                              'next-indi: $isBtnIndicator, btnnum: $btnNum, btnS: $btnSize'
                              'type: $goalType');
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(btnSize, btnSize),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          // Container(
          //   child: Center(
          //     child: Text(
          //       'Start',
          //       style: kLargeButtonTextStyle,
          //     ),
          //   ),
          //   color: kBottomContainerColour,
          //   margin: EdgeInsets.only(top: 10.0),
          //   padding: EdgeInsets.only(bottom: 20.0),
          //   width: double.infinity,
          //   height: kBottomContainerHeight,
          // ),
          Container(
            height: kBottomContainerHeight,
            child: LargeSelectionButton(
              buttonTitle: 'Start',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GamePlay(
                        goalType: goalType,
                        repeLimit: repeLimit,
                        timeLimit: timeLimit,
                        isBtnRandom: isBtnRandom,
                        isBtnIndicator: isBtnIndicator,
                        btnNum: btnNum,
                        btnSize: btnSize,
                          )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
