import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? id;
  String gameGoalType;
  int repetitionLimit;
  int? timeLimit;
  bool? completed;
  int? repetitionDone;
  int? timeTaken;
  String startAt;
  String? endAt;
  List<dynamic>? btnPressed;
  String imgPath;

  Exercise({
    this.id,
    required this.gameGoalType,
    required this.repetitionLimit,
    this.timeLimit = 0,
    this.completed = false,
    this.repetitionDone = 0,
    this.timeTaken = 0,
    required this.startAt,
    this.endAt = '',
    this.btnPressed,
    this.imgPath = '',
  });

  Exercise.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        gameGoalType = json['gameGoalType'],
        repetitionLimit = json['repetitionLimit'],
        timeLimit = json['timeLimit'],
        completed = json['completed'],
        repetitionDone = json['repetitionDone'],
        timeTaken = json['timeTaken'],
        startAt = json['startAt'],
        endAt = json['endAt'],
        btnPressed = json['btnPressed'],
        imgPath = json['imgPath'];

  Map<String, dynamic> toJson() => {
        'gameGoalType': gameGoalType,
        'repetitionLimit': repetitionLimit,
        'timeLimit': timeLimit,
        'completed': completed,
        'repetitionDone': repetitionDone,
        'timeTaken': timeTaken,
        'startAt': startAt,
        'endAt': endAt,
        'btnPressed': btnPressed ?? [],
        'imgPath': imgPath,
      };

  String shareRecord() {
    final gameGoal = repetitionLimit.toString();
    final status = completed! ? 'completed' : 'not completed';
    final btns = btnPressed;
    String displayStr = '';
    String btnsStr = '';

    for (var btn in btns!) {
      final timeStamp = btn.keys;
      final btnText = btn.values;
      btnsStr += '[ $timeStamp : $btnText]';
    }

    displayStr = 'Game type: $gameGoalType, '
        'game goal: $gameGoal, '
        'competition status: $status, '
        'started at: $startAt, '
        'end at: $endAt, '
        '$repetitionDone repetitions has done, '
        'button pressed: [$btnsStr]';

    return displayStr;
  }
}

class ExerciseModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Exercise> _items = [];
  List<Exercise> _filteredItems = [];

  int totalAttempts = 0;
  int totalPressed = 0;

  CollectionReference exercisesCollection =
      FirebaseFirestore.instance.collection(kCollectionName);

  bool loading = false;

  UnmodifiableListView<Exercise> get items =>
      UnmodifiableListView(_filteredItems);

  UnmodifiableListView<Exercise> get byGameName => UnmodifiableListView(
      _items.where((element) => element.btnPressed!.isEmpty));

  void filterByModeAndImg(String goalType, String hasImg) {
    _filteredItems.clear();
    totalPressed = 0;
    _filteredItems = [..._items];

    if (goalType == 'All' && hasImg == 'All') {
      filterClear();
      return;
    }

    switch (hasImg) {
      case 'Image':
        _filteredItems = _filteredItems
            .where((element) => element.imgPath.isNotEmpty)
            .toList();
        break;
      case 'No Image':
        _filteredItems =
            _filteredItems.where((element) => element.imgPath.isEmpty).toList();
        break;
      default:
        // _filteredItems = [... _items];
        break;
    }

    switch (goalType) {
      case 'Repetition':
        _filteredItems = _filteredItems
            .where((element) =>
                element.gameGoalType == GameGoalType.repetitionLimit)
            .toList();
        break;
      case 'Time Limit':
        _filteredItems = _filteredItems
            .where((element) => element.gameGoalType == GameGoalType.timeLimit)
            .toList();
        break;
      case 'Free Mode':
        _filteredItems = _filteredItems
            .where((element) => element.gameGoalType == GameGoalType.freeMode)
            .toList();
        break;
      default:
        // _filteredItems = [... _items];
        break;
    }

    totalAttempts = _filteredItems.length;
    for (var item in _filteredItems) {
      totalPressed += item.btnPressed!.length;
    }
    update();
  }

  void filterClear() {
    _filteredItems.clear();
    totalPressed = 0;
    _filteredItems = [..._items];
    totalAttempts = _filteredItems.length;
    for (var item in _filteredItems) {
      totalPressed += item.btnPressed!.length;
    }
    update();
  }

  ExerciseModel() {
    fetch();
  }

  Future fetch() async {
    //clear any existing data we have gotten previously, to avoid duplicate data
    _items.clear();
    //reset button count
    totalPressed = 0;
    //indicate that we are loading
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on

    //get all movies
    var querySnapshot =
        await exercisesCollection.orderBy("startAt", descending: true).get();

    //iterate over the movies and add them to the list
    querySnapshot.docs.forEach((doc) {
      //note not using the add(Exercise item) function, because we don't want to add them to the db
      var exercise =
          Exercise.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      _items.add(exercise);
      totalPressed += exercise.btnPressed!.length;
    });

    totalAttempts = _items.length;

    //we're done, no longer loading
    loading = false;

    filterClear();
  }

  Exercise get(String id) {
    // if (id == null) return null;
    return _items.firstWhere((exercise) => exercise.id == id);
  }

  Future<String> add(Exercise item) async {
    loading = true;
    var result = await exercisesCollection.add(item.toJson());

    //refresh the db
    await fetch();
    return result.id;
  }

  Future updateItem(
    String id,
    bool isCompleted,
    int repeDone,
    int timeTaken,
    String endAt,
  ) async {
    loading = true;

    try {
      await exercisesCollection.doc(id).update(
        {
          'completed': isCompleted,
          'timeTaken': timeTaken,
          'repetitionDone': repeDone,
          'endAt': endAt
        },
      );
      print('Document successfully updated!');
    } catch (e) {
      print('Error updating document $e');
    }

    //refresh the db
    await fetch();
  }

  Future addButton(String id, String btnTime, String btnTitle) async {
    await exercisesCollection.doc(id).update({
      "btnPressed": FieldValue.arrayUnion([
        {btnTime: btnTitle}
      ])
    });
  }

  Future addImgPath(String id, String imgPath) async {
    // loading = true;
    update();

    try {
      await exercisesCollection.doc(id).update({"imgPath": imgPath});
      print('Image successfully uploaded!');
    } catch (e) {
      print('Error uploading document $e');
    }

    //refresh the db
    await fetch();
  }

  Future delete(String id) async {
    loading = true;
    update();

    await exercisesCollection.doc(id).delete();

    //refresh the db
    await fetch();
  }

  // This call tells the widgets that are listening to this model to rebuild.
  void update() {
    notifyListeners();
  }
}
