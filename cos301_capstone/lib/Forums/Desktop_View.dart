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
      List<Map<String, dynamic>>? fetchedForums =
          await _forumServices.getForums();
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
      });
    } catch (e) {
      print('Error fetching forums: $e');
    }
  }

  void _selectForum(String forumId) {
    setState(() {
      selectedForumId = forumId;
      posts = null;
      forumName =
          forums!.firstWhere((forum) => forum['forumId'] == forumId)['Name'];
      //uncomment after adding descriptions for each post:
      //forumDescription =
        //  forums!.firstWhere((forum) => forum['forumId'] == forumId)['Description'];          
      isLoadingPosts = true;
    });
    _fetchPosts(forumId);
  }

  Future<void> _fetchPosts(String forumId) async {
    try {
      List<Map<String, dynamic>>? fetchedPosts =
          await _forumServices.getMessages(forumId);
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
      Set<String> userIds =
          posts!.map((post) => post['message']['UserId'] as String).toSet();

      for (String userId in userIds) {
        if (!userProfiles.containsKey(userId)) {
          Map<String, dynamic>? profile =
              await _profileServices.getUserDetails(userId);
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
        await _forumServices.createMessage(
            selectedForumId!, userId!, newMessageContent!);
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
      await _forumServices.toggleLikeOnMessage(
          selectedForumId!, postId, userId!);
      _fetchPosts(selectedForumId!);
    } catch (e) {
      print('Error liking message: $e');
    }
  }

  Future<void> _replyToMessage(String postId) async {
    if (newReplyContent != null && newReplyContent!.isNotEmpty) {
      try {
        String? userId = await _authService.getCurrentUserId();
        await _forumServices.replyToMessage(
            selectedForumId!, postId, userId!, newReplyContent!);
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
        return AlertDialog(
          title: Text('Create a Forum'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: forumNameController,
                decoration: InputDecoration(labelText: 'Forum Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: forumDescriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String name = forumNameController.text;
                String? userId = await _authService.getCurrentUserId();
                String description = forumDescriptionController.text;

                if (name.isNotEmpty && description.isNotEmpty) {
                  await _forumServices.createForum(name,userId!,description);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Create'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
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
                Text(
                  "Forums",
                  style: TextStyle(
                      fontSize: subtitleTextSize,
                      color: themeSettings.primaryColor),
                ),
                SizedBox(
                  height: 35,
                  child: TextField(
                    controller: forumSearchController,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() {
                        searchTerm = value;
                        searchedForums = forums!
                            .where((forum) => forum['Name']
                                .toString()
                                .toLowerCase()
                                .contains(searchTerm.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search for a forum",
                      hintStyle: TextStyle(
                          color: themeSettings.textColor.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search),
                    ),
                    style: TextStyle(color: themeSettings.textColor),
                  ),
                ),
                //create sized box to create a forum
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                     onPressed: _createForum,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          themeSettings.primaryColor),
                    ),
                    child: Text(
                      "Create a forum",
                      style: TextStyle(
                        color: themeSettings.textColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchTerm.isNotEmpty
                        ? searchedForums!.length
                        : forums!.length,
                    itemBuilder: (context, index) {
                      final forum = searchTerm.isNotEmpty
                          ? searchedForums![index]
                          : forums![index];
                      return GestureDetector(
                        onTap: () {
                          _selectForum(forum['forumId']);
                        },
                        child: Container(
                          height: 100,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: themeSettings.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: themeSettings.primaryColor,
                              width: 2.0,
                            ),
                          ),
                          child: Text(
                            forum['Name'],
                            style: TextStyle(
                              fontSize: bodyTextSize,
                              color: themeSettings.textColor,
                            ),
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
                      style: TextStyle(
                          fontSize: subtitleTextSize,
                          color: themeSettings.primaryColor),
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
                                    var numLikes =
                                        post['likesCount'].toString();
                                    final numReplies =
                                        post['repliesCount'].toString();
                                    final userId =
                                        post['message']['UserId'] as String;
                                    final userProfile = userProfiles[userId];

                                    return GestureDetector(
                                      onTap: () {
                                        _viewMessage(context, post);
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: themeSettings.cardColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: themeSettings.primaryColor,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userProfile?['userName'] ??
                                                  'Unknown User',
                                              style: TextStyle(
                                                  fontSize: bodyTextSize,
                                                  color:
                                                      themeSettings.textColor),
                                            ),
                                            Text(
                                              post['message']?['Content'] ??
                                                  'No Content',
                                              style: TextStyle(
                                                  fontSize: subBodyTextSize,
                                                  color:
                                                      themeSettings.textColor),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Tooltip(
                                                  message: "Like",
                                                  child: IconButton(
                                                    onPressed: () {
                                                      print(
                                                          "Like button pressed");
                                                      _likeMessage(postId);

                                                      ForumServices()
                                                          .getLikesCount(
                                                              selectedForumId!,
                                                              postId)
                                                          .then((value) {
                                                        setState(() {
                                                          numLikes =
                                                              value.toString();
                                                        });
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.red
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),
                                                Text(numLikes,
                                                    style: TextStyle(
                                                        color: themeSettings
                                                            .textColor
                                                            .withOpacity(0.7))),
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
                                                      color: Colors.blue
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),
                                                Text(numReplies,
                                                    style: TextStyle(
                                                        color: themeSettings
                                                            .textColor
                                                            .withOpacity(0.7))),
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
                        hintStyle: TextStyle(
                            color: themeSettings.textColor.withOpacity(0.5)),
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
        await widget.forumServices
            .replyToMessage(widget.forumId, postId, userId!, newReplyContent);
        _fetchReplies(
            widget.forumId, postId); // Call the method to refresh the posts
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
        title: Text('View Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProfile?['userName'] ?? 'Unknown User',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.post['message']?['Content'] ?? 'No Content',
              style: TextStyle(fontSize: 18, color: Colors.black),
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
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          replyUserProfile?['userName'] ?? 'Unknown User',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          reply['Content'] ?? 'No Content',
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
