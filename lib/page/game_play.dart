import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stroke_rehab/button.dart';
import 'package:stroke_rehab/constants.dart';

class GamePlay extends StatefulWidget {
  GameName gameName;
  bool isFreeMode;
  GameGoalType goalType;
  int repeLimit;
  int timeLimit;
  bool isBtnRandom;
  bool isBtnIndicator;
  int btnNum;
  double btnSize;

  GamePlay({
    Key? key,
    this.gameName = GameName.prescribed,
    this.isFreeMode = false,
    this.goalType = GameGoalType.repetitionLimit,
    this.repeLimit = 3,
    this.timeLimit = 30,
    this.isBtnRandom = true,
    this.isBtnIndicator = true,
    this.btnNum = 3,
    this.btnSize = 50,
  }) : super(key: key);

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  late final String docId;
  late final bool isCompleted = false;
  late final String gameStartAt;
  late final String gameEndAt;
  late int repetitionDone;
  late int timeTaken;
  String titleText = 'Game';
  String goalText = 'A';
  int currentBtn = 1;

  List<Widget> btnUIGroup = [];
  List<Key> btnKeys = [];
  List<List<double>> btnPosition = [];
  bool isOverlap = false;

  late int btnContainerWidth;
  late int btnContainerHeight;

  List<Button> btnInforList = [];
  var containerKey;

