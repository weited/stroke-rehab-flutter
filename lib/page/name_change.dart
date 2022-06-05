import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: Center(
          child: Text('name change'),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: txtNameController,
            decoration:
                InputDecoration(hintText: "Enter Name", labelText: "Name"),
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
