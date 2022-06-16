import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/page/game_select.dart';
import 'package:stroke_rehab/page/history.dart';
import 'package:stroke_rehab/page/home.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

Future<FirebaseApp> initializeFirebase() async {
  if (kIsWeb) {
    return await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBIdUH-9Gh7JxdtcM_o1fusQBCnYVaV8MA",
            authDomain: "kit721-dbe67.firebaseapp.com",
            projectId: "kit721-dbe67",
            storageBucket: "kit721-dbe67.appspot.com",
            messagingSenderId: "57614175506",
            appId: "1:57614175506:web:ed94093c031445c516f7cb",
            measurementId: "G-MQP8WR83JG"));
  } else {
    //android and ios get config from the GoogleServices.json and .plist files
    return await Firebase.initializeApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ExerciseModel(),
      child: MaterialApp(
        title: 'Stroke Rehab',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final screens = [
    const Home(),
    const GameSelect(),
    const History(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