  @override
  void initState() {
    // TODO: implement initState
    docId = getCurrentTime();
    gameStartAt = getCurrentTime();
    // createBtnGroup();
    // print("the button key is ${btnKeys[0]}");
    super.initState();
    print('btn groupd has ${btnUIGroup.length}');

    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   Random random = Random();
    //   int randomNumber = random.nextInt(50);
    //   var theBtn = containerKey.currentContext;
    //   setState(() {
    //     // btnPosition.first.first = randomNumber.toDouble();
    //     btnPosition = [
    //       [randomNumber.toDouble(), 150],
    //       [180, 240],
    //       [50, 300]
    //     ];
    //     createBtnGroup();
    //     goalText = 'new value $theBtn';
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('inside build');
    containerKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(titleText),
      ),
      body: Column(
        children: [
          Container(
            color: kTextContainerColor,
            // height: 80,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                // Text('${containerKey.currentContext}'),
                Text('Tap two buttons with same number'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text('Your goal: '), Text('You reached:')],
                ),
                ElevatedButton(
                  child: const Text(
                    'But',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    print('hell');
                    setState(() {
                      btnInforList[0].title = "g";
                      btnInforList[0].color = Colors.red;
                    });
                  },
                  onLongPress: () {
                    print('long press');
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 100),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              key: containerKey,
              color: Colors.red,
              width: double.infinity,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  print("${constraints.maxWidth}");
                  btnContainerWidth = constraints.maxWidth.floor();
                  btnContainerHeight = constraints.maxHeight.floor();
                  Random random = Random();
                  int randomNumber = random.nextInt(btnContainerWidth);

                  // btnPosition.first.first = randomNumber.toDouble();
                  btnPosition = [
                    [
                      btnContainerWidth.toDouble() - widget.btnSize,
                      btnContainerHeight.toDouble() - widget.btnSize
                    ],
                    [0, 0],
                    [randomNumber.toDouble(), randomNumber.toDouble()]
                  ];
                  createBtnGroup();
                  print("$btnPosition");

                  return Stack(
                    children: [
                      Text('$btnContainerWidth'),
                      Text('The text is $goalText'),
                      for (var btn in btnUIGroup) btn,
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void createGameDoc() {}

  void createBtnList() {
    for (var i = 1; i <= widget.btnNum; i++) {
      Button btnInfor;
      btnInfor = Button(
          title: i.toString(),
          color: Colors.blue,
          position: [btnPosition[i - 1].first, btnPosition[i - 1].last]);
      btnInforList.add(btnInfor);
    }
  }

  void createBtnGroup() {
    for (var i = 1; i <= widget.btnNum; i++) {
      final btnInfor = Button(
          title: i.toString(),
          color: Colors.blue,
          position: [btnPosition[i - 1].first, btnPosition[i - 1].last]);
      btnInforList.add(btnInfor);
    }

    for (var i = 1; i <= widget.btnNum; i++) {
      final btnKey = GlobalKey();
      btnKeys.add(btnKey);
      final btn = PrescribedGameButton(
        key: btnKey,
        btnSize: widget.btnSize,
        title: btnInforList[i - 1].title,
        btnColor: btnInforList[i - 1].color,
        onPressed: () {
          setState(() {
            if (btnInforList[i - 1].title == currentBtn.toString()) {
              btnInforList[i - 1].title = "Y";
              btnInforList[i - 1].color = Colors.red;
              currentBtn++;
              if (currentBtn == 4) {
                currentBtn = 1;
                for (var btnItem in btnInforList) {
                  btnItem.color = Colors.blue;
                }
              }
            }
          });
          print("Your clicked button ${btnInforList[i - 1].title}");
        },
      );
      final positionedBtn = Positioned(
          left: btnInforList[i - 1].position.first,
          top: btnInforList[i - 1].position.last,
          child: btn);
      btnUIGroup.add(positionedBtn);
    }
  }

  void checkBtnOverlap() {
    isOverlap = false;
    for (var i = 0; i < btnPosition.length; i++) {
      if (isOverlap == true) {
        break;
      } else {
        for (var j = i + 1; j < btnPosition.length; j++) {
          var distance = sqrt(
                  pow(btnPosition[i].first, 2) + pow(btnPosition[i].last, 2)) -
              sqrt(pow(btnPosition[j].first, 2) + pow(btnPosition[j].last, 2));
          if (distance.abs() <= sqrt(pow(widget.btnSize, 2) * 2)) {
            isOverlap = true;
            break;
          }
        }
      }
    }
  }

  void resetBtnPosition() {
    do {
      randomBtnPosition();
      checkBtnOverlap();
    } while (isOverlap == true);
  }

  void getRandomPosition() {

  }

  void randomBtnPosition() {
    // RenderBox btn = btnUIGroup[0].key?.currentContext.findRenderObject();
    // RenderBox theBtn = btnKey.currentContext?.findRenderObject() as RenderBox;

    for (var i = 1; i <= widget.btnNum; i++) {}
  }

  String getCurrentTime() {
    final timeStamp = DateTime.now().toString();
    return timeStamp;
  }

  Widget PGameButton() {
    return ElevatedButton(
      child: const Text(
        'But',
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () {
        print('hell');
      },
      onLongPress: () {
        print('long press');
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(100, 100),
        shape: const CircleBorder(),
      ),
    );
  }
}

class BtnStack extends StatelessWidget {
  const BtnStack({
    Key? key,
    required this.btnUIGroup,
  }) : super(key: key);

  final List<Widget> btnUIGroup;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // btnUIGroup.expand((element) => element),
        for (var btn in btnUIGroup) btn,
// btnUIGroup[0],
//                     PrescribedGameButton(
//                         key: btnKey,
//                         title: '1',
//                         onPressed: () {
//                   print("Your clicked button ${btnKey} ");
//                         }
//                     ),
      ],
    );
  }
}

class PrescribedGameButton extends StatelessWidget {
  final double btnSize;
  final String title;
  final Color btnColor;
  final Function() onPressed;

  const PrescribedGameButton(
      {required Key key,
      required this.btnSize,
      required this.title,
      required this.btnColor,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: onPressed,
      onLongPress: () {
        print('long press');
      },
      style: ElevatedButton.styleFrom(
        primary: btnColor,
        fixedSize: Size(btnSize, btnSize),
        shape: const CircleBorder(),
      ),
    );
  }
}

class TestCustomPainter extends CustomPainter {
  Paint _paintWhite = Paint()..color = Colors.white;

  Paint _paintBlue = Paint()
    ..color = Colors.blue
    ..isAntiAlias = true;
  Paint _paintRed = Paint()
    ..color = Colors.red
    ..isAntiAlias = true;
  Paint _paintGreen = Paint()
    ..color = Colors.green
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    Rect buttonRect = Rect.fromCircle(center: Offset(120, 250), radius: 100);
    Rect buttonRect2 = Rect.fromCircle(center: Offset(220, 250), radius: 50);

    if (buttonRect.overlaps(buttonRect2)) {
      print("overlaped");
    } else {
      print("not overlap");
    }
    canvas.drawRect(buttonRect, _paintBlue);
    canvas.drawRect(buttonRect2, _paintWhite);
    canvas.drawRect(Rect.fromLTRB(90, 0, 180, 90), _paintWhite);
    canvas.drawRect(Rect.fromLTRB(90, 0, 0, 90), _paintBlue);
    canvas.drawRect(Rect.fromLTRB(0, 90, 90, 180), _paintRed);
    canvas.drawRect(Rect.fromLTRB(180, 180, 90, 90), _paintGreen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
