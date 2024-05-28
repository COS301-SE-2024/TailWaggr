// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, camel_case_types

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Tablet_View extends StatefulWidget {
  const Tablet_View({super.key});

  @override
  State<Tablet_View> createState() => _Tablet_ViewState();
}

class _Tablet_ViewState extends State<Tablet_View> {
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
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          // margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        Text(
                          "TailWaggr",
                          style: TextStyle(
                            fontSize: Title_Text_Size,
                            fontWeight: FontWeight.bold,
                            color: Primary_Colour,
                          ),
                        ),
                        Text(
                          "Share Your Pet's World!",
                          style: TextStyle(
                            fontSize: Body_Text_Size,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/Dog_Walk_Image.png",
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 50),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        Text(
                          "TailWaggr",
                          style: TextStyle(
                            fontSize: Title_Text_Size,
                            fontWeight: FontWeight.bold,
                            color: Primary_Colour,
                          ),
                        ),
                        Text("", style: TextStyle(fontSize: Body_Text_Size, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(
                    // height: MediaQuery.of(context).size.width * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: TextField(
                            controller: signInEmailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Primary_Colour,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Primary_Colour,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Primary_Colour,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: TextField(
                            controller: signInPasswordController,
                            obscureText: !Password_Visible,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Primary_Colour,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Primary_Colour,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Primary_Colour,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Password_Visible ? Icons.visibility : Icons.visibility_off,
                                  color: Primary_Colour,
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Add your logic here for when the "Forgot Password?" text is clicked
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                print('Signing in...');
                                print(signInEmailController.text);
                                print(signInPasswordController.text);
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: "scottbebington@gmail.com",
                                  password: "Scott25121!",
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
                              backgroundColor: MaterialStateProperty.all(Primary_Colour),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: Body_Text_Size,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                print("Navigating to Sign Up");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Primary_Colour,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
