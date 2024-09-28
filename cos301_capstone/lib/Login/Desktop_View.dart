// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:cos301_capstone/Forgot_Password/Forgot_Password.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DesktopLogin extends StatefulWidget {
  const DesktopLogin({super.key});

  @override
  State<DesktopLogin> createState() => _DesktopLoginState();
}

class _DesktopLoginState extends State<DesktopLogin> {
  final AuthService _authService = AuthService();
  bool Password_Visible = false;
  bool ErrorTextVisible = false;
  String errorText = '';
  String LoginText = 'Login';

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
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: themeSettings.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Table(
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                },
                children: [
                  TableRow(
                    children: [
                      Column(
                        children: [
                          Text(
                            "TailWaggr",
                            style: TextStyle(
                              fontSize: titleTextSize,
                              fontWeight: FontWeight.bold,
                              color: themeSettings.primaryColor,
                            ),
                          ),
                          Text(
                            "Share Your Pet's World!",
                            style: TextStyle(
                              fontSize: bodyTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 50),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: titleTextSize,
                          fontWeight: FontWeight.bold,
                          color: themeSettings.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/images/Dog_Walk_Image.png",
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                      SizedBox(width: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              controller: signInEmailController,
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
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              onSubmitted: (value) async {
                                try {
                                  setState(() {
                                    LoginText = 'Logging in...';
                                  });

                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: signInEmailController.text,
                                    password: signInPasswordController.text,
                                  );
                                } on Exception catch (e) {
                                  print(e);
                                  setState(() {
                                    LoginText = 'Login';
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
                              controller: signInPasswordController,
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
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
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
                              Spacer(),
                              Container(
                                alignment: Alignment.centerRight,
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
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    LoginText = 'Logging in...';
                                  });

                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: signInEmailController.text,
                                    password: signInPasswordController.text,
                                  );
                                } on Exception catch (e) {
                                  print(e);
                                  setState(() {
                                    LoginText = 'Login';
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
                                LoginText,
                                style: TextStyle(
                                  fontSize: bodyTextSize,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // Error text
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Visibility(
                              visible: ErrorTextVisible,
                              child: Text(
                                errorText,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
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
                        ],
                      ),
                    ],
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
