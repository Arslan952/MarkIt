import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markit/screens/introductionScreen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
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
            Container(
              height: MediaQuery.of(context).size.height * .7,
              width:  MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo.png"),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'markit',
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * .1,
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height * .3,
              width:  MediaQuery.of(context).size.width * 1,
              alignment: Alignment.topCenter,
              child: Container(
                child: const CircularProgressIndicator(
                  backgroundColor: Color(0xffff928e),
                  color: Color(0xff7d91f4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
