import 'package:chat_fusion/helper/helper_functions.dart';
import 'package:chat_fusion/pages/auth/login_page.dart';
import 'package:chat_fusion/pages/home_page.dart';
import 'package:chat_fusion/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb) {

    //run initialization for web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: Constants.appId,
        apiKey: Constants.apiKey,
        projectId: Constants.projectId,
        messagingSenderId: Constants.messagingSenderId,
      ),
    );

  }
  else {
    //run initialization for android, ios
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: Constants.appId,
        apiKey: Constants.apiKey,
        projectId: Constants.projectId,
        messagingSenderId: Constants.messagingSenderId,
      ),
    );
  }


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();

    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {

    HelperFunctions.getUserLoggedInStatus().then((value) {
      setState(() {
        _isSignedIn = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Fusion',
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
