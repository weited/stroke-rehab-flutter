import 'package:flutter/material.dart';

class GameCustom extends StatefulWidget {
  const GameCustom({Key? key}) : super(key: key);

  @override
  State<GameCustom> createState() => _GameCustomState();
}

class _GameCustomState extends State<GameCustom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,title: Text('Game Customization')),
        body: Center(child: Text('custom')));
  }
}
