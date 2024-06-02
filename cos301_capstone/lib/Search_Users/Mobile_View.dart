// ignore_for_file: prefer_const_constructors

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchUsersMobile extends StatefulWidget {
  const SearchUsersMobile({super.key});

  @override
  State<SearchUsersMobile> createState() => _SearchUsersMobileState();
}

class _SearchUsersMobileState extends State<SearchUsersMobile> {
  Color containerColor = Colors.transparent;
  Color searchColor = Colors.transparent;
  List<String> users = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => User_Profile()),
            );
          });
        }
        
        return Scaffold(
          drawer: NavbarDrawer(),
          appBar: AppBar(
            backgroundColor: themeSettings.Primary_Colour,
            title: Text(
              "TailWaggr",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Container(
            // width: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.Card_Colour,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: themeSettings.Text_Colour.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search for a user or pet",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      users = NavbarFunctions.searchUsers(searchController.text);
                      if (users.isEmpty) {
                        users = ["No users found"];
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeSettings.Primary_Colour,
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Search", style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 20),
                for (String user in users)
                  if (user != "No users found")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          // backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                        ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user),
                            Text(
                              "$user's bio",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                if (users.contains("No users found"))
                  Text(
                    "No users found",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
