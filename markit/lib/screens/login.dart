import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:markit/adminpanel.dart';
import 'package:markit/screens/forgetPassword.dart';

import 'homescreen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  var email = "";
  var password = "";
  bool _obsecuretext = true;

  //Text editing controller
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //User login function through Firebase
    userlogin(String email, String password) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.indigoAccent,
              content: Text(
                'User not Found',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.indigoAccent,
              content: Text(
                'Password is incorrect Please try again',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )));
        }
      }
      /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);*/
    }

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Container(
                    height: size.height / 2.5,
                    width: size.width / 1,
                    child: const Image(
                      image: AssetImage("assets/login.png"),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                   Center(
                    child: Text(
                      "Login with email",
                      style: GoogleFonts.poppins(
                          textStyle:  const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black87
                          )),

                         /* TextStyle(fontSize: 22, fontWeight: FontWeight.bold),*/
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.indigoAccent))),
                    child: TextFormField(
                      autofocus: false,
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
                      decoration: const InputDecoration(
                        prefixIcon: Icon(LineAwesomeIcons.envelope,
                        color: Colors.indigoAccent,),
                          hintText: "Enter your Email",
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.indigoAccent))),
                    child: TextFormField(
                      autofocus: false,
                      obscureText: _obsecuretext,
                      textInputAction: TextInputAction.done,
                      controller: passwordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Valid Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LineAwesomeIcons.fingerprint,
                        color: Colors.indigoAccent,),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obsecuretext = !_obsecuretext;
                              });
                            },
                            child: Icon(_obsecuretext
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 25,
                  ),
                  GestureDetector(
                    child: const Text(
                      'Forget Password',
                      style: TextStyle(color: Colors.black45),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgetPassword()),
                          (route) => false);
                    },
                  ),
                  SizedBox(
                    height: size.height / 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (emailcontroller.text == "admin" &&
                          passwordcontroller.text == "password") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPanel()),
                            (route) => false);
                      } else {
                        userlogin(
                            emailcontroller.text, passwordcontroller.text);
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
                          " Login",
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
          ),
        ),
      ),
    );
  }
}
