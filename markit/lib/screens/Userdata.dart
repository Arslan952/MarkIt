import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'adduser.dart';
class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final CollectionReference _reference =
  FirebaseFirestore.instance.collection('user');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: FutureBuilder<QuerySnapshot>(
         future: _reference.get(),
         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
           if (snapshot.hasError) {
             return Center(
               child: Text('Some Error occured ${snapshot.error}'),
             );
           }
           if (snapshot.hasData) {
             //Get Data
             QuerySnapshot querySnapshot = snapshot.data;
             List<QueryDocumentSnapshot> document = querySnapshot.docs;
             //Convert to a List Map
             List<Map> item = document.map((e) => e.data() as Map).toList();
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
                     itemCount: item.length,
                     shrinkWrap: true,
                     physics: ScrollPhysics(),
                     itemBuilder: (context, index) {
                       Map thisItem = item[index];
                       return Slidable(
                         startActionPane: ActionPane(
                           motion: BehindMotion(),
                           children: [
                             SlidableAction(
                               onPressed: (context) {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => AddUser()),
                                 );
                               },
                               icon: Icons.update,
                               label: "Update",
                               backgroundColor: Colors.blue,
                             ),
                             SlidableAction(
                               onPressed: (context) {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => AddUser()),
                                 );
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
                               backgroundImage: NetworkImage('${thisItem['image']}'),
                             ),
                           ),
                           /* thisItem.containsKey('image')
                                    ? Image.network('${thisItem['image']}')
                                    : Container(
                                        color: Colors.indigo,
                                      ),*/
                           title: Text('${thisItem['firstname']}'),
                           subtitle: Text('${thisItem['userid']}'),
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
           }
           return CircularProgressIndicator();
         },
       ),

    );
  }
}
