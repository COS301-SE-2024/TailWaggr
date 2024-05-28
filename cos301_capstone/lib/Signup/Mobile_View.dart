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
  List myClasses = [
    LoginDetails(),
    PersonalDetails(),
    AdditionalInfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: ListenableBuilder(
            listenable: signupClassObserver,
            builder: (BuildContext context, Widget? child) {
              return Container(
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
                child: myClasses[SignupVariables.StateIndex],
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginDetails extends StatefulWidget {
  const LoginDetails({super.key});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  bool Confirm_Password_Visible = false;
  bool Password_Visible = false;
  bool ErrorTextVisible = false;
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Login Details",
          style: TextStyle(
            fontSize: Title_Text_Size,
            fontWeight: FontWeight.bold,
            color: Primary_Colour,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Primary_Colour, // Color of the first circle
              radius: 7.5,
            ),
            SizedBox(width: 100),
            CircleAvatar(
              radius: 7.5,
            ),
            SizedBox(width: 100),
            CircleAvatar(
              radius: 7.5,
            ),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          controller: signupVariables.signUpEmailController,
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
        SizedBox(height: 20),
        TextField(
          controller: signupVariables.signUpPasswordController,
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
        SizedBox(height: 20),
        TextField(
          controller: signupVariables.signUpConfirmPasswordController,
          obscureText: !Confirm_Password_Visible,
          obscuringCharacter: "*",
          decoration: InputDecoration(
            labelText: "Confirm Password",
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
                Confirm_Password_Visible ? Icons.visibility : Icons.visibility_off,
                color: Primary_Colour,
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
              if (signupVariables.signUpEmailController.text.isEmpty || !SignupMethods.checkEmail(signupVariables.signUpEmailController.text)) {
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
                signupClassObserver.setIndex(1);
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
              backgroundColor: MaterialStateProperty.all(Primary_Colour),
            ),
            child: Text(
              "Next",
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
                  color: Primary_Colour,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String errorText = '';
  bool ErrorTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Personal Details",
          style: TextStyle(
            fontSize: Title_Text_Size,
            fontWeight: FontWeight.bold,
            color: Primary_Colour,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Primary_Colour,
              radius: 7.5,
            ),
            SizedBox(width: 100),
            CircleAvatar(
              backgroundColor: Primary_Colour,
              radius: 7.5,
            ),
            SizedBox(width: 100),
            CircleAvatar(
              radius: 7.5,
            ),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          controller: signupVariables.signUpFirstNameController,
          decoration: InputDecoration(
            labelText: "First name",
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
        SizedBox(height: 20),
        TextField(
          controller: signupVariables.signUpLastNameController,
          decoration: InputDecoration(
            labelText: "Last name",
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
        SizedBox(height: 20),
        TextField(
          controller: signupVariables.signUpBioController,
          decoration: InputDecoration(
            labelText: "Bio",
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
        SizedBox(height: 20),
        Row(
          children: [
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  signupClassObserver.setIndex(0);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text(
                  "Back",
                  style: TextStyle(
                    fontSize: Body_Text_Size,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (!SignupMethods.checkPersonalDetails()) {
                    setState(() {
                      errorText = "Please fill in all the fields";
                      ErrorTextVisible = true;
                    });
                  } else {
                    signupClassObserver.setIndex(2);
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
                  backgroundColor: MaterialStateProperty.all(Primary_Colour),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: Body_Text_Size,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
                  color: Primary_Colour,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AdditionalInfo extends StatefulWidget {
  const AdditionalInfo({super.key});

  @override
  State<AdditionalInfo> createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  String errorText = '';
  bool ErrorTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Additional Details",
            style: TextStyle(
              fontSize: Title_Text_Size,
              fontWeight: FontWeight.bold,
              color: Primary_Colour,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Primary_Colour,
                radius: 7.5,
              ),
              SizedBox(width: 100),
              CircleAvatar(
                backgroundColor: Primary_Colour,
                radius: 7.5,
              ),
              SizedBox(width: 100),
              CircleAvatar(
                backgroundColor: Primary_Colour,
                radius: 7.5,
              ),
            ],
          ),
          SizedBox(height: 20),
          Text("Please note that the following are optional and can be filled in later.", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          TextField(
            controller: signupVariables.signUpPhoneNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Phone number",
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
          SizedBox(height: 20),
          TextField(
            controller: signupVariables.signUpAddressController,
            decoration: InputDecoration(
              labelText: "Address",
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
          // CircleAvatar(
          //   radius: 100,
          //   backgroundColor: Colors.grey,
          //   child: Icon(
          //     Icons.add_a_photo,
          //     size: 50,
          //     color: Colors.white,
          //   ),
          // ),
        
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    signupClassObserver.setIndex(1);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: Body_Text_Size,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      print('Signing up');
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: signupVariables.signUpEmailController.text,
                        password: signupVariables.signUpPasswordController.text,
                      );
        
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        if (e.code == 'email-already-in-use') {
                          errorText = 'An account already exists with that email.';
                        } else if (e.code == 'invalid-email') {
                          errorText = 'Please make sure your email address is valid.';
                        } else if (e.code == 'operation-not-allowed') {
                          errorText = 'Email & Password authentication is not enabled.';
                        } else if (e.code == 'weak-password') {
                          errorText = 'Please make sure your password matches the given criteria.';
                        }
                        ErrorTextVisible = true;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Primary_Colour),
                  ),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: Body_Text_Size,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
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
                    color: Primary_Colour,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
