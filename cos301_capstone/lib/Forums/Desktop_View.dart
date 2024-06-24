import 'package:flutter/material.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/auth/auth.dart';
import 'package:cos301_capstone/services/forum/forum.dart';

class DesktopForums extends StatefulWidget {
  const DesktopForums({super.key});

  @override
  State<DesktopForums> createState() => _DesktopForumsState();
}

final ForumServices _forumServices = ForumServices();
final AuthService _authService = AuthService();
List<Map<String, dynamic>>? forums;
List<Map<String, dynamic>>? posts;
List<Map<String, dynamic>>? searchedForums;
String searchTerm = "";
String? selectedForumId;
String? newMessageContent;
String? newReplyContent;
String? selectedPostId;
String? forumName;

class _DesktopForumsState extends State<DesktopForums> {
  TextEditingController forumSearchController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  bool isLoadingPosts = false; // Flag to track if posts are being loaded

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
        searchedForums = forums; // Initialize searchedForums with forums
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
    isLoadingPosts = true; // Set loading state true when forum is selected
  });
  _fetchPosts(forumId);
}


  Future<void> _fetchPosts(String forumId) async {
    try {
      List<Map<String, dynamic>>? fetchedPosts = await _forumServices.getMessages(forumId);
      if (!mounted) return;
      setState(() {
        posts = fetchedPosts;
        isLoadingPosts = false; // Set loading state false when posts are fetched
      });
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        isLoadingPosts = false; // Ensure loading state is set false on error
      });
    }
  }

  Future<void> _addMessage() async {
    if (newMessageContent != null && newMessageContent!.isNotEmpty) {
      try {
        String? userId = await _authService.getCurrentUserId();
        await _forumServices.createMessage(selectedForumId!, userId!, newMessageContent!);
        _fetchPosts(selectedForumId!);  // Refresh the posts after adding a new message
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
      await _forumServices.likeMessage(selectedForumId!,postId, userId!);
      _fetchPosts(selectedForumId!);  // Refresh the posts after liking a message
    } catch (e) {
      print('Error liking message: $e');
    }
  }

  Future<void> _replyToMessage(String postId) async {
    if (newReplyContent != null && newReplyContent!.isNotEmpty) {
      try {
        String? userId = await _authService.getCurrentUserId();
        await _forumServices.replyToMessage(selectedForumId!,postId, userId!, newReplyContent!);
        _fetchPosts(selectedForumId!);  // Refresh the posts after replying to a message
        setState(() {
          newReplyContent = '';
        });
      } catch (e) {
        print('Error replying to message: $e');
      }
    }
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
            width: MediaQuery.of(context).size.width * 0.38, // Adjusted width for forums column
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
                        color: themeSettings.textColor), // Add this line
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
                    SizedBox(height: 20),
                    isLoadingPosts
                        ? Center(child: CircularProgressIndicator()) // Show loading indicator while posts are being fetched
                        : posts != null && posts!.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: posts!.length,
                                  itemBuilder: (context, index) {
                                    final postId = posts![index]['messageId'];
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: themeSettings.cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: themeSettings.primaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            posts![index]['message']?['UserId'] ?? 'Unknown User',
                                            style: TextStyle(
                                                fontSize: bodyTextSize,
                                                color: themeSettings.textColor),
                                          ),
                                          Text(
                                            posts![index]['message']?['Content'] ?? 'No Content',
                                            style: TextStyle(
                                                fontSize: subBodyTextSize,
                                                color: themeSettings.textColor),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.thumb_up),
                                                onPressed: () => _likeMessage(postId),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.reply),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedPostId = postId;
                                                    _replyToMessage(postId);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
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
                      },
                      decoration: InputDecoration(
                        labelText: 'Type a new message',
                        border: OutlineInputBorder(),
                      ),
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
