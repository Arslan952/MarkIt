import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markit/screens/login.dart';
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formkey = GlobalKey<FormState>();
  var email = "";
  final emailcontroller = TextEditingController();
  resetpassword() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text('Password Reset mail sent to your Account',style: TextStyle(
              color: Colors.white,
              fontSize: 20
          ),)

      ));
    }
    on FirebaseAuthException catch(e)
    {
      if(e.code=='user-not-found')
      {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Text('User not Found',style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),)

        ));
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Forget Password',
                  style: GoogleFonts.oswald(
                      fontWeight: FontWeight.bold,
                      color:Colors.indigoAccent,
                      fontSize: 36),
                ),
              ),
              Image(image: AssetImage("assets/forget.png")),
              Form(

                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.indigoAccent))),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@')) {
                          return 'Please Enter valid Email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter your Email",
                          hintStyle: const TextStyle(color: Colors.black45),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    setState(() {
                      email = emailcontroller.text;
                    });
                  }
                  resetpassword();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      "Send Email",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                child: const Text(
                  'Login Again??',
                  style: TextStyle(color: Colors.black45),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                          (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
