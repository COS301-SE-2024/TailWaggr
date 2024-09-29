import 'package:flutter/material.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:cos301_capstone/services/forum/forum.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';

class DesktopForums extends StatefulWidget {
  const DesktopForums({super.key});

  @override
  State<DesktopForums> createState() => _DesktopForumsState();
}

final ForumServices _forumServices = ForumServices();
final AuthService _authService = AuthService();
final ProfileService _profileServices = ProfileService();

List<Map<String, dynamic>>? forums;
List<Map<String, dynamic>>? posts;
List<Map<String, dynamic>>? searchedForums;
String searchTerm = "";
String? selectedForumId;
String? newMessageContent;
String? newReplyContent;
String? selectedPostId;
String? forumName;
String? forumDescription;
Map<String, Map<String, dynamic>> userProfiles = {};

class _DesktopForumsState extends State<DesktopForums> {
  TextEditingController forumSearchController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController forumNameController = TextEditingController();
  TextEditingController forumDescriptionController = TextEditingController();
  bool isLoadingPosts = false;

  @override
  void initState() {
    super.initState();
    _fetchForums();
  }

  @override
  void dispose() {
    forumSearchController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchForums() async {
    try {
      List<Map<String, dynamic>>? fetchedForums = await _forumServices.getForums();
      if (!mounted) return;
      setState(() {
        forums = fetchedForums ?? [];
        searchedForums = forums;
        if (forums!.isNotEmpty) {
          selectedForumId = forums?.first['forumId'] ?? '';
          forumName = forums?.first['Name'] ?? 'Unknown';
          forumDescription = forums?.first['Description'] ?? 'No description available';
          _fetchPosts(selectedForumId!);
        }
      });
    } catch (e) {
      print('Error fetching forums: $e');
    }
  }

  void _selectForum(String forumId) {
    setState(() {
      selectedForumId = forumId;
      posts = null;
      var selectedForum = forums?.firstWhere((forum) => forum['forumId'] == forumId, orElse: () => {});
      forumName = selectedForum?['Name'] ?? 'Unknown';
      forumDescription = selectedForum?['Description'] ?? 'No description available';
      isLoadingPosts = true;
    });
    _fetchPosts(forumId);
  }

  Future<void> _fetchPosts(String forumId) async {
    try {
      List<Map<String, dynamic>>? fetchedPosts = await _forumServices.getMessages(forumId);
      if (!mounted) return;
      setState(() {
        posts = fetchedPosts;
        isLoadingPosts = false;
      });
      _fetchUserProfiles();
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        isLoadingPosts = false;
      });
    }
  }

  Future<void> _fetchUserProfiles() async {
    if (posts == null || posts!.isEmpty) return;

    try {
      Set<String> userIds = posts!.map((post) => post['message']['UserId'] as String).toSet();

      for (String userId in userIds) {
        if (!userProfiles.containsKey(userId)) {
          Map<String, dynamic>? profile = await _profileServices.getUserDetails(userId);
          if (profile != null) {
            userProfiles[userId] = profile;
          }
        }
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Error fetching user profiles: $e');
    }
  }

  Future<void> _addMessage() async {
    if (newMessageContent != null && newMessageContent!.isNotEmpty) {
      try {
        String? userId = await _authService.getCurrentUserId();
        await _forumServices.createMessage(selectedForumId!, userId!, newMessageContent!);
        _fetchPosts(selectedForumId!);
        if (!mounted) return;
        setState(() {
          newMessageContent = '';
          messageController.clear();
        });
      } catch (e) {
        print('Error adding message: $e');
      }
    }
  }

  Future<void> _likeMessage(String postId) async {
    try {
      String? userId = await _authService.getCurrentUserId();
      await _forumServices.toggleLikeOnMessage(selectedForumId!, postId, userId!);
      _fetchPosts(selectedForumId!);
    } catch (e) {
      print('Error liking message: $e');
    }
  }

  Future<void> _replyToMessage(String postId) async {
    if (newReplyContent != null && newReplyContent!.isNotEmpty) {
      try {
        String? userId = await _authService.getCurrentUserId();
        await _forumServices.replyToMessage(selectedForumId!, postId, userId!, newReplyContent!);
        _fetchPosts(selectedForumId!);
        setState(() {
          newReplyContent = '';
        });
      } catch (e) {
        print('Error replying to message: $e');
      }
    }
  }

  Future<void> showDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: themeSettings.backgroundColor,
            title: Text("Reply to message"),
            content: TextField(
              onChanged: (value) {
                if (!mounted) return;
                setState(() {
                  newReplyContent = value;
                });
              },
              decoration: InputDecoration(hintText: "Type your reply here", hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.5))),
              style: TextStyle(color: themeSettings.textColor),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await _replyToMessage(selectedPostId!);
                  Navigator.of(context).pop();
                },
                child: Text("Reply"),
              ),
            ],
          );
        });
  }

  void _viewMessage(BuildContext context, Map<String, dynamic> post) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MessageView(
        post: post,
        forumId: selectedForumId!,
        userProfiles: userProfiles,
        forumServices: _forumServices,
        authService: _authService,
        onReplyAdded: _onReplyAdded, // Pass the callback here
      ),
    ));
  }

  // This method will be passed as a callback to MessageView
  void _onReplyAdded() {
    if (selectedForumId != null) {
      print('Reply added');
      _fetchPosts(selectedForumId!);
    }
  }

  void _createForum() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeSettings.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Optional: to round the corners
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, // Set width to 40% of the screen width
            height: MediaQuery.of(context).size.height * 0.4, // Set height to 40% of the screen height
            child: Padding(
              padding: const EdgeInsets.all(20), // Add padding inside the dialog
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create a Forum',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeSettings.primaryColor),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: forumNameController,
                    decoration: InputDecoration(labelText: 'Forum Name', labelStyle: TextStyle(color: themeSettings.textColor)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: forumDescriptionController,
                    decoration: InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: themeSettings.textColor)),
                    maxLines: 2,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: themeSettings.primaryColor),
                          )),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          String name = forumNameController.text;
                          String? userId = await _authService.getCurrentUserId();
                          String description = forumDescriptionController.text;

                          if (name.isNotEmpty && description.isNotEmpty) {
                            await _forumServices.createForum(name, userId!, description);
                            _fetchForums();
                            forumDescriptionController.clear();
                            forumNameController.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: themeSettings.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteForum(String forumId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeSettings.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Optional: to round the corners
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, // Set width to 40% of the screen width
            height: MediaQuery.of(context).size.height * 0.3, // Adjust width
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delete Forum',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeSettings.primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Are you sure you want to delete this forum?',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeSettings.textColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: themeSettings.primaryColor),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await _forumServices.deleteForum(forumId);
                          _fetchForums();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: themeSettings.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return formatFullDate(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}s${difference.inSeconds > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String formatFullDate(DateTime dateTime) {
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
  }

  String _getMonthName(int month) {
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return monthNames[month - 1];
  }

  void _togglemuteMessage(String postId,String forumId, String userId) {
    // Implement mute message functionality
    _forumServices.togglemuteMessage(postId,forumId, userId);
  }
  void _togglemuteForum(String forumId, String userId) {
    // Implement mute forum functionality
    _forumServices.togglemuteForum(forumId, userId);
  }
  void _deleteMessage(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeSettings.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Optional: to round the corners
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, // Set width to 40% of the screen width
            height: MediaQuery.of(context).size.height * 0.3, // Adjust width
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delete Post',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeSettings.primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Are you sure you want to delete this post?',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeSettings.textColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _fetchPosts(selectedForumId!);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: themeSettings.primaryColor),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await _forumServices.deleteMessage(selectedForumId!, postId);
                          _fetchPosts(selectedForumId!);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: themeSettings.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeSettings.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DesktopNavbar(),
          Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.38,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row containing the "Forums" title and the button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Forums",
                      style: TextStyle(
                        fontSize: subtitleTextSize,
                        color: themeSettings.primaryColor,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _createForum,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(60, 60), // Size of the circular button
                        backgroundColor: themeSettings.primaryColor, // Button color
                        shape: CircleBorder(), // Circular shape
                      ),
                      child: Icon(
                        Icons.add, // Use an appropriate icon
                        size: 30, // Adjust icon size
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15), // Space between the row and the search box

                // Search box
                SizedBox(
                  height: 35,
                  child: TextField(
                    controller: forumSearchController,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() {
                        searchTerm = value;
                        searchedForums = forums!.where((forum) => forum['Name'].toString().toLowerCase().contains(searchTerm.toLowerCase())).toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search for a forum",
                      hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search),
                    ),
                    style: TextStyle(color: themeSettings.textColor),
                  ),
                ),

                // Forum list
                Expanded(
                  child: ListView.builder(
                    itemCount: searchTerm.isNotEmpty ? searchedForums!.length : forums!.length,
                    itemBuilder: (context, index) {
                      final forum = searchTerm.isNotEmpty ? searchedForums![index] : forums![index];
                      final userId = forum['UserId'] as String;
                      final userProf = userProfiles[userId];
                      final creatorUsername = userProf?['name'] ?? 'Unknown';

                      return GestureDetector(
                        onTap: () {
                          _selectForum(forum['forumId']);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: themeSettings.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: themeSettings.primaryColor,
                            //   width: 2.0,
                            // ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.forum, // Forum icon
                                size: 40,
                                color: themeSettings.primaryColor,
                              ),
                              SizedBox(width: 15),
                              // Forum details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      forum['Name'],
                                      style: TextStyle(
                                        fontSize: bodyTextSize,
                                        fontWeight: FontWeight.bold,
                                        color: themeSettings.textColor,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Creator: $creatorUsername',
                                      style: TextStyle(
                                        fontSize: bodyTextSize - 2,
                                        color: themeSettings.textColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Last updated time
                              Text(
                                formatDateTime(forum['lastUpdated']),
                                style: TextStyle(
                                  color: themeSettings.textColor.withOpacity(0.7),
                                ),
                              ), //last updated
                              // Delete button for the creator
                              if (userId == profileDetails.userID)
                                PopupMenuButton(
                                  icon: Icon(Icons.more_vert, color: themeSettings.primaryColor),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _deleteForum(forum['forumId']);
                                    }
                                    else if(value == 'mute'){
                                      _togglemuteForum(forum['forumId'], userId);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete Forum'),
                                    ),
                                    PopupMenuItem(
                                      value: 'mute',
                                      child: Text('Mute/Unmute Notifications'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.0015,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeSettings.primaryColor,
            ),
          ),
          if (selectedForumId != null)
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forumName!,
                      style: TextStyle(fontSize: subtitleTextSize, color: themeSettings.primaryColor),
                    ),
                    Text(
                      forumDescription!,
                      //"Hi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the wayHi guys, welcome to my minecraft tutorial. In today's tutorial I'm going to show you how to build a redstone flying machine. I really like plains by the way",
                      style: TextStyle(color: themeSettings.textColor),
                    ),
                    SizedBox(height: 20),
                    isLoadingPosts
                        ? Center(child: CircularProgressIndicator())
                        : posts != null && posts!.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: posts!.length,
                                  itemBuilder: (context, index) {
                                    final post = posts![index];
                                    final postId = post['messageId'];
                                    var numLikes = post['likesCount'].toString();
                                    final numReplies = post['repliesCount'].toString();
                                    final userId = post['message']['UserId'] as String;
                                    final userProfile = userProfiles[userId];
                                    final userProfilePic = userProfile?['profilePictureUrl'] ?? profileDetails.profilePicture; // Add default URL for profile picture
                                    final userName = userProfile?['name'] ?? 'Unknown User';
                                    final postTime = formatDateTime(post['message']['CreatedAt'].toDate());

                                    return GestureDetector(
                                      onTap: () {
                                        _viewMessage(context, post);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: themeSettings.cardColor,
                                          borderRadius: BorderRadius.circular(10),
                                          // border: Border.all(
                                          //   color: themeSettings.primaryColor,
                                          //   width: 2.0,
                                          // ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // User profile picture, name, and time row
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(userProfilePic),
                                                  radius: 20,
                                                ),
                                                SizedBox(width: 10),
                                                // Name and time with dot separator
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        userName,
                                                        style: TextStyle(
                                                          fontSize: bodyTextSize,
                                                          fontWeight: FontWeight.bold,
                                                          color: themeSettings.textColor,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '•',
                                                        style: TextStyle(
                                                          fontSize: bodyTextSize,
                                                          color: themeSettings.textColor.withOpacity(0.7),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        postTime,
                                                        style: TextStyle(
                                                          fontSize: bodyTextSize - 2,
                                                          color: themeSettings.textColor.withOpacity(0.7),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      // Delete button for the creator
                                                      if (userId == profileDetails.userID)
                                                        PopupMenuButton(
                                                          icon: Icon(Icons.more_vert, color: themeSettings.primaryColor),
                                                          onSelected: (value) {
                                                            if (value == 'delete') {
                                                              _deleteMessage(postId);
                                                            } else if (value == 'mute') {
                                                              _togglemuteMessage(postId,selectedForumId!, userId);
                                                            }
                                                          },
                                                          itemBuilder: (context) => [
                                                            PopupMenuItem(
                                                              value: 'delete',
                                                              child: Text('Delete Post'),
                                                            ),
                                                            // option to mute notifications from this message
                                                            PopupMenuItem(
                                                              value: 'mute',
                                                              child: Text('Mute/Unmute Notifications'),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            // Post content
                                            Text(
                                              post['message']?['Content'] ?? 'No Content',
                                              style: TextStyle(
                                                fontSize: subBodyTextSize,
                                                color: themeSettings.textColor,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            // Like and Comment buttons row
                                            Row(
                                              children: [
                                                Tooltip(
                                                  message: "Like",
                                                  child: IconButton(
                                                    onPressed: () {
                                                      print("Like button pressed");
                                                      _likeMessage(postId);
                                                      ForumServices().getLikesCount(selectedForumId!, postId).then((value) {
                                                        setState(() {
                                                          numLikes = value.toString();
                                                        });
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.pets_outlined,
                                                      color: Colors.red.withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  numLikes,
                                                  style: TextStyle(
                                                    color: themeSettings.textColor.withOpacity(0.7),
                                                  ),
                                                ),
                                                Spacer(),
                                                Tooltip(
                                                  message: "Comment",
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedPostId = postId;
                                                      });
                                                      showDialogBox(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.comment,
                                                      color: Colors.blue.withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  numReplies,
                                                  style: TextStyle(
                                                    color: themeSettings.textColor.withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  'No posts available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                    SizedBox(height: 10),
                    TextField(
                      controller: messageController,
                      onSubmitted: (value) async {
                        if (!mounted) return;
                        setState(() {
                          newMessageContent = value;
                        });
                        await _addMessage();
                        messageController.clear();
                        setState(() {
                          newMessageContent = '';
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.5)),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            if (!mounted) return;
                            setState(() {
                              newMessageContent = messageController.text;
                            });
                            await _addMessage();
                            messageController.clear();
                            setState(() {
                              newMessageContent = '';
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: themeSettings.textColor),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MessageView extends StatefulWidget {
  final Map<String, dynamic> post;
  final String forumId;
  final Map<String, Map<String, dynamic>> userProfiles;
  final ForumServices forumServices;
  final AuthService authService;
  final VoidCallback onReplyAdded;

  MessageView({
    required this.post,
    required this.forumId,
    required this.userProfiles,
    required this.forumServices,
    required this.authService,
    required this.onReplyAdded,
  });

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final TextEditingController _replyController = TextEditingController();

  Future<void> _replyToMessage(String postId) async {
    String newReplyContent = _replyController.text;
    if (newReplyContent.isNotEmpty) {
      try {
        String? userId = await widget.authService.getCurrentUserId();
        await widget.forumServices.replyToMessage(
          widget.forumId,
          postId,
          userId!,
          newReplyContent,
        );
        _fetchReplies(widget.forumId, postId); // Refresh posts
        setState(() {
          _replyController.clear();
        });
        widget.onReplyAdded(); // Notify callback
      } catch (e) {
        print('Error replying to message: $e');
      }
    }
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return formatFullDate(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}s${difference.inSeconds > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String formatFullDate(DateTime dateTime) {
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
  }

  String _getMonthName(int month) {
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final postId = widget.post['messageId'];
    final userId = widget.post['message']['UserId'] as String;
    final userProfile = widget.userProfiles[userId];
    final replies = widget.post['replies'] ?? [];
    final postTime = formatDateTime(widget.post['message']['CreatedAt'].toDate());
    void _deleteReply(String postId,String replyId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeSettings.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Optional: to round the corners
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, // Set width to 40% of the screen width
            height: MediaQuery.of(context).size.height * 0.3, // Adjust width
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delete Reply',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeSettings.primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Are you sure you want to delete this reply?',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeSettings.textColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _fetchReplies(selectedForumId!, postId);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: themeSettings.primaryColor),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await _forumServices.deleteReply(selectedForumId!, postId,replyId);
                          _fetchReplies(selectedForumId!,postId);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: themeSettings.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
    return Scaffold(
      appBar: AppBar(
        title: Text('View Message'),
        backgroundColor: themeSettings.primaryColor,
      ),
      backgroundColor: themeSettings.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfile?['profilePictureUrl'] ?? 'default_profile_picture.png'),
                  radius: 25,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile?['userName'] ?? 'Unknown User',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeSettings.textColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: themeSettings.textColor.withOpacity(0.7)),
                          SizedBox(width: 5),
                          Text(
                            postTime,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeSettings.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              widget.post['message']?['Content'] ?? 'No Content',
              style: TextStyle(
                fontSize: 16,
                color: themeSettings.textColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Replies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeSettings.primaryColor,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: replies.length,
                itemBuilder: (context, index) {
                  final reply = replies[index];
                  final replyUserId = reply['UserId'] as String;
                  final replyUserProfile = widget.userProfiles[replyUserId];
                  final replyTime = formatDateTime(reply['CreatedAt'].toDate());
                  final replyId = reply['replyId'];
                  String currentUserId = profileDetails.userID;
                  //print(currentUserId);
                  return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeSettings.cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween instead of Spacer
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  replyUserProfile?['profilePictureUrl'] ?? 'default_profile_picture.png',
                                ),
                                radius: 20,
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    replyUserProfile?['userName'] ?? 'Unknown User',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeSettings.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 14, color: themeSettings.textColor.withOpacity(0.7)),
                                      SizedBox(width: 5),
                                      Text(
                                        replyTime,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: themeSettings.textColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (replyUserId == currentUserId)
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: themeSettings.primaryColor),
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _deleteReply(postId, replyId);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete Reply'),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        reply['Content'] ?? 'No Content',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeSettings.textColor.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                );
                },
              ),
            ),
            TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: 'Type your reply here...',
                hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.5)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: themeSettings.primaryColor),
                  onPressed: () async {
                    await _replyToMessage(postId);
                  },
                ),
                filled: true,
                fillColor: themeSettings.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: themeSettings.textColor),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchReplies(String forumId, String postId) {
    widget.forumServices.getReplies(forumId, postId).then((replies) {
      setState(() {
        widget.post['replies'] = replies;
      });
    });
  }
}
