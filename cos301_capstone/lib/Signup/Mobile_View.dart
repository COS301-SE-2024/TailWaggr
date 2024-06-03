// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, camel_case_types, prefer_final_fields

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Login/Login.dart';
import 'package:cos301_capstone/Signup/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mobile_Signup extends StatefulWidget {
  const Mobile_Signup({super.key});

  @override
  State<Mobile_Signup> createState() => _Mobile_SignupState();
}

class _Mobile_SignupState extends State<Mobile_Signup> {

  bool Confirm_Password_Visible = false;
  bool Password_Visible = false;
  bool ErrorTextVisible = false;
  String errorText = '';
  String SignupButtonText = "Create Account";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.all(30),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: Title_Text_Size,
                    fontWeight: FontWeight.bold,
                    color: themeSettings.Primary_Colour,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: signupVariables.signUpFirstNameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    labelStyle: TextStyle(
                      color: themeSettings.Primary_Colour,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: signupVariables.signUpFirstNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    labelStyle: TextStyle(
                      color: themeSettings.Primary_Colour,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: signupVariables.signUpEmailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: themeSettings.Primary_Colour,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: signupVariables.signUpPasswordController,
                  obscureText: !Password_Visible,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: themeSettings.Primary_Colour,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Password_Visible ? Icons.visibility : Icons.visibility_off,
                        color: themeSettings.Primary_Colour,
                      ),
                      onPressed: () {
                        setState(() {
                          Password_Visible = !Password_Visible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: signupVariables.signUpConfirmPasswordController,
                  obscureText: !Confirm_Password_Visible,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(
                      color: themeSettings.Primary_Colour,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeSettings.Primary_Colour,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Confirm_Password_Visible ? Icons.visibility : Icons.visibility_off,
                        color: themeSettings.Primary_Colour,
                      ),
                      onPressed: () {
                        setState(() {
                          Confirm_Password_Visible = !Confirm_Password_Visible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password must contain the following:",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "A lowercase letter • A capital letter • A number • A special character • At least 8 characters",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 600,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (signupVariables.signUpFirstNameController.text.isEmpty || signupVariables.signUpLastNameController.text.isEmpty) {
                        setState(() {
                          errorText = "Please make sure your first and last name are filled in";
                          ErrorTextVisible = true;
                        });
                      } else if (signupVariables.signUpEmailController.text.isEmpty || !SignupMethods.checkEmail(signupVariables.signUpEmailController.text)) {
                        setState(() {
                          errorText = "Please enter a valid email address";
                          ErrorTextVisible = true;
                        });
                      } else if (signupVariables.signUpPasswordController.text.isEmpty || !SignupMethods.checkPassword(signupVariables.signUpPasswordController.text)) {
                        setState(() {
                          errorText = "Please enter a valid Password";
                          ErrorTextVisible = true;
                        });
                      } else if (signupVariables.signUpConfirmPasswordController.text.isEmpty ||
                          !SignupMethods.checkConfirmPassword(signupVariables.signUpPasswordController.text, signupVariables.signUpConfirmPasswordController.text)) {
                        setState(() {
                          errorText = "Please make sure your passwords match";
                          ErrorTextVisible = true;
                        });
                      } else {
                        setState(() {
                          SignupButtonText = "Creating Account...";
                        });
                        try {
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: signupVariables.signUpEmailController.text,
                            password: signupVariables.signUpPasswordController.text,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            setState(() {
                              errorText = "The password provided is too weak";
                              ErrorTextVisible = true;
                              SignupButtonText = "Create Account";
                            });
                          } else if (e.code == 'email-already-in-use') {
                            setState(() {
                              errorText = "An account already exists for that email";
                              ErrorTextVisible = true;
                              SignupButtonText = "Create Account";
                            });
                          }
                        } catch (e) {
                          setState(() {
                            errorText = "An error occurred";
                            ErrorTextVisible = true;
                            SignupButtonText = "Create Account";
                          });
                        }
                        return;
                      }

                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          errorText = "";
                          ErrorTextVisible = false;
                        });
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(themeSettings.Primary_Colour),
                    ),
                    child: Text(
                      SignupButtonText,
                      style: TextStyle(
                        fontSize: Body_Text_Size,
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
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: themeSettings.Primary_Colour,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
