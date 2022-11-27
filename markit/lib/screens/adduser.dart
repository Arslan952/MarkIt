import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final firebase=FirebaseFirestore.instance;
  GlobalKey<FormState> key=GlobalKey();
  void clearText() {
    fnamecontroller.clear();
    lnamecontroller.clear();
    idcontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();

  }
  @override
  String imageUrl='';
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(15),
                    child: Text('Add Student Data',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                        fontSize: 25

                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller:fnamecontroller,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "First Name",

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller:lnamecontroller,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Last Name",

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller:idcontroller,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Id';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "User Id",

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller:emailcontroller,
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
                          labelText: "Email",

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller:passwordcontroller,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Valid Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: IconButton(
                      onPressed:()
                      async {
                        ImagePicker imagePicker=ImagePicker();
                        XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                        print('${file?.path}');
                        String UniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
                        //Reference
                        Reference referenceroot=FirebaseStorage.instance.ref();
                        Reference referenceDirimage=referenceroot.child('images');
                        Reference referencImageToUpload=referenceDirimage.child(UniqueFileName);
                        try{
                          //store the file
                          await referencImageToUpload.putFile(File(file!.path));
                          //get download url
                          imageUrl=await referencImageToUpload.getDownloadURL();

                        }
                        catch(e)
                        {

                        }
                        //store the file
                        referencImageToUpload.putFile(File(file!.path));
                      },icon: Icon(Icons.camera),
                    ),
                  ),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: ()
                    async{
                      if(imageUrl.isEmpty)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Upload an Image")));
                        return;
                      }
                      if(key.currentState!.validate()){
                        try{
                          FirebaseAuth auth=FirebaseAuth.instance;
                          User? user=FirebaseAuth.instance.currentUser;
                          auth.createUserWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text).then((signinUser) =>{
                            FirebaseFirestore.instance.collection('User').doc(signinUser.user!.uid).set({

                              'firstname':fnamecontroller.text,
                              'lastname':lnamecontroller.text,
                              'userid':idcontroller.text,
                              'email':emailcontroller.text,
                              'password':passwordcontroller.text,
                              'image':imageUrl,
                            })
                          });
                        }
                        catch(e)
                        {
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

                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: ()
                   {
                     clearText();
                   },

                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          "Reset Fields",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),


                ],

              ),
            ),
          )

      ),
    );
  }
}
