import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markit/screens/login.dart';
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
          return SafeArea(child: SizedBox(
      width: 280,
      child: Drawer(
        width: 220,
        child: ListView(
          children:  [
            UserAccountsDrawerHeader(
              accountName: Text(streamSnapshot.data!['firstname'] +
                  " " +
                  streamSnapshot.data!['lastname'],),
              accountEmail: Text(streamSnapshot.data!['email']),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(streamSnapshot.data!['image'],),
              ),),
            ListTile(leading: Icon(Icons.home),
              title: Text("Home"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(leading: Icon(Icons.person),
              title: Text("Profile"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
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
