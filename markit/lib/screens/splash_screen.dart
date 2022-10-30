import 'dart:async';

import 'package:flutter/material.dart';
import 'package:markit/screens/introductionScreen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () { 
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>IntroductioScreen()));
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.width / 5,
            ),
            Container(
              height: size.height/2,
              width: size.width/1.2,
              decoration: const BoxDecoration(

                image: DecorationImage(
                  image: AssetImage("assets/logo.png"),
                  fit: BoxFit.cover
                )
              ),
            ),
            SizedBox(
              height: size.height/12,
            ),
            Container(
              height: size.height/20,
              width: size.width/10,
              child: const CircularProgressIndicator(
                backgroundColor: Colors.indigoAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
