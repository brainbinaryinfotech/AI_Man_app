import 'package:ai_man_app/Detection/detection_Display_screen.dart';
import 'package:ai_man_app/Detection/detection_insert_Screen.dart';
import 'package:ai_man_app/Screen/Display_Screen/Display_screen.dart';
import 'package:ai_man_app/Screen/HomeScreen/Home_Screen.dart';
import 'package:ai_man_app/face_detection_demo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          storageBucket: 'tring-71c87.appspot.com',
          apiKey: "AIzaSyDpV31GEPO7S7-9yQ9jTRX3605n95drKR4", appId:"1:321622915677:android:e95ff54e3b091a65102bb4", messagingSenderId:  "321622915677", projectId: "tring-71c87"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:FaceDetectionPage()
    );
  }
}


