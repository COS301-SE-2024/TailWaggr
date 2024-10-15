import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/User_Auth/Auth_Gate.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:flutter/material.dart';

class NotVerified extends StatelessWidget {
  const NotVerified({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSettings.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeSettings.backgroundColor,
        onPressed: () {
          AuthService().signOut();
        },
        child: Icon(Icons.arrow_back, color: themeSettings.primaryColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Your account is not verified", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("Please check your email for account verification", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthGate()),
                );
              },
              child: Text("Account Verified Already?", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
