import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/widgets/history_list_item.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> modeDropItems = ['All', 'Repetition', 'Time Limit', 'Free Mode'];
  List<String> imgDropItems = ['All', 'Image', 'No Image'];

  String modeSelectedItem = 'All';
  String imgSelectedItem = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, ExerciseModel exerciseModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mode:'),
                        DropdownButton<String>(
                          value: modeSelectedItem,
                          items: modeDropItems
                              .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                  )))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              modeSelectedItem = newValue!;
                              exerciseModel.filterByModeAndImg(
                                  modeSelectedItem, imgSelectedItem);
                            });
                          },
                        ),
                        Text('Image:'),
                        DropdownButton<String>(
                          value: imgSelectedItem,
                          items: imgDropItems
                              .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                  )))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              imgSelectedItem = newValue!;
                              exerciseModel.filterByModeAndImg(
                                  modeSelectedItem, imgSelectedItem);
                            });
                          },
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: CircleBorder(),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.clear),
                                  color: Colors.white,
                                  iconSize: 15,
                                  onPressed: () {
                                    setState(() {
                                      exerciseModel.filterClear();
                                      modeSelectedItem = modeDropItems[0];
                                      imgSelectedItem = imgDropItems[0];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              'Total Attempts:',
                              style: kDetailRowTextStyle,
                            ),
                          ),
                          Text(
                            exerciseModel.totalAttempts.toString(),
                            style: kDetailRowTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Total Button Pressed:',
                            style: kDetailRowTextStyle,
                          ),
                        ),
                        Text(
                          exerciseModel.totalPressed.toString(),
                          style: kDetailRowTextStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5),
                    top: BorderSide(width: 1.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Repetitions',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            'Time',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Detail',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (exerciseModel.loading)
                const CircularProgressIndicator()
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemBuilder: (_, index) {
                          Exercise exercise = exerciseModel.items[index];
                          return HistoryListItem(
                              exercise: exercise,
                              keepFilter: () {
                                // pass function so after deleted the filter can stay same
                                exerciseModel.filterByModeAndImg(
                                    modeSelectedItem, imgSelectedItem);
                              });
                        },
                        itemCount: exerciseModel.items.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
