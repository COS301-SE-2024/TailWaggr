// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:cos301_capstone/services/forum/forum.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';

class TabletForums extends StatefulWidget {
  const TabletForums({super.key});

  @override
  State<TabletForums> createState() => _ForumsPageState();
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
Map<String, Map<String, dynamic>> userProfiles = {};

class _ForumsPageState extends State<TabletForums> {
  TextEditingController forumSearchController = TextEditingController();
  TextEditingController messageController = TextEditingController();
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
        forums = fetchedForums;
        searchedForums = forums;
        if (forums != null && forums!.isNotEmpty) {
          selectedForumId = forums!.first['forumId'];
          forumName = forums!.first['Name'];
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
      forumName = forums!.firstWhere((forum) => forum['forumId'] == forumId)['Name'];
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
            title: Text("Reply to message"),
            content: TextField(
              onChanged: (value) {
                if (!mounted) return;
                setState(() {
                  newReplyContent = value;
                });
              },
              decoration: InputDecoration(hintText: "Type your reply here"),
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
        onReplyAdded: _onReplyAdded,
      ),
    ));
  }

  void _onReplyAdded() {
    if (selectedForumId != null) {
      print('Reply added');
      _fetchPosts(selectedForumId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final forumListWidth = isTablet
        ? MediaQuery.of(context).size.width * 0.2
        : MediaQuery.of(context).size.width * 0.35;
    final forumDetailWidth = isTablet
        ? MediaQuery.of(context).size.width * 0.5
        : MediaQuery.of(context).size.width * 0.35;

    return Container(
      color: themeSettings.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DesktopNavbar(),
          Container(
            padding: EdgeInsets.all(20),
            width: forumListWidth,
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
                        searchedForums = forums!.where((forum) =>
                            forum['Name']
                                .toString()
                                .toLowerCase()
                                .contains(searchTerm.toLowerCase())).toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search for a forum",
                      hintStyle: TextStyle(
                          color: themeSettings.textColor.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search),
                    ),
                    style: TextStyle(
                        color: themeSettings.textColor),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchTerm.isNotEmpty ? searchedForums!.length : forums!.length,
                    itemBuilder: (context, index) {
                      final forum = searchTerm.isNotEmpty ? searchedForums![index] : forums![index];
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
                            // border: Border.all(
                            //   color: themeSettings.primaryColor,
                            //   width: 2.0,
                            // ),
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
            padding: EdgeInsets.all(20),
            width: forumDetailWidth,
            color: themeSettings.cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoadingPosts)
                Center(child: CircularProgressIndicator())
                else if (posts == null || posts!.isEmpty)
                  Text(
                    "No posts available",
                    style: TextStyle(
                        color: themeSettings.textColor),
                  )
                else ...[
                  Text(
                    forumName ?? "Selected Forum",
                    style: TextStyle(
                      fontSize: subtitleTextSize,
                      color: themeSettings.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts!.length,
                      itemBuilder: (context, index) {
                        final post = posts![index];
                        final postId = post['messageId'];
                        var numLikes = post['likesCount'].toString();
                        final numReplies = post['repliesCount'].toString();
                        final userId = post['message']['UserId'];
                        final userProfile = userProfiles[userId];
                        //print('userProfile: $userProfile');
                        final username = userProfile != null ? userProfile['userName'] : 'Unknown';
                        //print('username: $username');
                        return GestureDetector(
                          onTap: () => _viewMessage(context, post),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['message']['Content'],
                                  style: TextStyle(
                                    fontSize: bodyTextSize,
                                    color: themeSettings.textColor,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Posted by $username",
                                  style: TextStyle(
                                    fontSize: subBodyTextSize,
                                    color: themeSettings.textColor.withOpacity(0.5),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.red.withOpacity(0.7),
                                      ),
                                      onPressed: () { _likeMessage(post['messageId']);
                                      ForumServices().getLikesCount(selectedForumId!, postId).then((value) {
                                      setState(() {
                                      numLikes = value.toString();});
                                      });
                                      },
                                    ),
                                    Text(numLikes, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.comment, color: Colors.blue.withOpacity(0.7),),
                                      onPressed: () {
                                        setState(() {
                                          selectedPostId = post['messageId'];
                                        });
                                        showDialogBox(context);
                                      },
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
                  ),
                  TextField(
                    controller: messageController,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() {
                        newMessageContent = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Type your message here",
                      hintStyle: TextStyle(
                          color: themeSettings.textColor.withOpacity(0.5)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: themeSettings.primaryColor),
                        onPressed: _addMessage,
                      ),
                    ),
                    style: TextStyle(
                        color: themeSettings.textColor),
                  ),
                ],
              ],
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
    String? newReplyContent = _replyController.text;
    if (newReplyContent.isNotEmpty) {
      try {
        String? userId = await widget.authService.getCurrentUserId();
        await widget.forumServices.replyToMessage(widget.forumId, postId, userId!, newReplyContent);
        _fetchReplies(widget.forumId, postId);
        setState(() {
          _replyController.clear();
        });
        widget.onReplyAdded();
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
              userProfile?['name'] ?? 'Unknown User',
              style: TextStyle(
                  fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
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
                      // border: Border.all(
                      //   color: Colors.grey,
                      //   width: 1.0,
                      // ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          replyUserProfile?['name'] ?? 'Unknown User',
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
