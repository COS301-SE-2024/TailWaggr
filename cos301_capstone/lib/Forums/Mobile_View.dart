// ignore_for_file: prefer_const_constructors
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:cos301_capstone/services/forum/forum.dart';

class MobileForums extends StatefulWidget {
  const MobileForums({super.key});

  @override
  State<MobileForums> createState() => _MobileForumsState();
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

class _MobileForumsState extends State<MobileForums> {
  TextEditingController forumSearchController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController forumNameController = TextEditingController();
  TextEditingController forumDescriptionController = TextEditingController();
  bool isLoadingForums = false;
  bool isLoadingPosts = false;

  @override
  void initState() {
    super.initState();
    _fetchForums();
  }

  @override
  void dispose() {
    forumSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchForums() async {
    setState(() {
    isLoadingForums = true; // Start loading
  });
    try {
      List<Map<String, dynamic>>? fetchedForums = await _forumServices.getForums();
      if (!mounted) return;
      setState(() {
        forums = fetchedForums;
        searchedForums = forums;
        if (forums != null && forums!.isNotEmpty) {
          selectedForumId = forums!.first['forumId'];
          forumName = forums!.first['Name'];
          forumDescription = forums!.first['Description'];
          _fetchPosts(selectedForumId!);
        }
        isLoadingForums = false; // Stop loading
      });
    } catch (e) {
      print('Error fetching forums: $e');
    }
  }

void _selectForum(String forumId) {
  print('Selected forum: $forumId');
  setState(() {
    selectedForumId = forumId;
    posts = null;

    var selectedForum = forums?.firstWhere(
      (forum) => forum['forumId'] == forumId,
      orElse: () => {}, // Changed to an empty map for better null handling
    );

    if (selectedForum == null) {
      print('Selected forum not found');
      return; // Handle case where the forum is not found
    }

    forumName = selectedForum['Name'] as String? ?? 'Unknown';
    forumDescription = selectedForum['Description'] as String? ?? 'No description available';
    isLoadingPosts = true;
    print('Selected forum: $forumName, $forumDescription, $isLoadingPosts');
  });
  
  if (selectedForumId!.isNotEmpty) {
    _fetchPosts(selectedForumId!);
  }
}

  Future<void> _fetchPosts(String forumId) async {
    try {
      List<Map<String, dynamic>>? fetchedPosts = await _forumServices.getMessages(forumId);
      if (!mounted) return;
      setState(() {
        posts = fetchedPosts;
        //isLoadingPosts = false;
      });
      _fetchUserProfiles();
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        //isLoadingPosts = false;
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
  void _openCreateForum() {
    // Logic to open the create forum form or popup
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
    // Logic to delete the forum
    _forumServices.deleteForum(forumId).then((_) {
      _fetchForums();
    });
  }
  void _togglemuteForum(String forumId, String userId) {
    // Logic to mute/unmute the forum
    _forumServices.togglemuteForum(forumId, userId).then((_) {
      _fetchForums();
    });
  }
  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return formatFullDate(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}s ago';
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
  return Container(
    color: themeSettings.backgroundColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Forums",
                style: TextStyle(fontSize: subtitleTextSize, color: themeSettings.primaryColor),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logic to open the create forum form or popup
                  _openCreateForum();
                },
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
        isLoadingForums
            ? Center(child: CircularProgressIndicator()) // Loading indicator when forums are being fetched
            : Expanded(
                child: ListView.builder(
                  itemCount: searchTerm.isNotEmpty ? searchedForums!.length : forums!.length,
                  itemBuilder: (context, index) {
                    final forum = searchTerm.isNotEmpty ? searchedForums![index] : forums![index];
                    final userId = forum['UserId'] as String;
                    final userProf = userProfiles[userId];
                    final creatorUsername = userProf?['name'] ?? 'Unknown';
                    final lastUpdated = formatDateTime(forum['lastUpdated']); // Assuming `lastUpdated` is a DateTime field

                    return OpenContainer(
                      transitionDuration: Duration(milliseconds: 300),
                      tappable: false,
                      closedBuilder: (context, action) {
                        return GestureDetector(
                          onTap: () {
                            _selectForum(forum['forumId']);
                            action();
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: themeSettings.cardColor,
                              borderRadius: BorderRadius.circular(10),
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
                                      Text(
                                        'Last Updated: $lastUpdated',
                                        style: TextStyle(
                                          fontSize: bodyTextSize - 2,
                                          color: themeSettings.textColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (userId == profileDetails.userID) // Show delete/mute for forum creator
                                  PopupMenuButton(
                                    icon: Icon(Icons.more_vert, color: themeSettings.primaryColor),
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        _deleteForum(forum['forumId']);
                                      } else if (value == 'mute') {
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
                      closedColor: Colors.transparent,
                      closedElevation: 0,
                      openBuilder: (context, action) {
                        return _ForumView(forumId: forum['forumId']);
                      },
                    );
                  },
                ),
              ),
      ],
    ),
  );
}
}

class _ForumView extends StatefulWidget {
  const _ForumView({super.key, required this.forumId});
  final String forumId;

  @override
  State<_ForumView> createState() => __ForumViewState();
}

class __ForumViewState extends State<_ForumView> {
  bool isLoadingPosts = true;
  List<Map<String, dynamic>>? localPosts;

  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectForum(widget.forumId);
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

  // This method will be passed as a callback to MessageView
  void _onReplyAdded() {
    if (selectedForumId != null) {
      print('Reply added');
      _fetchPosts(selectedForumId!);
    }
  }

  Future<void> showDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: themeSettings.backgroundColor,
            title: Text("Reply to message", style: TextStyle(color: themeSettings.textColor)),
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

void _selectForum(String forumId) {
  print('Selected forum: $forumId');
  setState(() {
    selectedForumId = forumId;
    posts = null;

    var selectedForum = forums?.firstWhere(
      (forum) => forum['forumId'] == forumId,
      orElse: () => {}, // Changed to an empty map for better null handling
    );

    if (selectedForum == null) {
      print('Selected forum not found');
      return; // Handle case where the forum is not found
    }

    forumName = selectedForum['Name'] as String? ?? 'Unknown';
    forumDescription = selectedForum['Description'] as String? ?? 'No description available';
    isLoadingPosts = true;
    print('Selected forum: $forumName, $forumDescription, $isLoadingPosts');
  });
  
  if (selectedForumId!.isNotEmpty) {
    _fetchPosts(selectedForumId!);
  }
}

  Future<void> _fetchPosts(String forumId) async {
    try {
      List<Map<String, dynamic>>? fetchedPosts = await _forumServices.getMessages(forumId);
      if (!mounted) return;
      setState(() {
        localPosts = fetchedPosts;
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
    if (localPosts == null || localPosts!.isEmpty) return;

    try {
      Set<String> userIds = localPosts!.map((post) => post['message']['UserId'] as String).toSet();

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
   String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return formatFullDate(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}s ago';
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
  void _deleteMessage(String postId) {
    // Logic to delete the message
    _forumServices.deleteMessage(selectedForumId!, postId).then((_) {
      _fetchPosts(selectedForumId!);
    });
  }
  void _togglemuteMessage(String postId, String forumId, String userId) {
    // Logic to mute/unmute the message
    _forumServices.togglemuteMessage(forumId, postId, userId).then((_) {
      _fetchPosts(selectedForumId!);
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: themeSettings.backgroundColor,
      title: Text(
        forumName!,
        style: TextStyle(color: themeSettings.primaryColor, fontSize: 30),
      ),
      iconTheme: IconThemeData(color: themeSettings.primaryColor),
    ),
    body: Container(
      padding: const EdgeInsets.all(16.0),
      color: themeSettings.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            forumDescription!,
            style: TextStyle(color: themeSettings.textColor),
          ),
          SizedBox(height: 20),
          isLoadingPosts
              ? Center(child: CircularProgressIndicator())
              : localPosts != null && localPosts!.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: localPosts!.length,
                        itemBuilder: (context, index) {
                          final post = localPosts![index];
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
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row with avatar, name, and time
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(userProfilePic),
                                        radius: 20,
                                      ),
                                      SizedBox(width: 10),
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
                                            // Delete/mute options for the post creator
                                            if (userId == profileDetails.userID)
                                              PopupMenuButton(
                                                icon: Icon(Icons.more_vert, color: themeSettings.primaryColor),
                                                onSelected: (value) {
                                                  if (value == 'delete') {
                                                    _deleteMessage(postId);
                                                  } else if (value == 'mute') {
                                                    _togglemuteMessage(postId, selectedForumId!, userId);
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete Post'),
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
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  // Post content
                                  Text(
                                    post['message']?['Content'] ?? 'No Content',
                                    style: TextStyle(fontSize: subBodyTextSize, color: themeSettings.textColor),
                                  ),
                                  SizedBox(height: 10),
                                  // Likes and comments row
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
                                            Icons.favorite_border,
                                            color: Colors.red.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                      Text(numLikes, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
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
                                      Text(numReplies, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
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
  );
}
}

class MessageView extends StatefulWidget {
  final Map<String, dynamic> post;
  final String forumId;
  final Map<String, Map<String, dynamic>> userProfiles;
  final ForumServices forumServices;
  final AuthService authService;
  final VoidCallback onReplyAdded; // Add the callback parameter

  MessageView({
    required this.post,
    required this.forumId,
    required this.userProfiles,
    required this.forumServices,
    required this.authService,
    required this.onReplyAdded, // Initialize the callback
  });

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final TextEditingController _replyController = TextEditingController();

  Future<void> _replyToMessage(String postId) async {
    String? newReplyContent = _replyController.text;
    if (newReplyContent.isNotEmpty) {
      try {
        String? userId = await widget.authService.getCurrentUserId();
        await widget.forumServices.replyToMessage(widget.forumId, postId, userId!, newReplyContent);
        _fetchReplies(widget.forumId, postId); // Call the method to refresh the posts
        setState(() {
          _replyController.clear();
        });
        widget.onReplyAdded(); // Trigger the callback to notify DesktopForums
      } catch (e) {
        print('Error replying to message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postId = widget.post['messageId'];
    final userId = widget.post['message']['UserId'] as String;
    final userProfile = widget.userProfiles[userId];
    final replies = widget.post['replies'] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeSettings.backgroundColor,
        title: Text('View Message', style: TextStyle(color: themeSettings.primaryColor, fontSize: 30)),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: themeSettings.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProfile?['userName'] ?? 'Unknown User',
              style: TextStyle(fontSize: 24, color: themeSettings.primaryColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.post['message']?['Content'] ?? 'No Content',
              style: TextStyle(fontSize: 18, color: themeSettings.textColor),
            ),
            SizedBox(height: 20),
            Text(
              'Replies',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: replies.length,
                itemBuilder: (context, index) {
                  final reply = replies[index];
                  final replyUserId = reply['UserId'] as String;
                  final replyUserProfile = widget.userProfiles[replyUserId];

                  return Container(
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
                        Text(
                          replyUserProfile?['userName'] ?? 'Unknown User',
                          style: TextStyle(fontSize: bodyTextSize, color: themeSettings.textColor),
                        ),
                        SizedBox(height: 5),
                        Text(
                          reply['Content'] ?? 'No Content',
                          style: TextStyle(fontSize: subBodyTextSize, color: themeSettings.textColor),
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
                hintText: 'Type your reply here',
                hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.5)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    await _replyToMessage(postId);
                  },
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
