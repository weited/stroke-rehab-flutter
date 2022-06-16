import 'package:flutter/material.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/exercise.dart';

class DisplayDetailCard extends StatelessWidget {
  final Exercise exercise;

  const DisplayDetailCard({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            _DetailsItemRow(title: 'Goal Type :', value: exercise.gameGoalType),
            _DetailsItemRow(
                title: 'Goal Value :',
                value: exercise.gameGoalType == GameGoalType.freeMode
                    ? 'Free Mode'
                    : exercise.gameGoalType == GameGoalType.repetitionLimit
                        ? '${exercise.repetitionLimit} Rounds'
                        : '${exercise.timeLimit} Seconds'),
            _DetailsItemRow(title: 'Start At :', value: exercise.startAt),
            _DetailsItemRow(
                title: 'End At :', value: exercise.endAt ?? 'Uncompleted'),
            _DetailsItemRow(
                title: 'Repetition Done',
                value: '${exercise.repetitionDone} Rounds'),
            if (exercise.gameGoalType != GameGoalType.timeLimit)
              _DetailsItemRow(
                  title: 'Time Taken', value: '${exercise.timeTaken} seconds'),
            _DetailsItemRow(
                title: 'Button Pressed',
                value: exercise.btnPressed!.length.toString()),
          ],
        ),
      ),
    );
  }
}

class _DetailsItemRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailsItemRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
          )),
          Expanded(child: Text(value))
        ],
      ),
    );
  }
}
