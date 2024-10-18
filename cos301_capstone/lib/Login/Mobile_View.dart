// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, camel_case_types

import 'package:cos301_capstone/Forgot_Password/Forgot_Password.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:cos301_capstone/User_Auth/Auth_Gate.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mobile_View extends StatefulWidget {
  const Mobile_View({super.key});

  @override
  State<Mobile_View> createState() => _Mobile_ViewState();
}

class _Mobile_ViewState extends State<Mobile_View> {
  final AuthService _authService = AuthService();
  bool Password_Visible = false;
  bool ErrorTextVisible = false;
  String errorText = '';

  // Sign In controllers
  late TextEditingController signInEmailController;
  late TextEditingController signInPasswordController;

  @override
  void initState() {
    super.initState();
    signInEmailController = TextEditingController();
    signInPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSettings.backgroundColor,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), // Adjust the shadow color and opacity as needed
                spreadRadius: 1, // Adjust the spread radius as needed
                blurRadius: 10, // Adjust the blur radius as needed
              ),
            ],
          ),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  "Welcome!",
                  style: TextStyle(
                    fontSize: titleTextSize,
                    fontWeight: FontWeight.bold,
                    color: themeSettings.primaryColor,
                  ),
                ),
                //
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    controller: signInEmailController,
                    autofillHints: [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: themeSettings.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    controller: signInPasswordController,
                    autofillHints: [AutofillHints.password],
                    obscureText: !Password_Visible,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: themeSettings.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Password_Visible ? Icons.visibility : Icons.visibility_off,
                          color: themeSettings.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            Password_Visible = !Password_Visible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 30),
                      child: GestureDetector(
                        onTap: () {
                          // Call signInWithGoogle() here
                          _authService.signInWithGoogle();
                        },
                        child: Text(
                          "Sign in with Google",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
            
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: signInEmailController.text,
                          password: signInPasswordController.text,
                        );
            
                        // If the user is signed in, go to the home page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AuthGate()),
                        );
                      } on Exception catch (e) {
                        print(e);
                        setState(() {
                          ErrorTextVisible = true;
                          if (e.toString().contains('[firebase_auth/channel-error] Unable to establish connection on channel.')) {
                            errorText = 'Please make sure your Email and Password fields are filled in';
                          } else if (e.toString().contains('[firebase_auth/invalid-email] The email address is badly formatted.')) {
                            errorText = 'Please make sure Email is correct';
                          } else if (e.toString().contains('[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.')) {
                            errorText = 'Your Email or Password is incorrect';
                          } else if (e.toString().contains('[firebase_auth/network-request-failed]')) {
                            errorText = 'Please make sure you are connected to the internet';
                          } else {
                            errorText = e.toString();
                          }
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: bodyTextSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Error text
                Visibility(
                  visible: ErrorTextVisible,
                  child: Text(
                    errorText,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
      
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: signInEmailController.text,
                        password: signInPasswordController.text,
                      );
                    } on Exception catch (e) {
                      print(e);
                      setState(() {
                        ErrorTextVisible = true;
                        if (e.toString().contains('[firebase_auth/channel-error] Unable to establish connection on channel.')) {
                          errorText = 'Please make sure your Email and Password fields are filled in';
                        } else if (e.toString().contains('[firebase_auth/invalid-email] The email address is badly formatted.')) {
                          errorText = 'Please make sure Email is correct';
                        } else if (e.toString().contains('[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.')) {
                          errorText = 'Your Email or Password is incorrect';
                        } else if (e.toString().contains('[firebase_auth/network-request-failed]')) {
                          errorText = 'Please make sure you are connected to the internet';
                        } else {
                          errorText = e.toString();
                        }
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: bodyTextSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Error text
              Visibility(
                visible: ErrorTextVisible,
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: themeSettings.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Text("Or sign in with"),
                    Container(
                      width: 200,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(themeSettings.cardColor),
                      side: WidgetStateProperty.all(
                        BorderSide(color: themeSettings.primaryColor),
                      ),
                    ),
                    onPressed: () {
                      AuthService().signInWithGoogle();
                    },
                    child: Row(
                    mainAxisSize: MainAxisSize.min, // Keeps the button size compact
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icons8-google-48.png',
                        height: 30, // Adjust the height to fit the text
                      ),
                      const SizedBox(width: 12), // Add some spacing between image and text
                      Text(
                        "Sign in with Google",
                        style: TextStyle(color: themeSettings.primaryColor, fontSize: bodyTextSize),
                      ),
                    ],
                  ),
                ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
