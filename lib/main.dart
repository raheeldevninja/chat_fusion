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
    await Firebase.initializeApp();
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Fusion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
