import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:markit/screens/Userdata.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final fnamecontroller = TextEditingController();
  final lnamecontroller = TextEditingController();
  final idcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  GlobalKey<FormState> key = GlobalKey();

  void clearText() {
    fnamecontroller.clear();
    lnamecontroller.clear();
    idcontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();
  }

  @override
  File? pickedimage;
  String imageUrl = '';

  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child:Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserData()),
                      );
                    },
                    icon: const Icon(
                      LineAwesomeIcons.angle_left,
                    ),
                  ),
                  Text(
                    "Add User",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,

                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: key,
              child: Column(
                 children: [
                   Stack(
                     children: [
                       Container(
                         margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                         child: CircleAvatar(
                           radius: 51,
                           backgroundColor: Colors.indigoAccent,
                           child: CircleAvatar(
                             radius: 49,
                             backgroundColor: Colors.white,
                             backgroundImage: pickedimage == null
                                 ? null
                                 : FileImage(pickedimage!),
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
                                                 imageUrl = await referencImageToUpload.getDownloadURL();
                                               } catch (e) {}
                                               //store the file
                                               referencImageToUpload.putFile(File(file!.path));
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
                   Padding(
                     padding: const EdgeInsets.only(left: 25, right: 25),
                     child: TextFormField(
                       controller: fnamecontroller,
                       textInputAction: TextInputAction.next,
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Please Enter First Name';
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                           label: Text("First Name"),
                           prefixIcon: Icon(LineAwesomeIcons.user),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100)),
                           floatingLabelStyle:
                           TextStyle(color: Colors.indigoAccent),
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100),
                               borderSide: BorderSide(
                                   width: 2, color: Colors.indigoAccent))),
                     ),
                   ),
                  const SizedBox(
                    height: 10,
                  ),
                   Padding(
                     padding: const EdgeInsets.only(left: 25, right: 25),
                     child: TextFormField(
                       controller: lnamecontroller,
                       textInputAction: TextInputAction.next,
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Please Enter Last Name';
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                           label: Text("Last Name"),
                           prefixIcon: Icon(LineAwesomeIcons.user_friends),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100)),
                           floatingLabelStyle:
                           TextStyle(color: Colors.indigoAccent),
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100),
                               borderSide: BorderSide(
                                   width: 2, color: Colors.indigoAccent))),
                     ),
                   ),

                  const SizedBox(
                    height: 10,
                  ),
                   Padding(
                     padding: const EdgeInsets.only(left: 25, right: 25),
                     child: TextFormField(
                       controller: idcontroller,

                       decoration: InputDecoration(
                           label: Text("User ID"),
                           prefixIcon:
                           Icon(LineAwesomeIcons.identification_card),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100)),
                           floatingLabelStyle:
                           TextStyle(color: Colors.indigoAccent),
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100),
                               borderSide: BorderSide(
                                   width: 2, color: Colors.indigoAccent))),
                     ),
                   ),
                  const SizedBox(
                    height: 10,
                  ),
                   Padding(
                     padding: const EdgeInsets.only(left: 25, right: 25),
                     child: TextFormField(
                       controller: emailcontroller,
                       textInputAction: TextInputAction.next,
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Please Enter Email';
                         } else if (!value.contains('@')) {
                           return 'Please Enter valid Email';
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                           label: Text("Email"),
                           prefixIcon: Icon(LineAwesomeIcons.envelope),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100)),
                           floatingLabelStyle:
                           TextStyle(color: Colors.indigoAccent),
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100),
                               borderSide: BorderSide(
                                   width: 2, color: Colors.indigoAccent))),
                     ),
                   ),
                  const SizedBox(
                    height: 10,
                  ),
                   Padding(
                     padding: const EdgeInsets.only(left: 25, right: 25),
                     child: TextFormField(
                       controller: passwordcontroller,
                       obscureText: true,
                       textInputAction: TextInputAction.done,
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Please Enter Valid Password';
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                           label: Text("Password"),
                           prefixIcon: Icon(LineAwesomeIcons.fingerprint),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100)),
                           floatingLabelStyle:
                           TextStyle(color: Colors.indigoAccent),
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(100),
                               borderSide: BorderSide(
                                   width: 2, color: Colors.indigoAccent))),
                     ),
                   ),
                  const SizedBox(
                    height: 30,
                  ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       SizedBox(
                         width: MediaQuery.of(context).size.width*0.40,
                         height: 50,
                         child: ElevatedButton(
                             onPressed: ()async {
                               if (imageUrl.isEmpty) {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                     const SnackBar(content: Text("Please Upload an Image")));
                                 return;
                               }
                               if (key.currentState!.validate()) {
                                 try {
                                   FirebaseAuth auth = FirebaseAuth.instance;
                                   User? user = FirebaseAuth.instance.currentUser;
                                   auth
                                       .createUserWithEmailAndPassword(
                                       email: emailcontroller.text,
                                       password: passwordcontroller.text)
                                       .then((signinUser) => {
                                     FirebaseFirestore.instance
                                         .collection('User')
                                         .doc(signinUser.user!.uid)
                                         .set({
                                       'firstname': fnamecontroller.text,
                                       'lastname': lnamecontroller.text,
                                       'userid': idcontroller.text,
                                       'email': emailcontroller.text,
                                       'password': passwordcontroller.text,
                                       'image': imageUrl,
                                     })
                                   });

                                 } catch (e) {
                                   print(e);
                                 }
                                 //Map
                                 /*  Map<String,String> itemToAdd={
                                  'firstname':fnamecontroller.text,
                                  'lastname':lnamecontroller.text,
                                  'userid':idcontroller.text,
                                  'email':emailcontroller.text,
                                  'password':passwordcontroller.text,
                                  'image':imageUrl,
                                };
                                //Collection Reference
                                CollectionReference ref=FirebaseFirestore.instance.collection('user');
                                //Add a document with custom id
                                ref.doc(fnamecontroller.text).set(itemToAdd);*/

                               }
                             },
                             style: ElevatedButton.styleFrom(
                                 elevation: 20,
                                 backgroundColor: Colors.blue,
                                 shadowColor: Colors.indigo,
                                 side: BorderSide.none,
                                 shape: StadiumBorder()
                             ),
                             child:Text("Save",style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.w500
                             ),)),
                       ),
                       SizedBox(
                         width: MediaQuery.of(context).size.width*0.40,
                         height: 50,
                         child: ElevatedButton(onPressed: (){
                           // clearText();
                           print(imageUrl);

                               },
                             style: ElevatedButton.styleFrom(
                                 elevation: 20,
                                 backgroundColor: Colors.white54,
                                 side: BorderSide.none,
                                 shape: StadiumBorder()
                             ),
                             child:Text("Clear",style: TextStyle(
                                 color: Colors.indigoAccent,
                                 fontWeight: FontWeight.w500
                             ),)),
                       )
                     ],
                   ),


                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
