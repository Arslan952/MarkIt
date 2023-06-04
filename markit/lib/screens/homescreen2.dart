// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:markit/screens/leave_page.dart';
import 'package:markit/screens/sidebarscreen.dart';
import 'package:markit/widget/homecard.dart';

import 'camera_screen.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  //To do List
  CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('User');
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
    String _barcode = "";
    var size=MediaQuery.of(context).size;
    return Scaffold(
        key: scaffoldkey,
        endDrawer:SideBarScreen(),
        backgroundColor: Color(0xffF5F5F5),
        body:StreamBuilder<DocumentSnapshot>(
            stream: usersCollection.doc(user?.uid).snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xffff928e),
                      color: Color(0xff7d91f4),
                    ));
              }
              return  SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:size.width*0.07,vertical: size.height*0.05 ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Dashboard",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Container(height: 50,width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                      image: NetworkImage(streamSnapshot.data!['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  // child: Image.network(streamSnapshot.data!['image']),
                                ),
                                SizedBox(width: size.width*0.03,),
                                IconButton(onPressed: ()=>scaffoldkey.currentState?.openEndDrawer(), icon:Icon(Icons.arrow_drop_down_circle))
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height*0.05,
                        ),
                        Container(
                          height: size.height*0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/bg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.07,vertical: size.height*0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text("${"Hey, "+streamSnapshot.data!['firstname']} " +
                                     streamSnapshot.data!['lastname'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
                                SizedBox(height: size.height*0.02,),
                                const Text("Welcome back. Let's get some stuff rolling!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.height*0.05,),
                        InkWell(
                          onTap: ()async {
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
                            child: HomeCard(name: "QR\n Code", icon: Icons.qr_code_2, color:Colors.purple)),
                        SizedBox(height: size.height*0.03,),
                        InkWell(
                            onTap: (){
                              Get.to(CameraScreen());
                            },
                            child: HomeCard(name: "Face\n Scan", icon: Icons.camera_alt_outlined, color:Color(0xffFF8A5B))),
                        SizedBox(height: size.height*0.03,),
                        InkWell(
                            onTap: (){
                              Get.to(LeaveApplicationForm());
                            },
                            child: HomeCard(name: "Leave\n Application", icon: Icons.note_alt_outlined, color:Color(0xff6987F3)))
                      ],
                    ),
                  ),
                ),
              );

            }));
  }
}
