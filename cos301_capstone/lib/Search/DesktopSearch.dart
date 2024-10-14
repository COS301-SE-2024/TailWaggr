// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/search/search_service.dart';
import 'package:flutter/material.dart';

ProfileService profileService = ProfileService();

class DesktopSearch extends StatefulWidget {
  const DesktopSearch({super.key});

  @override
  State<DesktopSearch> createState() => _DesktopSearchState();
}

class _DesktopSearchState extends State<DesktopSearch> {
  late TextEditingController searchController;
  List<User> users = [];
  SearchService searchService = SearchService();
  String searchText = 'Search';
  LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: '');
    getUsersByName(false);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void getUsersByName(bool loadmore) async {
    setState(() {
      searchText = 'Searching...';
    });

    try {
      List<User> newUsers = await searchService.searchUsers(searchController.text, loadmore);

      if (newUsers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Center(child: Text('No more users found')),
            duration: Duration(seconds: 2),
          ),
        );

        setState(() {
          searchText = 'Search';
        });

        return;
      }

      users.addAll(newUsers);
    } on Exception catch (e) {
      print(e);
    }

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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: themeSettings.backgroundColor,
      child: Row(
        children: [
          DesktopNavbar(),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            width: (MediaQuery.of(context).size.width - 290) * 0.6,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: themeSettings.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        height: 40,
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
                            getUsersByName(false);
                          },
                        ),
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
                          getUsersByName(false);
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
                  height: MediaQuery.of(context).size.height - 140,
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
                                  margin: EdgeInsets.only(bottom: 20),
                                  width: MediaQuery.of(context).size.width - 340,
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
                          // Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 340,
                            height: 40,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: themeSettings.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onPressed: () async {
                                getUsersByName(true);
                              },
                              child: Text(
                                'Load more',
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 290) * 0.4 - 20,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 20, right: 20, bottom: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pending Requests',
                    style: TextStyle(
                      color: themeSettings.primaryColor,
                      fontSize: 20,
                    ),
                  ),
                  for (var entry in profileDetails.friends.entries) ...{
                    if (entry.value == 'Requested') ...{
                      FriendCard(friend: entry),
                    }
                  },
                  SizedBox(height: 20),
                  Text(
                    'Following',
                    style: TextStyle(
                      color: themeSettings.primaryColor,
                      fontSize: 20,
                    ),
                  ),
                  for (var entry in profileDetails.friends.entries) ...{
                    if (entry.value == 'Following') ...{
                      FriendCard(friend: entry),
                    }
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FriendCard extends StatefulWidget {
  const FriendCard({super.key, required this.friend});

  final MapEntry<String, String> friend;

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  User? friend;
  String unfollowText = 'Unfollow';
  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    // Get user details
    Map<String, dynamic>? tempfriend = await profileService.getUserDetails(widget.friend.key);

    if (tempfriend == null) {
      return;
    }

    friend = User(
      id: widget.friend.key,
      name: tempfriend['name'],
      bio: tempfriend['bio'],
      profileUrl: tempfriend['profilePictureUrl'],
      userType: tempfriend['userType'],
      location: GeoPoint(0, 0),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (friend == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => User_Profile(userId: friend!.id),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            width: (MediaQuery.of(context).size.width - 290) * 0.4,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: friend!.profileUrl == "" ? null : NetworkImage(friend!.profileUrl),
                  backgroundColor: themeSettings.primaryColor,
                  child: Text(
                    friend!.profileUrl == "" ? friend!.name[0] : "",
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
                          friend!.name,
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
                          friend!.bio,
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
                Spacer(),
                if (widget.friend.value == "Following") ...{
                  SizedBox(
                    // width: 40,
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: themeSettings.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          unfollowText = 'Unfollowing...';
                        });

                        try {
                          await profileService.unfollowUser(profileDetails.userID, friend!.id);
                          setState(() {
                            profileDetails.friends[friend!.id] = 'Not Following';
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Center(child: Text('Unfollowed user')),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          dispose();
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Center(child: Text('Failed to unfollow user')),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } finally {
                          setState(() {
                            unfollowText = 'Unfollow';
                          });
                        }
                      },
                      child: Text(
                        'Unfollow',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                },
              ],
            ),
          ),
        ),
      );
    }
  }
}
