import 'package:flutter/material.dart';
import '../firebase_Services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices SplashScreen = SplashServices();

  @override
  void initState(){
    super.initState();
    SplashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Voice Assistant', style: TextStyle(fontSize: 40),
        ),
        ),
    );
  }
}