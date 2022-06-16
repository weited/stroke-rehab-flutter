import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/page/history_details.dart';

class HistoryListItem extends StatelessWidget {
  final Exercise exercise;

  const HistoryListItem(
      {Key? key,
      required this.exercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HistoryDetails(id: exercise.id!);
          }));
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(child: Text(exercise.repetitionDone.toString())),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text('Start At:'),
                            ),
                            Text('${exercise.startAt}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text('End At:'),
                            ),
                            Text('${exercise.endAt ?? 'Uncompleted'}')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
