import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  final String id;

  UpdateUser({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('User').doc(widget.id).get(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            print("Some thing went wrong");
          }
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
          return Form(
            key: key,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Add Student Data',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                        fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        labelText: "First Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        labelText: "Last Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        labelText: "User Id",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
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
                      print(e);
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
                ),
              ],
            ),
          );
        },
      ))),
    );
  }
}
