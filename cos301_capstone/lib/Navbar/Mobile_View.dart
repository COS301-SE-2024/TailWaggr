// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cos301_capstone/Dog_Runner/Game.dart';
import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Forums/Forums.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Help/Help.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/LostAndFound/LostAndFound.dart';
import 'package:cos301_capstone/Navbar/Navbar.dart';
import 'package:cos301_capstone/Notifications/Notifications.dart';
import 'package:cos301_capstone/Search/Search.dart';
import 'package:cos301_capstone/User_Profile/Mobile_View.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:cos301_capstone/services/Notifications/notifications.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MobileNavbar extends StatefulWidget {
  const MobileNavbar({super.key});

  @override
  State<MobileNavbar> createState() => _MobileNavbarState();
}

class _MobileNavbarState extends State<MobileNavbar> {
  Color containerColor = Colors.transparent;
  Color themeColor = Colors.transparent;
  Color searchColor = Colors.transparent;
  List<String> users = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(),
      appBar: AppBar(
        backgroundColor: ThemeSettings.primaryColor,
        title: Text(
          "TailWaggr",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: navbarIndexObserver,
        builder: (BuildContext context, Widget? child) {
          return Container(
            // width: MediaQuery.of(context).size.width - (isSearchVisible ? 550 : 250),
            color: ThemeSettings.backgroundColor,
            padding: EdgeInsets.all(20),
            child: ProfileMobile(userId: profileDetails.userID),
          );
        },
      ),
    );
  }
}

class NavbarDrawer extends StatefulWidget {
  const NavbarDrawer({super.key});

  @override
  State<NavbarDrawer> createState() => _NavbarDrawerState();
}

class _NavbarDrawerState extends State<NavbarDrawer> {
  Color containerColor = Colors.transparent;
  Color themeColor = Colors.transparent;
  Color profileColor = Colors.transparent;
  Color settingsColor = Colors.transparent;
  bool isDarkMode = false;
  bool isExtraMenuOpen = false;
  Color helpColor = Colors.transparent;
  int unreadNotificationsCount = 0;
  final NotificationsServices _notificationsServices = NotificationsServices();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _countUnreadNotifications();
    profileDetails.isEditing.addListener(() {
      setState(() {});
    });
  }

  void _countUnreadNotifications() async {
    try {
      String? userId = await _authService.getCurrentUserId();
      if (userId != null) {
        int count = await _notificationsServices.countNewUnreadNotifs(userId);
        setState(() {
          unreadNotificationsCount = count;
        });
      }
    } catch (e) {
      print("Error counting unread notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: ThemeSettings.primaryColor,
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: profileDetails.usingImage
            ? !profileDetails.usingDefaultImage
                ? imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty
                    ? BoxDecoration(image: DecorationImage(image: MemoryImage(imagePicker.filesNotifier.value![0].bytes!), fit: BoxFit.cover))
                    : BoxDecoration(image: DecorationImage(image: NetworkImage(profileDetails.sidebarImage), fit: BoxFit.cover))
                : BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/pug.jpg"), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)))
            : BoxDecoration(color: themeSettings.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  themeSettings.navbarTextColour,
                  BlendMode.srcIn,
                ),
                child: Image.asset(width: 100, 'assets/images/Logo_transparent.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Navbar_Icon(icon: Icons.home, text: "Home", page: Homepage()),
                Navbar_Icon(
                  icon: Icons.notifications,
                  text: "Notifications",
                  page: Notifications(),
                  badgeContent: unreadNotificationsCount > 0
                      ? Text(
                          '$unreadNotificationsCount',
                          style: TextStyle(color: themeSettings.navbarTextColour),
                        )
                      : null,
                ),
                Navbar_Icon(icon: Icons.map_sharp, text: "Locate", page: Location()),
                Navbar_Icon(icon: Icons.pets, text: "Lost and Found", page: LostAndFound()),
                Navbar_Icon(icon: Icons.search, text: "Friends", page: Search()),
                Navbar_Icon(icon: Icons.forum_outlined, text: "Forums", page: Forums()),
                // Navbar_Icon(icon: Icons.person_outline, text: "Profile", page: User_Profile(userId: profileDetails.userID)),
                // Navbar_Icon(icon: Icons.settings_outlined, text: "Settings", page: EditProfile()),
                Navbar_Icon(icon: Icons.gamepad, text: "Pet Runner", page: Game()),
                Navbar_Icon(icon: Icons.help_outline, text: "Help", page: Help()),
              ],
            ),
            Column(
              children: [
                if (isExtraMenuOpen) ...[
                  ThemeSelect(
                    initialSelection: themeSettings.themeMode,
                  ).animate().moveY(begin: 100, end: 0, duration: Duration(milliseconds: 400), delay: Duration(milliseconds: 300)).fadeIn(),
                  GestureDetector(
                    onTap: () async {
                      // final Uri url = Uri.parse('https://docs.google.com/document/d/1TiRA697HTTGuLCOzq20es4q_fotXlDpTnVuov_7zNP0/edit?usp=sharing ');
                      // if (!await launchUrl(url)) {
                      //   print('Could not launch $url');
                      // }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => User_Profile(userId: profileDetails.userID)));
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          profileColor = Colors.black.withOpacity(0.1);
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          profileColor = Colors.transparent;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: profileColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, color: themeSettings.navbarTextColour),
                            SizedBox(width: 10),
                            Text("Profile", style: TextStyle(color: themeSettings.navbarTextColour, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ).animate().moveY(begin: 100, end: 0, duration: Duration(milliseconds: 300), delay: Duration(milliseconds: 200)).fadeIn(),
                  GestureDetector(
                    onTap: () async {
                      // final Uri url = Uri.parse('https://docs.google.com/document/d/1TiRA697HTTGuLCOzq20es4q_fotXlDpTnVuov_7zNP0/edit?usp=sharing ');
                      // if (!await launchUrl(url)) {
                      //   print('Could not launch $url');
                      // }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          settingsColor = Colors.black.withOpacity(0.1);
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          settingsColor = Colors.transparent;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: settingsColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined, color: themeSettings.navbarTextColour),
                            SizedBox(width: 10),
                            Text("Settings", style: TextStyle(color: themeSettings.navbarTextColour, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ).animate().moveY(begin: 100, end: 0, duration: Duration(milliseconds: 200), delay: Duration(milliseconds: 100)).fadeIn(),
                  GestureDetector(
                    onTap: () {
                      profileDetails = ProfileDetails();
                      themeSettings = ThemeSettingsObserver();
                      themeSettings.toggleTheme("Light");
                      FirebaseAuth.instance.signOut();
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          containerColor = Colors.black.withOpacity(0.1);
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          containerColor = Colors.transparent;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: themeSettings.navbarTextColour),
                            SizedBox(width: 10),
                            Text("Logout", style: TextStyle(color: themeSettings.navbarTextColour, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ).animate().moveY(begin: 50, end: 0, duration: Duration(milliseconds: 100)).fadeIn(),
                  SizedBox(height: 10),
                ],
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExtraMenuOpen = !isExtraMenuOpen;
                      });
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profileDetails.profilePicture),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileDetails.name,
                              style: TextStyle(
                                fontSize: 20,
                                color: themeSettings.navbarTextColour,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
