import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:markit/screens/updateuser.dart';

import 'adduser.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('User').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder:
              (context,snapshot) {
            if(snapshot.hasError){
              print("Some thing went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xffff928e),
                    color: Color(0xff7d91f4),
                  )
              );
            }


            return  SafeArea(
         child: Column(
           children: [
             Padding(
               padding: EdgeInsets.all(10),
               child: Text(
                 'Student Data',
                 style:
                 TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.indigoAccent),
               ),
             ),
             SizedBox(
               height: 5,
             ),
             Container(
               height: 500,
               child: Padding(
                 padding: EdgeInsets.all(20),
                 child: ListView.builder(
                     itemCount: snapshot.data!.docs.length,
                     shrinkWrap: true,
                     physics: ScrollPhysics(),
                     itemBuilder: (context, index) {
                       DocumentSnapshot doc = snapshot.data!.docs[index];
                       return Slidable(
                         startActionPane: ActionPane(
                           motion: BehindMotion(),
                           children: [
                             SlidableAction(
                               onPressed: (context) {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => UpdateUser(id:doc.id)),
                                 );
                               },
                               icon: Icons.update,
                               label: "Update",
                               backgroundColor: Colors.blue,
                             ),
                             SlidableAction(
                               onPressed: (context)
                                 async {
                                   try {
                                     FirebaseFirestore.instance.collection('User').doc(doc.id).delete();
                                   } catch (e) {
                                     print(e);
                                   }
                                 },

                               icon: Icons.delete,
                               label: "Delete",
                               backgroundColor: Colors.red,
                             )
                           ],
                         ),
                         child: ListTile(
                           leading:FittedBox(
                             fit: BoxFit.contain,
                             child: CircleAvatar(
                               radius: 80,
                               backgroundImage: NetworkImage(doc['image']),
                             ),
                           ),
                           /* thisItem.containsKey('image')
                                    ? Image.network('${thisItem['image']}')
                                    : Container(
                                        color: Colors.indigo,
                                      ),*/
                           title: Text(doc['firstname']),
                           subtitle: Text(doc['userid']),
                         ),
                       );
                     }),

               ),
             ),
             SizedBox(
               height: 15,
             ),
             GestureDetector(
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => AddUser()),
                 );
               },
               child: Container(
                 height: 50,
                 margin: const EdgeInsets.symmetric(horizontal: 50),
                 decoration: BoxDecoration(
                     color: Colors.indigoAccent,
                     borderRadius: BorderRadius.circular(20)),
                 child: const Center(
                   child: Text(
                     "Add Student",
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
              }),
    );
  }
}

