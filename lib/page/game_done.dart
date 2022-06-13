import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stroke_rehab/exercise.dart';

class GameDone extends StatelessWidget {
  final Exercise gameResult;

  const GameDone({Key? key, required this.gameResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(' check ${gameResult.toJson()}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${gameResult.toJson()}'),
              Text('Done'),
            ],
          ),
        ),
      ),
    );
  }
}
