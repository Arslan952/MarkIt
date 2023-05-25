import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Marked extends StatelessWidget {
  const Marked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                const Center(
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 200,
                    )),
                const Center(
                  child: Text(
                    "Attendance  Marked",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                ),
                // const Center(
                //   child: Text(
                //
                //     "Your Attendance not marked Please try again with clear face image of you",
                //     style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.w300),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                const SizedBox(height: 20,),

                Center(child:GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        "Go to Home Page",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ) ,)
              ],
            ),
          ),
        ));
  }
}
