// ignore_for_file: non_constant_identifier_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SignInVariables {
  static late TextEditingController signInEmailController;
  static late TextEditingController signInPasswordController;
}

class Desktop_Signup extends StatefulWidget {
  const Desktop_Signup({super.key});

  @override
  State<Desktop_Signup> createState() => _Desktop_SignupState();
}

class _Desktop_SignupState extends State<Desktop_Signup> {
  bool Password_Visible = false;
  bool Confirm_Password_Visible = false;
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
    return Stack(
      children: [
        // Half circle at the bottom left of the screen
        Positioned(
          bottom: 0,
          left: 0, // Adjusted to the left edge
          child: Container(
            height: MediaQuery.of(context).size.width * 0.15, // Adjust the height as needed
            width: MediaQuery.of(context).size.width * 0.15, // Adjust the width as needed
            decoration: BoxDecoration(
              color: Tertiary_Colour, // Same color as the background with 25% opacity
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(250), // Half of the height
              ),
            ),
          ),
        ),
        // Half circle at the bottom left of the screen
        Positioned(
          bottom: 0,
          left: 0, // Adjusted to the left edge
          child: Container(
            height: MediaQuery.of(context).size.width * 0.12, // Adjust the height as needed
            width: MediaQuery.of(context).size.width * 0.12, // Adjust the width as needed
            decoration: BoxDecoration(
              color: Colors.white, // Same color as the background
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(200), // Half of the height
              ),
            ),
          ),
        ),
        // Half circle at the top right of the screen
        Positioned(
          top: 0,
          right: 0, // Adjusted to the left edge
          child: Container(
            height: MediaQuery.of(context).size.width * 0.1, // Adjust the height as needed
            width: MediaQuery.of(context).size.width * 0.1, // Adjust the width as needed
            decoration: BoxDecoration(
              color: Secondary_Colour,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(250), // Half of the height
              ),
            ),
          ),
        ),

        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
              boxShadow: [
                BoxShadow(
                  color: Primary_Colour.withOpacity(0.5), // Adjust the shadow color and opacity as needed
                  spreadRadius: 1, // Adjust the spread radius as needed
                  blurRadius: 10, // Adjust the blur radius as needed
                ),
              ],
            ),
            child: Row(
              children: [
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      "Create Login Details",
                      style: TextStyle(
                        fontSize: Title_Text_Size,
                        fontWeight: FontWeight.bold,
                        color: Primary_Colour,
                      ),
                    ),
                    //
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: StepProgressIndicator(
                        totalSteps: 100,
                        currentStep: 32,
                        size: 8,
                        padding: 0,
                        roundedEdges: Radius.circular(10),
                        selectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Secondary_Colour, Primary_Colour],
                        ),
                        unselectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.1)],
                        ),
                      ),
                    ),
                    Spacer(),
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
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            print("Navigating to Sign Up");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: Primary_Colour,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
