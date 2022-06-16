import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String name = '';

  @override
  void initState() {
    // TODO: implement initState
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
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
            ),
          ),
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
                  _navigateToChangeName(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') != null &&
        prefs.getString('username')?.isNotEmpty == true) {
      setState(() {
        name = prefs.getString('username')!;
      });
    } else {
      setState(() {
        name = 'Explorer';
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
  }
}


class NameChange extends StatefulWidget {
  const NameChange({Key? key}) : super(key: key);

  @override
  State<NameChange> createState() => _NameChangeState();
}

class _NameChangeState extends State<NameChange> {
  var txtNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('name change'),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: txtNameController,
            decoration:
            const InputDecoration(hintText: "Enter Name", labelText: "Name"),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              //TODO: Navigate to second screen
              print(txtNameController.text);
              await setUserName(txtNameController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }
}

