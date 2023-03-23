import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'Userdata.dart';

class UpdateUser extends StatefulWidget {
  final String id;

  const UpdateUser({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future:
                   FirebaseFirestore.instance.collection('User').doc(widget.id).get(),
                   builder: (_, snapshot) {
                     if (snapshot.hasError) {}
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                child: CircularProgressIndicator(
                     backgroundColor: Color(0xffff928e),
                    color: Color(0xff7d91f4),
                      ));
                }
                  var data = snapshot.data?.data();
                 var name = data!['firstname'];
                  var lname = data['lastname'];
               var userid = data['userid'];
                var email = data['email'];
                  return lumn(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        LineAwesomeIcons.angle_left,
                      ),
                    ),
                    Text(
                      "Update User",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserData()),
                        );
                      },
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
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        initialValue: name,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => name = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
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
                        /* decoration: InputDecoration(
                            labelText: "First Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),*/
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        initialValue: lname,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => lname = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
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
                        /* decoration: InputDecoration(
                            labelText: "Last Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),*/
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        initialValue: userid,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => userid = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Id';
                          }
                          return null;
                        },
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
                        /* decoration: InputDecoration(
                            labelText: "User Id",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),*/
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        initialValue: email,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) => email = value,
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
                        /*decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),*/
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(widget.id)
                                  .update({
                                'firstname': name,
                                'lastname': lname,
                                'userid': userid,
                                'email': email,
                              });
                            } catch (e) {}
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 30,
                              backgroundColor: Colors.blue,
                              shadowColor: Colors.indigo,
                              side: BorderSide.none,
                              shape: StadiumBorder()),
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    /*   GestureDetector(
                      onTap: () async {
                        try {
                          FirebaseFirestore.instance
                              .collection('User')
                              .doc(widget.id)
                              .update({
                            'firstname': name,
                            'lastname': lname,
                            'userid': userid,
                            'email': email,
                          });
                        } catch (e) {

                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ],
          );
        },
      ))),
    );
  }
}
