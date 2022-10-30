import 'package:flutter/material.dart';
import 'package:markit/screens/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductioScreen extends StatefulWidget {
  const IntroductioScreen({Key? key}) : super(key: key);

  @override
  State<IntroductioScreen> createState() => _IntroductioScreenState();
}

class _IntroductioScreenState extends State<IntroductioScreen> {
  @override
  Widget build(BuildContext context) {
    PageController _controller = PageController();
    //Keep track we are at last page or not
    bool onLastPage = false;
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      child: const Image(
                        image: AssetImage("assets/facial.jpg"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "Facial Reccognization",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                        "Application is able take attenance of a student through facial recognization",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15
                        ),
                      ),
                  ),

                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      child: const Image(
                        image: AssetImage("assets/idcard.jpg"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "ID Card Customization",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Student will able to customize Student Card with great themes.",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      child: const Image(
                        image: AssetImage("assets/management.jpg"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "Attendance Management",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Complete manageent of attende with the help of chart also apply for leaves and all the data manage on application.",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
        //page indicator
        Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text("Skip")),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                      activeDotColor: Colors.indigoAccent,
                      dotColor: Colors.indigoAccent.withOpacity(0.7)),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);

                        },
                        child: const Text("Next"))
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const Login();
                              }));
                        },
                        child: const Text("Done"))
              ],
            ))
      ]),
    );
  }
}
