import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:markit/adminpanel.dart';
import 'package:markit/screens/updateuser.dart';

import 'adduser.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String name = "";
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('User').snapshots();

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
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


            return  SingleChildScrollView(
              child: SafeArea(
         child: Column(
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
                         MaterialPageRoute(builder: (context) => AdminPanel()),
                       );
                     },
                     icon: const Icon(
                       LineAwesomeIcons.angle_left,
                     ),
                   ),
                   Text(
                     "User Data",
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
               SizedBox(
                 height: 5,
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextField(
                   decoration: InputDecoration(
                     contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                     hintText: "Search",
                       suffixIcon:Icon(Icons.search,
                       color: Colors.indigoAccent,),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20),
                       borderSide: BorderSide()
                     )
                   ),
                   onChanged: (val) {
                     setState(() {
                       name = val;
                     });
                   },
                 ),
               ),
               Container(
                 height: 500,
                 child: Padding(
                   padding: EdgeInsets.all(5),
                   child: ListView.builder(
                       itemCount: snapshot.data!.docs.length,
                       shrinkWrap: true,
                       physics: ScrollPhysics(),
                       itemBuilder: (context, index) {
                         DocumentSnapshot doc = snapshot.data!.docs[index];
                         return  Slidable(
                           startActionPane: ActionPane(
                             //extentRatio: 1,(0.1 to 1)
                             openThreshold: 0.5,
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
                                 borderRadius:BorderRadius.circular(20),
                                 backgroundColor: Colors.blue,
                               ),
                               SizedBox(width: 5,),
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
                                 borderRadius:BorderRadius.circular(20),
                                 backgroundColor: Colors.red,
                               )
                             ],
                           ),
                           child: Card(
                             shape: RoundedRectangleBorder(
                              /* side:  BorderSide(
                                 color: Colors.indigoAccent,
                               ),*/
                               borderRadius: BorderRadius.circular(20.0), //<--// SEE HERE
                             ),
                             elevation: 10,
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
                           ),
                         );
                       }),

                 ),
               ),
               const SizedBox(
                 height: 15,
               ),
             SizedBox(
               width: MediaQuery.of(context).size.width*0.50,
               height: 50,
               child: ElevatedButton(
                   onPressed:() {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => AddUser()),
                     );
                   },
                   style: ElevatedButton.styleFrom(
                       elevation: 30,
                       backgroundColor: Colors.blue,
                       shadowColor: Colors.indigo,
                       side: BorderSide.none,
                       shape: StadiumBorder()
                   ),
                   child:Text("Add Data",style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.w500
                   ),)),
             ),
              /* GestureDetector(
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
               ),*/
           ],
         ),
       ),
            );
              }),
    );
  }
}

