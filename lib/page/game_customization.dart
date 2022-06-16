import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/page/game_play.dart';
import 'package:stroke_rehab/widgets/large_action_button.dart';

class GameCustom extends StatefulWidget {
  final String gameName;

  const GameCustom({Key? key, required this.gameName}) : super(key: key);

  @override
  State<GameCustom> createState() => _GameCustomState();
}

class _GameCustomState extends State<GameCustom> {
  bool isFreeMode = false;
  String goalType = GameGoalType.repetitionLimit;
  int repeLimit = 1;
  int timeLimit = 30;
  bool isBtnRandom = true;
  bool isBtnIndicator = true;
  int btnNum = 2;
  double btnSize = 80.0;

  List<bool> isSelected = [true, false, false];
  final List<int> repeRange = [for (var i = 1; i < 21; i += 1) i];
  final List<String> timeRange = [
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
  final List<int> btnNumRange = [2, 3, 4, 5];
  final List<String> goalTypeRange = [
    GameGoalType.repetitionLimit,
    GameGoalType.timeLimit,
    GameGoalType.freeMode
  ];

  late final ExerciseModel exerciseModel;

  @override
  void initState() {
    exerciseModel = Provider.of<ExerciseModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // create empty document and return id
  Future<String> createGameDoc() async {
    Exercise exercise = Exercise(
        gameGoalType: goalType,
        repetitionLimit: repeLimit,
        timeLimit: timeLimit,
        startAt: GamePlay.getTimeStamp(timeFormat: TimeFormat.gameDuration));
    final addedDocId = await exerciseModel.add(exercise);
    return addedDocId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Game Customization'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 70,
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Column(
                children: [
                  ToggleButtons(
                    fillColor: Colors.blue,
                    selectedColor: Colors.white,
                    isSelected: isSelected,
                    borderRadius: BorderRadius.circular(15),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Repetition'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Time Limit'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
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
                        },
                        children: repeRange
                            .map((element) => Center(
                                    child: Text(
                                  '$element',
                                  style: const TextStyle(fontSize: 28),
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
                                  style: const TextStyle(fontSize: 25),
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
                      const Text('Randomization button order :'),
                      Switch(
                          value: isBtnRandom,
                          onChanged: (value) => setState(() {
                                isBtnRandom = value;
                              })),
                      // Text('With'),
                    ],
                  ),
                  if (widget.gameName == GameName.pGame)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Next-button indication :'),
                        Switch(
                            value: isBtnIndicator,
                            onChanged: (value) => setState(() {
                                  isBtnIndicator = value;
                                })),
                      ],
                    ),
                  if (widget.gameName == GameName.pGame)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Number of buttons :'),
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: CupertinoPicker(
                            itemExtent: 30,
                            onSelectedItemChanged: (item) {
                              setState(() {
                                btnNum = btnNumRange[item];
                              });
                            },
                            children: btnNumRange
                                .map((e) => Center(
                                        child: Text(
                                      '$e',
                                      style: const TextStyle(fontSize: 20),
                                    )))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Button size :'),
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(btnSize, btnSize),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Container(
            height: kBottomContainerHeight,
            child: LargeSelectionButton(
              buttonTitle: 'Start',
              onPressed: () async {
                String docId = await createGameDoc();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePlay(
                      docId: docId,
                      goalType: goalType,
                      repeLimit: repeLimit,
                      timeLimit: timeLimit,
                      isBtnRandom: isBtnRandom,
                      isBtnIndicator: isBtnIndicator,
                      // random mode only allow 6 buttons
                      btnNum: widget.gameName == GameName.pGame ? btnNum : 6,
                      btnSize: btnSize,
                      gameName: widget.gameName,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
