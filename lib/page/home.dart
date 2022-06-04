import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            'Button',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(100, 100),
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

        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), primary: Colors.red),
          child: Container(
            width: 200,
            height: 200,
            alignment: Alignment.center,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Text(
              'button',
              style: TextStyle(fontSize: 24),
            ),
          ),
          onPressed: () {},
        )
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
        );
  }
}
