// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';
import 'package:cos301_capstone/services/search/search_service.dart';
import 'package:flutter/material.dart';

class MobileSearch extends StatefulWidget {
  const MobileSearch({super.key});

  @override
  State<MobileSearch> createState() => _MobileSearchState();
}

class _MobileSearchState extends State<MobileSearch> {
  late TextEditingController searchController;
  List<User> users = [];
  SearchService searchService = SearchService();
  String searchText = 'Search';
  LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void getUsersByName() async {
    setState(() {
      searchText = 'Searching...';
    });

    try {
      users = await searchService.searchUsers(searchController.text);
    } on Exception catch (_) {}

    setState(() {
      searchText = 'Search';
    });
  }

  void navigateToProfile(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => User_Profile(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeSettings.backgroundColor,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: themeSettings.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  height: 40,
                  width: MediaQuery.of(context).size.width - 210,
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: themeSettings.textColor),
                    decoration: InputDecoration(
                      hintText: 'Search people...',
                      hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: themeSettings.primaryColor),
                      ),
                    ),
                    onSubmitted: (value) async {
                      getUsersByName();
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: themeSettings.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onPressed: () async {
                      // await getPosts(searchController.text, false);
                      getUsersByName();
                    },
                    child: Text(
                      searchText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - 156,
              // color: Colors.black,
              margin: EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (users.isEmpty) ...{
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'No users found',
                          style: TextStyle(
                            color: themeSettings.textColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    } else ...{
                      for (int i = 0; i < users.length; i++) ...{
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => navigateToProfile(users[i].id),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: users[i].profileUrl == "" ? null : NetworkImage(users[i].profileUrl),
                                    backgroundColor: themeSettings.primaryColor,
                                    child: Text(
                                      users[i].profileUrl == "" ? users[i].name[0] : "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10), // Add some spacing between avatar and text
                                  Expanded(
                                    // Ensure the text occupies available space without overflow
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            users[i].name,
                                            style: TextStyle(
                                              color: themeSettings.textColor,
                                              fontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1, // Ensures the text is limited to one line
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            users[i].bio,
                                            style: TextStyle(
                                              color: themeSettings.textColor,
                                              fontSize: 15,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1, // Limit the bio to a single line as well
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      },
                    },
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
