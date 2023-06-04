import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markit/screens/login.dart';
import 'package:markit/screens/profile.dart';

class SideBarScreen extends StatelessWidget {
  const SideBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    //To do List
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('User');
    return StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(user?.uid).snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Color(0xffff928e),
              color: Color(0xff7d91f4),
            ));
          }
          return SafeArea(
              child: SizedBox(
            width: 280,
            child: Drawer(
              width: 220,
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/bg.png'),
                        fit: BoxFit.fill,
                      ),
                      // gradient: LinearGradient(
                      //   colors: [Color(0xff6987F3), Color(0xffFF8A5B)], // Replace with the desired gradient colors
                      //   begin: Alignment.topCenter, // Replace with the desired gradient begin position
                      //   end: Alignment.bottomCenter, // Replace with the desired gradient end position
                      // ),
                    ),
                    accountName: Text(
                      streamSnapshot.data!['firstname'] +
                          " " +
                          streamSnapshot.data!['lastname'],
                    ),
                    accountEmail: Text(streamSnapshot.data!['email']),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                        streamSnapshot.data!['image'],
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(Profile(
                        fname: streamSnapshot.data!['firstname'],
                        lname: streamSnapshot.data!['lastname'],
                        rollid: '',
                        image: streamSnapshot.data!['image'],
                        email: streamSnapshot.data!['email'],
                      ));
                    },
                    leading: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    title: Text("Profile"),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    title: Text("Logout"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                  )
                ],
              ),
            ),
          ));
        });
  }
}
