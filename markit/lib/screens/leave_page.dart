import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class LeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String? _leaveType;

  @override
  void dispose() {
    _reasonController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('User').doc(user.uid).get();
      final userData = snapshot.data();
      String username;

      if (userData != null) {
        // Access the user's data and perform further actions
        username = userData['firstname']+userData['lastname'];

        print('Username: $username');

      }

    if (_formKey.currentState!.validate()) {
      // Form is valid, process the leave application
      final reason = _reasonController.text;
      final startDate = _startDateController.text;
      final endDate = _endDateController.text;
      final leaveType = _leaveType;
      final CollectionReference collection = FirebaseFirestore.instance
          .collection('application');

      // Create a document with auto-generated ID
      collection.add({
        'timestamp':DateTime.now(),
      'name':userData!['firstname']+" "+userData['lastname'],
      'enddate': endDate,
      'startdate': startDate,
      'leavetype': leaveType,
      'reason': reason,
      // Add more fields as needed
      }).then((DocumentReference document) {
        print('Data saved successfully with ID: ${document.id}');
      }).catchError((error) {
        print('Failed to save data: $error');
      });
      // Perform further actions with the leave application data
      // For example, send it to an API or store it locally
    }
      // Reset form fields
      _reasonController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _leaveType = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave application submitted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Center(
                  child: Text(
                "Write Application",
                style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),
              const SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      maxLines: 5,
                      controller: _reasonController,
                      decoration:  InputDecoration(
                          prefixIcon: const Icon(LineAwesomeIcons.book_open,
                            color: Colors.indigoAccent,),
                          label: const Text("Enter your Reason for leave"),
                          hintStyle: const TextStyle(color: Colors.black45),
                          border:  OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.indigoAccent),
                              borderRadius: BorderRadius.circular(20)
                          ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 3, color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(20)
                        ),

                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a reason';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _startDateController,
                      decoration:  InputDecoration(
                        prefixIcon: const Icon(LineAwesomeIcons.calendar,
                          color: Colors.indigoAccent,),
                        label: const Text("Enter Start  date "),
                        hintStyle: const TextStyle(color: Colors.black45),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(20)
                        ),

                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a start date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _endDateController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LineAwesomeIcons.calendar,
                          color: Colors.indigoAccent,),
                        label: const Text("Enter End  date "),
                        hintStyle: const TextStyle(color: Colors.black45),
                        border:  OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(20)
                        ),

                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an end date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _leaveType,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LineAwesomeIcons.typo3,
                          color: Colors.indigoAccent,),
                        label: const Text("Enter End  date "),
                        hintStyle: const TextStyle(color: Colors.black45),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(20)
                        ),

                      ),
                      hint: const Text('Leave Type'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Annual Leave',
                          child: Text('Annual Leave'),
                        ),
                        DropdownMenuItem(
                          value: 'Sick Leave',
                          child: Text('Sick Leave'),
                        ),
                        DropdownMenuItem(
                          value: 'Maternity Leave',
                          child: Text('Maternity Leave'),
                        ),
                        DropdownMenuItem(
                          value: 'Paternity Leave',
                          child: Text('Paternity Leave'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _leaveType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a leave type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _submitForm,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            "Mark Attendance",
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
            ],
          ),
        ),
      ),
    );
  }
}
