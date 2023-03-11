import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_assistant_app/Home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Speech to text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
