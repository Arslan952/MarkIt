import 'package:flutter/material.dart';
import 'package:markit/screens/Userdata.dart';
class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //       image: DecorationImage(
          //           alignment: Alignment.topCenter,
          //           image: AssetImage("assets/back.png"))),
          // ),
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: -100,
                  top: -120,
                  child: Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Color(0xffff928e),
                      borderRadius: BorderRadius.all(Radius.circular(99999)),
                    ),
                  ),
                ),
                Positioned(
                  left: -100,
                  top: -150,
                  child: Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Color(0xff7d91f4),
                      borderRadius: BorderRadius.all(Radius.circular(99999)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Welcome",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    " to Admin Panel",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        IconButton(

                          color: Colors.white,
                          onPressed: () {
                            onPressed: () async {

                            };
                          },
                          icon: Icon(Icons.exit_to_app),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        GestureDetector(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                               Image(
                                  image: AssetImage("assets/adddata.png"),
                                  height: 128,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Add User",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserData()),
                            );
                          },
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage("assets/qrcode.png"),
                                height: 128,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "QR Code Scan",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                ),
                              )
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage("assets/qrcode.png"),
                                height: 128,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "QR Code Scan",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                ),
                              )
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage("assets/qrcode.png"),
                                height: 128,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "QR Code Scan",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
