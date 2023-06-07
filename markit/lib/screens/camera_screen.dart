import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markit/screens/notmarked.dart';
import 'package:markit/screens/successpage.dart';

import 'attendance_already.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _base64Image;
  bool isloading=false;


  Future<void> _captureAndConvertToBase64() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(imageBytes);
      });
      print('Base64 Image: $_base64Image');
    }
  }
  void updateAttendanceStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final collection = FirebaseFirestore.instance.collection('User');

      final document = await collection.doc(user!.uid).get();
      final attendanceList = List<Map<String, dynamic>>.from(document.data()!['attendance'] ?? []);
      final now = DateTime.now();
      bool attendanceAlreadyMarked = false;

      for (int i = 0; i < attendanceList.length; i++) {
        final attendanceDate = attendanceList[i]['date'].toDate();

        if (attendanceDate.year == now.year &&
            attendanceDate.month == now.month &&
            attendanceDate.day == now.day) {
          if (attendanceList[i]['status'] == true) {
            attendanceAlreadyMarked = true;
          } else {
            attendanceList[i]['status'] = true;
          }
          break;
        }
      }

      if (attendanceAlreadyMarked) {
        setState(() {
          isloading=false;
        });
        Get.to(const Attendancealready());
        print('Already marked.');

      } else {
        await collection.doc(user.uid).update({'attendance': attendanceList});
        print('Attendance status updated successfully.');
        setState(() {
          isloading = false;
        });
        Get.to(Marked());
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print('Error updating attendance status: $e');
      Get.to(NotMarked());
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading==true?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please be patient.....',style: TextStyle(fontSize: 18),),
              SizedBox(height: 20,),
              Center(child: CircularProgressIndicator(
                backgroundColor: Color(0xffff928e),
                color: Color(0xff7d91f4),
              ),),
            ],
          ):
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: _base64Image != null
                  ? Image.memory(
                      base64Decode(_base64Image!),
                      width: 200,
                      height: 200,
                    )
                  : Image.asset('assets/faceimage.jpg'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Scan Face",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Smile and scan image to mark attendance",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: _captureAndConvertToBase64,
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    "Capture Image",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: ()async {
                print("hello");
                try {
                  setState(() {
                    isloading=true;
                  });
                  final response = await post(
                    Uri.parse("http://192.168.26.51:5000/recognize"),
                    headers: {'Content-Type': 'application/json'},
                     body: json.encode(
                       {
                        'image' :_base64Image
                       }
                     )
                  );
                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body.toString());
                    if(data['message']=="success")
                      {
                       updateAttendanceStatus();
                      }
                      else if(data['id']=="Not in database"||data['id']=="Invalid Image")
                        {
                          setState(() {
                            isloading=false;
                          });
                          Get.to(const NotMarked());
                        }
                    print(response.body);
                    print("Done");
                  } else {
                    var data = jsonDecode(response.body.toString());
                    if (data.containsKey("error")) {
                      print(data["error"]);
                    } else {
                      print(data);
                    }
                  }
                } catch (e) {
                  print("Error: $e");
                  log("Error: $e");
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    "Mark Attendance",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
