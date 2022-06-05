import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'name_change.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = 'Explorer';

  // final prefs = await SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    print('The home initState');
  }

  // Home({Key? key, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // name = getUserName();
    // String name = 'Explorer';
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          )),
          Expanded(
            child: Center(
              child: TextButton(
                child: const Text(
                  'Change Name',
                  style: TextStyle(fontSize: 16),
                ),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  print('hello');
                  _navigateToChangeName(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('username') != null &&
        prefs.getString('username')?.isNotEmpty == true) {
      setState(() {
        name = prefs.getString('username')!;
      });
    }
  }

  Future<void> _navigateToChangeName(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NameChange()),
    );
    // get name again when navigated back
    getUserName();
    // setState(() {
    //   name = result;
    // });

    // print('The ### $result ');
  }
}

// class NameChange extends StatelessWidget {
//
//   const NameChange({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text('name change'),
//         ),
//       ),
//       body: Container(
//         child: TextField(
//           decoration: const InputDecoration(
//               hintText: "Enter Name",
//               labelText: "Name"
//           ),)
//         ,
//       ),
//     );
//   }
// }
