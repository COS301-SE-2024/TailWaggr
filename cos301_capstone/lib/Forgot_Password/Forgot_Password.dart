// ignore_for_file: file_names, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the current width of the screen.
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeSettings.backgroundColor,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(
            // Set max width as the minimum of 500 or 90% of screen width
            maxWidth: min(500, screenWidth * 0.9),
          ),
          decoration: BoxDecoration(
            color: themeSettings.cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    "Forgot Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: themeSettings.textColor,
                    ),
                  ),
                  Container(),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Enter your email address and we will send you a link to reset your password",
                style: TextStyle(
                  fontSize: 15,
                  color: themeSettings.textColor,
                ),
                textAlign: TextAlign.center, // This will center the text
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: themeSettings.textColor.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      // Show a snackbar to inform the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Please enter an email address",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      return;
                    }

                    // validate email regex
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text)) {
                      // Show a snackbar to inform the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Please enter a valid email address",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      return;
                    }

                    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                    // Show a snackbar to inform the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Password reset email sent to ${emailController.text}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Send Reset Email",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
