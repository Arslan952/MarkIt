import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markit/screens/notmarked.dart';
import 'package:markit/screens/successpage.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _base64Image;

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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              onTap: () async {
                print("hello");
                try {
                  final response = await post(
                    Uri.parse("http://192.168.10.3:5000/recognize"),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      "image": _base64Image
                    }),
                  );
                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body.toString());
                    if(data['message']=="sucess")
                      {
                        Get.to(const Marked());
                      }
                      else if(data['id']=="Not in database"||data['id']=="Invalid Image")
                        {
                          Get.to(const NotMarked());
                        }
                    final CollectionReference collection =
                        FirebaseFirestore.instance.collection('getid');
                    collection.add({
                      'timestamp': DateTime.now(),
                      'uid': data['id']
                      // Add more fields as needed
                    }).then((DocumentReference document) {
                      print('Data saved successfully with ID: ${document.id}');
                    }).catchError((error) {
                      print('Failed to save data: $error');
                    });
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
