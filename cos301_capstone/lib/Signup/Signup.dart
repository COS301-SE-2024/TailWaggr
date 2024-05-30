// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cos301_capstone/Signup/Desktop_View.dart';
import 'package:cos301_capstone/Signup/Mobile_View.dart';
import 'package:flutter/material.dart';

SignupObserver signupClassObserver = SignupObserver();
SignupVariables signupVariables = SignupVariables();
SignupMethods signupMethods = SignupMethods();

class SignupVariables {
  // Login details
  late TextEditingController signUpEmailController;
  late TextEditingController signUpPasswordController;
  late TextEditingController signUpConfirmPasswordController;

  // Personal details
  late TextEditingController signUpFirstNameController;
  late TextEditingController signUpLastNameController;
  late TextEditingController signUpBioController;

  // Additional info
  late TextEditingController signUpPhoneNumberController;
  late TextEditingController signUpAddressController;

  static int _StateIndex = 0;
  static int get StateIndex => _StateIndex;
  static void setStateIndex(int StateIndexIn) {
    _StateIndex = StateIndexIn;
  }
}

class SignupMethods {
  static bool checkEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  static bool checkPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  static bool checkConfirmPassword(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool checkPersonalDetails() {
    if (signupVariables.signUpFirstNameController.text.isEmpty) {
      return false;
    } else if (signupVariables.signUpLastNameController.text.isEmpty) {
      return false;
    }
    return true;
  }
}

class SignupObserver with ChangeNotifier {
  int get StateIndex => SignupVariables.StateIndex;
  void setIndex(int index) {
    SignupVariables.setStateIndex(index);
    notifyListeners();
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  
  @override
  void initState() {
    // Login details
    signupVariables.signUpEmailController = TextEditingController();
    signupVariables.signUpPasswordController = TextEditingController();
    signupVariables.signUpConfirmPasswordController = TextEditingController();

    // Personal details
    signupVariables.signUpFirstNameController = TextEditingController();
    signupVariables.signUpLastNameController = TextEditingController();
    signupVariables.signUpBioController = TextEditingController();

    // Additional info
    signupVariables.signUpPhoneNumberController = TextEditingController();
    signupVariables.signUpAddressController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return const Scaffold(
            body: Desktop_Signup(),
          );
        } else {
          return const Scaffold(
            body: Mobile_Signup(),
          );
        }
      },
    );
  }
}
