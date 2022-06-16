// import 'dart:ffi';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stroke_rehab/button.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/page/game_done.dart';
import 'package:stroke_rehab/widgets/alert_dialog.dart';
import 'package:stroke_rehab/widgets/game_button.dart';

class GamePlay extends StatefulWidget {
  final String docId;
  final String gameName;
  final String goalType;
  final int repeLimit;
  final int timeLimit;
  final bool isBtnRandom;
  final bool isBtnIndicator;
  final int btnNum;
  final double btnSize;

  GamePlay({
    Key? key,
    required this.docId,
    required this.gameName,
    required this.goalType,
    required this.repeLimit,
    required this.timeLimit,
    required this.isBtnRandom,
    required this.isBtnIndicator,
    required this.btnNum,
    required this.btnSize,
  }) : super(key: key);

  static String getTimeStamp({TimeFormat? timeFormat}) {
    DateFormat dateFormat;
    switch (timeFormat) {
      case TimeFormat.gameDocId:
        dateFormat = DateFormat('yyyyMMddHHmmss');
        break;
      case TimeFormat.gameDuration:
        dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
        break;
      case TimeFormat.btnPressed:
        dateFormat = DateFormat.Hms();
        break;
      default:
        dateFormat = DateFormat.Hms();
    }

    final timeStamp = dateFormat.format(DateTime.now().toLocal()).toString();
    return timeStamp;
  }

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  late final String docId;
  late bool isCompleted = false;
  late final String gameStartAt;
  late final String gameEndAt;
  late int repetitionDone = 0;
  late int timeTaken = 0;
  int currentBtn = 1;

  List<List<double>> btnPosition = [];
  List<Button> btnInforList = [];
  bool isOverlap = false;

  List<int> btnPressed = [];
  List<int> colorBtnCount = [];

  String titleText = 'Start Now!';
  late String gameHint;
  late int btnContainerWidth;
  late int btnContainerHeight;

  // var containerKey;
  late final ExerciseModel exerciseModel;

  Timer? timer;
  late int timeCountdown;

