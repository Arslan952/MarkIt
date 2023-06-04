import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:markit/screens/camera_screen.dart';
import 'package:markit/screens/leave_page.dart';
import 'package:markit/screens/sidebarscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  //To do List
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
    Size size = MediaQuery.of(context).size;
    String _barcode = "";
    return Scaffold(
        key: scaffoldkey,
        drawer:SideBarScreen(),
        body: StreamBuilder<DocumentSnapshot>(
            stream: usersCollection.doc(user?.uid).snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Color(0xffff928e),
                  color: Color(0xff7d91f4),
                ));
              }
              return Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: ()=>scaffoldkey.currentState?.openDrawer(),
                            child: Card(
                              color: const Color(0xffe7f0fa),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Colors.black,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  LineAwesomeIcons.stream,
                                  color: Color(0xff1f59da),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Profile',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black87),
                          ),
                          Card(
                            color: const Color(0xffe7f0fa),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: const [
                                  Icon(
                                    Icons.notifications,
                                    color: Color(0xff1f59da),
                                    size: 30,
                                  ),
                                  Positioned(
                                    top: 3,
                                    right: 1,
                                    child: Icon(
                                      Icons.brightness_1,
                                      color: Colors.red,
                                      size: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Card(
                        elevation: 3,
                        shadowColor: const Color(0xff6799e2),
                        color: const Color(0xffe7f0fa),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    streamSnapshot.data!['image'],
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 40,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Welcome Back",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.black26)),

                                      /* TextStyle(fontSize: 22, fontWeight: FontWeight.bold),*/
                                    ),
                                    Text(
                                      streamSnapshot.data!['firstname'] +
                                          " " +
                                          streamSnapshot.data!['lastname'],
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.black87)),

                                      /* TextStyle(fontSize: 22, fontWeight: FontWeight.bold),*/
                                    ),
                                    Text(
                                      streamSnapshot.data!['userid'].toString(),
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.black87)),

                                      /* TextStyle(fontSize: 22, fontWeight: FontWeight.bold),*/
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          InkWell(
                            onTap: () async {
                              try {
                                String barcode = (await BarcodeScanner.scan()) as String;
                                setState(() => _barcode = barcode);
                              } on PlatformException catch (e) {
                                if (e.code == BarcodeScanner.cameraAccessDenied) {
                                  setState(() => _barcode = "The user did not grant the camera permission!");
                                } else {
                                  setState(() => _barcode = "Unknown error: $e");
                                }
                              } on FormatException {
                                setState(() => _barcode = "null (User returned using the 'back'-button before scanning anything)");
                              } catch (e) {
                                setState(() => _barcode = "Unknown error: $e");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Card(
                                elevation: 10,
                                color: const Color(0xff1f59da),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 25,
                                      left: 25,
                                      child: Card(
                                        color: const Color(0xffe7f0fa),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        shadowColor: Colors.black,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            LineAwesomeIcons.barcode,
                                            color: Color(0xff1f59da),
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                        bottom: 40,
                                        left: 18,
                                        child: Text(
                                          'Scan QR Code ',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Get.to(CameraScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Card(
                                elevation: 10,
                                color: const Color(0xffe7f0fa),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 25,
                                      left: 25,
                                      child: Card(
                                        color: const Color(0xff1f59da),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        shadowColor: Colors.black,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            LineAwesomeIcons.neutral_face,
                                            color: Color(0xffe7f0fa),
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                        bottom: 40,
                                        left: 18,
                                        child: Text(
                                          'Scan Face',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0xff1f59da),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Card(
                              elevation: 10,
                              color: const Color(0xffe7f0fa),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Card(
                                      color: const Color(0xff1f59da),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      shadowColor: Colors.black,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          LineAwesomeIcons.bar_chart,
                                          color: Color(0xffe7f0fa),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                      bottom:40 ,
                                      left: 18,
                                      child: Text(
                                        'Attendance\n Detail',
                                        style: TextStyle(
                                            color: Color(0xff1f59da),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Get.to(LeaveApplicationForm());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Card(
                                elevation: 10,
                                color: const Color(0xff1f59da),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 25,
                                      left: 25,
                                      child: Card(
                                        color: const Color(0xffe7f0fa),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        shadowColor: Colors.black,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.note_alt_rounded,
                                            color: Color(0xff1f59da),
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                        bottom: 40,
                                        left: 18,
                                        child: Text(
                                          'Write\n Application',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              );
            }));
  }
}
/*Scaffold(
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
                    decoration: const BoxDecoration(
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
                    decoration: const BoxDecoration(
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
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: usersCollection.doc(user?.uid).snapshots(),
                      builder:  (context, streamSnapshot){
                        if (streamSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Color(0xffff928e),
                              color: Color(0xff7d91f4),
                            )
                          );
                        }
                        return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(

                          color: Colors.white,

                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()),
                            );
                          },

                          icon: const Icon(LineAwesomeIcons.list),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:NetworkImage( streamSnapshot.data!['image'],),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text(
                               streamSnapshot.data!['firstname']+" "+streamSnapshot.data!['lastname'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white),
                                ),
                                Text(
                                  streamSnapshot.data!['userid'],
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),

                      ],
                    );
                      }
                    )
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage("assets/profile.jpg"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Arslan Aslam",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "BCSM-F19-025",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
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
                              await FirebaseAuth.instance.signOut();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            };
                          },
                          icon: Icon(Icons.exit_to_app),
                           )
                      ],
                    ),*/
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
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
    );*/
