import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

import '../widgets/PickerData.dart';

class Test extends StatefulWidget {
  // const Test({Key? key}) : super(key: key);

  // const Test({required Key key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Duration duration = Duration(minutes: 0, seconds: 30);
  final double listSpec = 4.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String stateText = "";
  Widget NewWidget() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Picker ${stateText.isEmpty ? "" : " - " + stateText}'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body:  SafeArea(

        // child: DecoratedBox(
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).primaryColor,
        //   ),
        //   child: const Text("A box using the primary colour, woo!"),
        // ),
          child: Center(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                child: const Text(
                  'Btt',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  print('hell');
                },
                onLongPress: () {
                  print('long press');
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 100),
                  shape: const CircleBorder(),
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                shape: const CircleBorder(),
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    'button',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Button tapped');
                },
                child: ElevatedButton(
                  child: const Text(
                    'Button',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 100),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
              // CupertinoPicker(
              //     itemExtent: 40,
              //     onSelectedItemChanged: (item) {
              //       print('selected $item');
              //     },
              //     children: [
              //       Center(child: Text('item one')),
              //       Center(child: Text('item two')),
              //       Center(child: Text('item one')),
              //       Center(child: Text('item two')),
              //       Center(child: Text('item one')),
              //       Center(child: Text('item two'))
              //     ]),
              // SizedBox(
              //   height: 180,
              //   child: CupertinoTimerPicker(
              //     initialTimerDuration: duration,
              //     mode: CupertinoTimerPickerMode.ms,
              //     minuteInterval: 1,
              //     secondInterval: 10,
              //     onTimerDurationChanged: (duration) {
              //       setState(() => this.duration = duration);
              //       print('duration is  (${duration.inSeconds})');
              //     },
              //   ),
              // ),

              // GestureDetector(
              //     onTap: () {
              //       print('Button tapped');
              //     },
              //     child: const CircleAvatar(
              //       radius: 100,
              //       backgroundColor: Colors.indigo,
              //       child: Text(
              //         'button',
              //         style: TextStyle(fontSize: 30),
              //       ),
              //     )),

              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       shape: const CircleBorder(), primary: Colors.red),
              //   child: Container(
              //     width: 200,
              //     height: 200,
              //     alignment: Alignment.center,
              //     decoration: const BoxDecoration(shape: BoxShape.circle),
              //     child: const Text(
              //       'button',
              //       style: TextStyle(fontSize: 24),
              //     ),
              //   ),
              //   onPressed: () {
              //     print('hello');
              //   },
              //   onLongPress: () {
              //     print('longs press');
              //   },
              // ),
            ]),
          )

        //   child: Container(
        //     width: 90,
        //     height: 90,
        //     child: RaisedButton(onPressed: (){
        //     },
        //       color: Colors.deepOrange,
        //       textColor: Colors.white,
        //       shape: CircleBorder(side: BorderSide.none),
        //       child: Text('Login',style: TextStyle(
        //           fontSize: 20.0
        //       ),
        //       ),
        //     ),
        //   ),
      ),
    );

  }

  // showPicker(BuildContext context) {
  //   Picker picker = new Picker(
  //       adapter: PickerDataAdapter<String>(
  //           pickerdata: new JsonDecoder().convert(PickerData)),
  //       changeToFirst: true,
  //       textAlign: TextAlign.left,
  //       columnPadding: const EdgeInsets.all(8.0),
  //       onConfirm: (Picker picker, List value) {
  //         print(value.toString());
  //         print(picker.getSelectedValues());
  //       });
  //   picker.show(_scaffoldKey.currentState!);
  // }
}

// class NewWidget extends StatelessWidget {
//   const NewWidget({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       child: const Text(
//         'But',
//         style: TextStyle(fontSize: 20),
//       ),
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//         fixedSize: const Size(100, 100),
//         shape: const CircleBorder(),
//       ),
//     );
//   }
// }