  @override
  void initState() {
    exerciseModel = Provider.of<ExerciseModel>(context, listen: false);
    // docId = getTimeStamp(timeFormat: TimeFormat.gameDocId);
    gameStartAt = GamePlay.getTimeStamp(timeFormat: TimeFormat.gameDuration);
    docId = widget.docId;
    timeCountdown = widget.timeLimit;
    gameHint = widget.gameName == GameName.pGame
        ? 'Tap button in order'
        : 'Tap two buttons with same color';

    super.initState();
    startTimer();

    // after build, set the random based on rendered container size then rebuild again
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // After calculated the container width and height,
      widget.isBtnRandom ? generateBtnRandPosition() : generateBtnFixPosition();
      setState(() {
        createBtnInforList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  void startTimer() {
    stopTimer();
    if (widget.goalType == GameGoalType.timeLimit) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeCountdown > 0) {
          setState(() {
            timeCountdown--;
            titleText = 'Time Left: $timeCountdown';
          });
        } else {
          stopTimer();
          finishGame();
        }
      });
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timeTaken++;
          titleText = 'Time Used: $timeTaken';
        });
      });
    }
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
            titleText: 'leave',
            onConfirmAction: () {
              Navigator.of(context).pop();
              finishGame();
            },
            onCancelAction: () {
              Navigator.of(context).pop();
              startTimer();
            },
          ));

  @override
  Widget build(BuildContext context) {
    // containerKey = GlobalKey();
    return WillPopScope(
      // https://stackoverflow.com/questions/61808024/flutter-how-can-i-catch-a-back-button-press-to-exit-my-app
      onWillPop: () async {
        stopTimer();
        await openDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(titleText),
          actions: [
            IconButton(
                onPressed: () {
                  openDialog();
                },
                icon: const Icon(Icons.clear))
          ],
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              const Text('Your goal:  '),
                              Text(widget.goalType == GameGoalType.freeMode
                                  ? 'Free Mode'
                                  : widget.goalType ==
                                          GameGoalType.repetitionLimit
                                      ? '${widget.repeLimit} Rounds'
                                      : '${widget.timeLimit} Seconds'),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('You reached:  '),
                              Text('$repetitionDone Rounds'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(gameHint),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Get container size for button random position range
                    btnContainerWidth = constraints.maxWidth.floor();
                    btnContainerHeight = constraints.maxHeight.floor();
                    return Stack(
                      children: btnInforList
                          .map(
                            (btn) => Positioned(
                              left: btn.positionX,
                              top: btn.positionY,
                              child: GameButton(
                                  showTitle: widget.gameName == GameName.pGame
                                      ? true
                                      : false,
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

  Future<void> createGameDoc(Exercise exercise) async {
    var result = await exerciseModel.add(exercise);
    docId = result;
  }

  void uploadBtnPressed(String btnPressedTitle) async {
    final btnPressedTime = GamePlay.getTimeStamp();
    await exerciseModel.addButton(docId, btnPressedTime, btnPressedTitle);
  }

  // create button with properties and save to list
  void createBtnInforList() {
    btnInforList.clear();
    if (widget.gameName != GameName.dGame) {
      for (var i = 0; i < widget.btnNum; i++) {
        final btnInfor = Button(
            title: (i + 1).toString(),
            color: kBtnNormalColor,
            positionX: btnPosition[i].first,
            positionY: btnPosition[i].last,
            btnOnPressed: () {
              pGameBtnOnPressed(i);
            });
        if (widget.isBtnIndicator == true && i == 0) {
          btnInfor.color = kBtnIndicatorColor;
        }
        btnInforList.add(btnInfor);
      }
    } else {
      Color btnColor;
      int btnTag;
      for (var i = 0; i < 6; i++) {
        if (i < 2) {
          btnColor = kBtnColor1;
          btnTag = 1;
        } else if (i > 3) {
          btnColor = kBtnColor2;
          btnTag = 2;
        } else {
          btnColor = kBtnColor3;
          btnTag = 3;
        }
        final btnInfor = Button(
            title: (i + 1).toString(),
            tag: btnTag,
            color: btnColor,
            positionX: btnPosition[i].first,
            positionY: btnPosition[i].last,
            btnOnPressed: () {
              dGameBtnOnPressed(i);
            });
        btnInforList.add(btnInfor);
      }
    }
  }

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
          if (distance < sqrt(2) * widget.btnSize) {
            isOverlap = true;
            break;
          }
        }
      }
    }
  }

  void generateBtnRandPosition() {
    do {
      getRandomPosition();
      checkBtnOverlap();
    } while (isOverlap == true);
  }

  void generateBtnFixPosition() {
    btnPosition.clear();
    if (widget.gameName == GameName.pGame) {
      final double eachHeight =
          (btnContainerHeight - (widget.btnNum * widget.btnSize)) /
              (widget.btnNum + 1);
      for (var i = 0; i < widget.btnNum; i++) {
        double positionX = (btnContainerWidth - widget.btnSize) / 2;
        double positionY = eachHeight * (i + 1) + widget.btnSize * i;
        btnPosition.add([positionX, positionY]);
      }
    } else {
      final double eachWidth = (btnContainerWidth - (widget.btnSize * 2)) / 3;
      final double eachHeight = (btnContainerHeight - (widget.btnSize * 3)) / 4;

      for (var i = 0; i < 6; i++) {
        double positionX;
        double positionY;
        if (i % 2 == 0) {
          positionX = eachWidth;
        } else {
          positionX = eachWidth * 2 + widget.btnSize;
        }
        if (i < 2) {
          positionY = eachHeight;
        } else if (i > 3) {
          positionY = eachHeight * 3 + widget.btnSize * 2;
        } else {
          positionY = eachHeight * 2 + widget.btnSize;
        }
        btnPosition.add([positionX, positionY]);
      }
    }
  }

  void resetBtnPosition() {
    // update button position property
    for (var i = 0; i < widget.btnNum; i++) {
      btnInforList[i].positionX = btnPosition[i].first;
      btnInforList[i].positionY = btnPosition[i].last;
    }
  }

  void resetBtnView() {
    if (widget.gameName != GameName.dGame) {
      for (var i = 0; i < widget.btnNum; i++) {
        btnInforList[i].title = (i + 1).toString();
        btnInforList[i].color = kBtnNormalColor;
        widget.isBtnIndicator
            ? btnInforList[0].color = kBtnIndicatorColor
            : null;
      }
    } else {
      for (var i = 0; i < widget.btnNum; i++) {
        Color btnColor;
        for (var i = 0; i < 6; i++) {
          if (i < 2) {
            btnColor = kBtnColor1;
          } else if (i > 3) {
            btnColor = kBtnColor2;
          } else {
            btnColor = kBtnColor3;
          }
          btnInforList[i].title = (i + 1).toString();
          btnInforList[i].color = btnColor;
        }
      }
    }
  }

  void getRandomPosition() {
    btnPosition.clear();
    Random random = Random();
    for (var i = 0; i < widget.btnNum; i++) {
      int randomX = random.nextInt(btnContainerWidth - widget.btnSize.toInt());
      int randomY = random.nextInt(btnContainerHeight - widget.btnSize.toInt());
      btnPosition.add([randomX.toDouble(), randomY.toDouble()]);
    }
  }

  void pGameBtnOnPressed(int btnIndex) {
    uploadBtnPressed((btnIndex + 1).toString());
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
            isCompleted = true;
            finishGame();
            return;
          }
          currentBtn = 1;
          if (widget.isBtnRandom) {
            generateBtnRandPosition();
            resetBtnPosition();
          }
          resetBtnView();
        }
      }
    });
  }

  void dGameBtnOnPressed(int btnIndex) {
    String btnColorName;
    if (btnInforList[btnIndex].tag! < 2) {
      btnColorName = 'Red';
    } else if (btnInforList[btnIndex].tag! > 3) {
      btnColorName = 'Yellow';
    } else {
      btnColorName = 'Green';
    }
    uploadBtnPressed(btnColorName);
    setState(() {
      if (btnPressed.isEmpty) {
        btnPressed.add(btnIndex);
        return;
      }

      if (btnPressed.first == btnIndex) {
        return;
      }
      if (btnInforList[btnPressed.first].tag == btnInforList[btnIndex].tag) {
        // btnInforList[btnIndex].title = '\u2713';
        // btnInforList[btnPressed.first].title = '\u2713';
        btnInforList[btnIndex].color = kBtnNormalColor;
        btnInforList[btnPressed.first].color = kBtnNormalColor;
        btnPressed.clear();

        if (!colorBtnCount.contains(btnInforList[btnIndex].tag)) {
          colorBtnCount.add(btnInforList[btnIndex].tag!);
          currentBtn++;

          if (currentBtn == 4) {
            repetitionDone++;
            if (repetitionDone == widget.repeLimit &&
                widget.goalType == GameGoalType.repetitionLimit) {
              isCompleted = true;
              finishGame();
              return;
            }
            colorBtnCount.clear();
            currentBtn = 1;
            if (widget.isBtnRandom) {
              generateBtnRandPosition();
              resetBtnPosition();
            }
            resetBtnView();
          }
        }
      } else {
        btnPressed.clear();
        btnPressed.add(btnIndex);
      }
    });
  }

  void finishGame() async {
    gameEndAt = GamePlay.getTimeStamp(timeFormat: TimeFormat.gameDuration);

    await exerciseModel.updateItem(
        docId, isCompleted, repetitionDone, timeTaken, gameEndAt);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => GameDone(
                id: docId,
              )),
    );
  }
}
