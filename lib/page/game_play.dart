// import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stroke_rehab/button.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/page/game_done.dart';

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
    required this.goalType,
    required this.repeLimit,
    required this.timeLimit,
    required this.isBtnRandom,
    required this.isBtnIndicator,
    required this.btnNum,
    required this.btnSize,
  }) : super(key: key);

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  late final String docId;
  late final bool isCompleted = false;
  late final String gameStartAt;
  late final String gameEndAt;
  int repetitionDone = 0;
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

  get repeLimit => widget.repeLimit;

  @override
  void initState() {
    // TODO: implement initState
    docId = getCurrentTime();
    gameStartAt = getCurrentTime();
    // createBtnGroup();
    // print("the button key is ${btnKeys[0]}");
    super.initState();
    print('btn groupd has ${btnUIGroup.length}');

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // After calculated the container width and height,
      widget.isBtnRandom ? generateBtnRandPosition() : generateBtnFixPosition();
      setState(() {
        createBtnInforList();
      });
      print(
          "after call back $btnPosition + ${btnUIGroup.length} + infor ${btnInforList.length}");

      print('repe: $repeLimit, '
          'time: ${widget.timeLimit}, '
          'isRand: ${widget.isBtnRandom}, '
          'next-indi: ${widget.isBtnIndicator}, btnnum: ${widget.btnNum}, btnS: ${widget.btnSize}'
          'type: ${widget.goalType}');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('inside build');
    // containerKey = GlobalKey();
    return WillPopScope(
      // https://stackoverflow.com/questions/61808024/flutter-how-can-i-catch-a-back-button-press-to-exit-my-app
      onWillPop: () async {
        // bool willLeave = false;
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Are you sure want to leave?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          // willLeave = true;
                          Navigator.of(context).pop();
                          finishGame();
                          // Navigator.pushReplacement(
                          //     context, MaterialPageRoute(builder: (context)=>GameDone()));
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'))
                  ],
                ));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(titleText),
          automaticallyImplyLeading: false,
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
                    children: [
                      Text(
                          'Your goal: ${widget.goalType == GameGoalType.freeMode ? 'Free Mode' : widget.repeLimit}'),
                      Text('You reached: $repetitionDone')
                    ],
                  ),
                  ElevatedButton(
                    child: const Text(
                      'But',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      print('hell');
                      print('hell22');
                      // finishGame();
                      await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title:
                                    const Text('Are you sure want to leave?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        // willLeave = true;
                                        Navigator.of(context).pop();
                                        finishGame();
                                        // Navigator.pushReplacement(
                                        //     context, MaterialPageRoute(builder: (context)=>GameDone()));
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('No'))
                                ],
                              ));
                    },
                    onLongPress: () {
                      print('long press');
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(20, 20),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                key: containerKey,
                color: Colors.red,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    print("${constraints.maxWidth}");
                    // Get container size for button random position range
                    btnContainerWidth = constraints.maxWidth.floor();
                    btnContainerHeight = constraints.maxHeight.floor();

                    print(
                        "$btnPosition + ${btnUIGroup.length} + infor ${btnInforList.length}");

                    return Stack(
                      children: btnInforList
                          .map(
                            (btn) => Positioned(
                              left: btn.positionX,
                              top: btn.positionY,
                              child: PrescribedGameButton(
                                  btnSize: widget.btnSize,
                                  btnColor: btn.color,
                                  title: btn.title,
                                  onPressed: btn.btnOnPressed),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void createGameDoc() {}

  void createBtnInforList() {
    print('create button infor list');
    btnInforList.clear();
    for (var i = 0; i < widget.btnNum; i++) {
      final btnInfor = Button(
          title: (i + 1).toString(),
          color: kBtnNormalColor,
          // position: [btnPosition[i].first, btnPosition[i].last],
          positionX: btnPosition[i].first,
          positionY: btnPosition[i].last,
          btnOnPressed: () {
            pGameBtnOnPressed(i);
          }
          // print('You pressed in list $i');},
          );
      if (widget.isBtnIndicator == true && i == 0) {
        btnInfor.color = kBtnIndicatorColor;
      }
      btnInforList.add(btnInfor);
    }
  }

  // void createBtnGroup() {
  //   for (var i = 1; i <= widget.btnNum; i++) {
  //     final btnInfor = Button(
  //         title: i.toString(),
  //         color: Colors.blue,
  //         position: [btnPosition[i - 1].first, btnPosition[i - 1].last],
  //         btnOnPressed: () => pGameBtnOnPressed(i));
  //     btnInforList.add(btnInfor);
  //   }
  //
  //   for (var i = 1; i <= widget.btnNum; i++) {
  //     final btnKey = GlobalKey();
  //     btnKeys.add(btnKey);
  //     final btn = PrescribedGameButton(
  //       key: btnKey,
  //       btnSize: widget.btnSize,
  //       title: btnInforList[i - 1].title,
  //       btnColor: btnInforList[i - 1].color,
  //       onPressed: () {
  //         setState(() {
  //           if (btnInforList[i - 1].title == currentBtn.toString()) {
  //             btnInforList[i - 1].title = "Y";
  //             btnInforList[i - 1].color = Colors.red;
  //             currentBtn++;
  //             if (currentBtn == 4) {
  //               currentBtn = 1;
  //               for (var btnItem in btnInforList) {
  //                 btnItem.color = Colors.blue;
  //               }
  //             }
  //           }
  //         });
  //         print("Your clicked button ${btnInforList[i - 1].title}");
  //       },
  //     );
  //     final positionedBtn = Positioned(
  //         left: btnInforList[i - 1].position.first,
  //         top: btnInforList[i - 1].position.last,
  //         child: btn);
  //     btnUIGroup.add(positionedBtn);
  //   }
  // }

  void checkBtnOverlap() {
    isOverlap = false;
    for (var i = 0; i < btnPosition.length - 1; i++) {
      if (isOverlap == true) {
        break;
      } else {
        for (var j = i + 1; j < btnPosition.length; j++) {
          var distance = sqrt(
              pow(btnPosition[i].first - btnPosition[j].first, 2) +
                  pow(btnPosition[i].last - btnPosition[j].last, 2));
          // sqrt(
          //     pow(btnPosition[i].first, 2) + pow(btnPosition[i].last, 2)) -
          // sqrt(pow(btnPosition[j].first, 2) + pow(btnPosition[j].last, 2));
          if (distance < sqrt(2) * widget.btnSize) {
            isOverlap = true;
            break;
          }
        }
      }
    }
  }

  void generateBtnRandPosition() {
    print('generate Btn Position');
    do {
      print('Check over laping');
      getRandomPosition();
      checkBtnOverlap();
    } while (isOverlap == true);
  }

  void generateBtnFixPosition() {
    btnPosition.clear();
    final double eachHeight =
        (btnContainerHeight - (widget.btnNum * widget.btnSize)) /
            (widget.btnNum + 1);
    for (var i = 0; i < widget.btnNum; i++) {
      double positionX = (btnContainerWidth - widget.btnSize) / 2;
      double positionY = eachHeight * (i + 1) + widget.btnSize * i;
      // int randomX = random.nextInt(btnContainerWidth - widget.btnSize.toInt());
      // int randomY = random.nextInt(btnContainerHeight - widget.btnSize.toInt());
      btnPosition.add([positionX, positionY]);
    }
  }

  void resetBtnPosition() {
    print('reset  Btn Position');
    // update button position property
    for (var i = 0; i < widget.btnNum; i++) {
      btnInforList[i].positionX = btnPosition[i].first;
      btnInforList[i].positionY = btnPosition[i].last;
    }
  }

  void resetBtnView() {
    print('resetBtn view');
    for (var i = 0; i < widget.btnNum; i++) {
      btnInforList[i].title = (i + 1).toString();
      btnInforList[i].color = kBtnNormalColor;
      widget.isBtnIndicator ? btnInforList[0].color = kBtnIndicatorColor : null;
      // btnInforList[i].position.first = btnPosition[i].first;
      // btnInforList[i].position.last = btnPosition[i].last;
    }
  }

  void getRandomPosition() {
    print('getRandomPosition');
    btnPosition.clear();
    Random random = Random();
    for (var i = 0; i < widget.btnNum; i++) {
      int randomX = random.nextInt(btnContainerWidth - widget.btnSize.toInt());
      int randomY = random.nextInt(btnContainerHeight - widget.btnSize.toInt());
      btnPosition.add([randomX.toDouble(), randomY.toDouble()]);
    }
  }

  void randomBtnPosition() {
    // RenderBox btn = btnUIGroup[0].key?.currentContext.findRenderObject();
    // RenderBox theBtn = btnKey.currentContext?.findRenderObject() as RenderBox;

    for (var i = 1; i <= widget.btnNum; i++) {}
  }

  //tag
  void pGameBtnOnPressed(int btnIndex) {
    print('inside btn pressed $btnIndex');
    setState(() {
      if (btnInforList[btnIndex].title == currentBtn.toString()) {
        btnInforList[btnIndex].title = "\u2713";
        btnInforList[btnIndex].color = kBtnNormalColor;
        if (currentBtn < widget.btnNum && widget.isBtnIndicator == true) {
          btnInforList[btnIndex + 1].color = kBtnIndicatorColor;
        }
        currentBtn++;
        if (currentBtn == widget.btnNum + 1) {
          repetitionDone++;
          if (repetitionDone == widget.repeLimit &&
              widget.goalType == GameGoalType.repetitionLimit) {
            finishGame();
            return;
          }
          currentBtn = 1;
          if (widget.isBtnRandom) {
            generateBtnRandPosition();
            resetBtnPosition();
          }

          resetBtnView();
          // for (var btnItem in btnInforList) {
          //   btnItem.color = Colors.blue;
          //   btnItem.title = btnIndex.toString();
          // }
        }
      }
    });
    // print("Your clicked button ${btnInforList[0].title}");
  }

  String getCurrentTime() {
    final timeStamp = DateTime.now().toString();
    return timeStamp;
  }

  void finishGame() {
    final gameInfor = Exercise(
        isFreeMode: widget.isFreeMode,
        gameGoalType: widget.goalType,
        repetitionLimit: widget.repeLimit,
        startAt: gameStartAt);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameDone(gameResult: gameInfor)),
    );
  }

  // Future<void> _navigateToChangeName(BuildContext context) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const NameChange()),
  //   );
  //   // get name again when navigated back
  //   getUserName();
  //   // setState(() {
  //   //   name = result;
  //   // });
  //
  //   // print('The ### $result ');
  // }

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
      {Key? key,
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
