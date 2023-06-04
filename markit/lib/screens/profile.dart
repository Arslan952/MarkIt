import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  String fname, lname, rollid, image, email;

  Profile(
      {Key? key,
      required this.fname,
      required this.lname,
      required this.rollid,
      required this.image,
      required this.email})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? pickedimage;
  String imageUrl = '';
  void updateField() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('User') // Replace with your collection name
        .doc(user!.uid) // Replace with the document ID you want to update
        .update({
      'image': imageUrl
    })
        .then((value) {
      // Update successful
    })
        .catchError((error) {
      // Handle error
    });
  }
  @override
  initState() {
    imageUrl = widget.image;
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: size.height*0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),

                  ),
                ),
                Positioned(
                  top: size.height*0.1,
                  left: size.width*0.33,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: CircleAvatar(
                          radius: 51,
                          backgroundColor: Colors.indigoAccent,
                          child: CircleAvatar(
                            radius: 49,
                            backgroundColor: Colors.white,
                            backgroundImage: imageUrl == null
                                ? null
                                : NetworkImage(imageUrl),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 65,
                        child: RawMaterialButton(
                          elevation: 10,
                          fillColor: Colors.white60,
                          padding: const EdgeInsets.all(5),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Chose Option",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          InkWell(
                                            onTap: ()async {
                                              ImagePicker imagePicker = ImagePicker();
                                              XFile? file = await imagePicker.pickImage(
                                                  source: ImageSource.camera);
                                              final tempimage=File(file!.path);
                                              setState(() {
                                                pickedimage=tempimage;
                                              });
                                              String UniqueFileName =
                                              DateTime.now().millisecondsSinceEpoch.toString();
                                              //Reference
                                              Reference referenceroot = FirebaseStorage.instance.ref();
                                              Reference referenceDirimage = referenceroot.child('images');
                                              Reference referencImageToUpload =
                                              referenceDirimage.child(UniqueFileName);
                                              try {
                                                //store the file
                                                await referencImageToUpload.putFile(File(file.path));
                                                //get download url
                                                imageUrl = await referencImageToUpload.getDownloadURL();
                                              } catch (e) {}
                                              //store the file
                                              referencImageToUpload.putFile(File(file.path));
                                            },
                                            splashColor: Colors.indigoAccent,
                                            child: Row(
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.camera,
                                                    color: Colors.indigo,),
                                                ),
                                                Text("Camera",style: TextStyle(
                                                    color: Colors.blue,fontSize: 18,
                                                    fontWeight: FontWeight.w500
                                                ),)
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              ImagePicker imagePicker = ImagePicker();
                                              XFile? file = await imagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                              final tempimage=File(file!.path);
                                              setState(() {
                                                pickedimage=tempimage;
                                              });
                                              String UniqueFileName =
                                              DateTime.now().millisecondsSinceEpoch.toString();
                                              //Reference
                                              Reference referenceroot = FirebaseStorage.instance.ref();
                                              Reference referenceDirimage = referenceroot.child('images');
                                              Reference referencImageToUpload =
                                              referenceDirimage.child(UniqueFileName);
                                              try {
                                                //store the file
                                                await referencImageToUpload.putFile(File(file!.path));
                                                //get download url
                                                setState(() async{
                                                  imageUrl = await referencImageToUpload.getDownloadURL();
                                                });

                                              } catch (e) {}
                                              //store the file
                                              referencImageToUpload.putFile(File(file.path));
                                            },
                                            splashColor: Colors.indigoAccent,
                                            child: Row(
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.image,
                                                    color: Colors.indigo,),
                                                ),
                                                Text("Gallery",style: TextStyle(
                                                    color: Colors.blue,fontSize: 18,
                                                    fontWeight: FontWeight.w500
                                                ),)
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              Navigator.of(context).pop();
                                            },
                                            splashColor: Colors.indigoAccent,
                                            child: Row(
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.cancel,
                                                    color: Colors.red,),
                                                ),
                                                Text("Remove",style: TextStyle(
                                                    color: Colors.blue,fontSize: 18,
                                                    fontWeight: FontWeight.w500
                                                ),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.indigoAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),


              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "First Name:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.fname,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last Name:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.lname,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.email,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ID:",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.rollid,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.2),
                child: InkWell(
                  onTap: updateField,
                  child: Container(
                    height: size.height * 0.07,
                    decoration: BoxDecoration(
                        color: Color(0xff6987F3),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        "Change Image",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); // Start at the bottom-left corner
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50); // Draw a quadratic curve to the bottom-right corner
    path.lineTo(size.width, 0); // Draw a line to the top-right corner
    path.lineTo(0, 0); // Draw a line to the top-left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
