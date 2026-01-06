import 'package:flutter/material.dart';
import 'package:snapchat_copy/CameraScreen.dart';
import 'package:snapchat_copy/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initCameras();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: homePage(),
    );
  }
}
