// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
// import 'dart:ffi';

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/User_Profile/User_Profile.dart';
import 'package:cos301_capstone/services/HomePage/home_page_service.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:cos301_capstone/services/imageApi/imageFilter.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final HomePageService homePageService = HomePageService();
class DesktopHomepage extends StatefulWidget {
  const DesktopHomepage({super.key});

  @override
  State<DesktopHomepage> createState() => _DesktopHomepageState();
}

class _DesktopHomepageState extends State<DesktopHomepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: themeSettings.backgroundColor,
      child: Row(
        children: [
          DesktopNavbar(),
          PostContainer(),
          UploadPostContainer(),
        ],
      ),
    );
  }
}

class PostContainer extends StatefulWidget {
  const PostContainer({super.key});
  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  bool isLoadingMore = false; // To track whether more posts are loading
  bool isInitialLoading = true; // To track initial loading state

  @override
  void initState() {
    super.initState();
    fetchInitialPosts();
    homepageVAF.postPosted.addListener(() async {
      await getPosts(null, false);
      setState(() {});
    });
  }

  Future<void> fetchInitialPosts() async {
    await getPosts(null, false);
    setState(() {
      isInitialLoading = false; // Set initial loading to false after fetching
    });
  }

  Future<void> getPosts(String? labels, bool getMore) async {
    if (getMore) {
      setState(() {
        isLoadingMore = true;
      });
    }
    try {
      List<Map<String, dynamic>> fetchedPosts = await homePageService.getPosts(words: labels, isLoadMore: getMore);

      setState(() {
        if (getMore) {
          if (fetchedPosts.isNotEmpty) {
            profileDetails.posts.addAll(fetchedPosts);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No more posts to load'),
              ),
            );
          }
        } else {
          profileDetails.posts = fetchedPosts;
        }
      });
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      if (getMore) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 39,
              width: (MediaQuery.of(context).size.width - 250) * 0.7 - 100,
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: searchController,
                style: TextStyle(color: themeSettings.textColor),
                decoration: InputDecoration(
                  hintText: 'Search posts...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: themeSettings.primaryColor),
                  ),
                ),
                onSubmitted: (value) async {
                  await getPosts(value, false);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 100,
              height: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: themeSettings.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  await getPosts(searchController.text, false);
                },
                child: Text(
                  'Search',
                  style: TextStyle(color: themeSettings.textColor),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: (MediaQuery.of(context).size.width - 250) * 0.7,
          height: MediaQuery.of(context).size.height - 100,
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeSettings.cardColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (isInitialLoading) Center(child: CircularProgressIndicator()), // Loading indicator for initial load
                for (int i = 0; i < profileDetails.posts.length; i++) ...[
                  Post(
                    postDetails: profileDetails.posts[i],
                    key: UniqueKey(),
                  ),
                  Divider(),
                ],
                if (isLoadingMore)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                // Only show "View More" button if there are more posts to load
                if (!isLoadingMore && profileDetails.posts.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await getPosts(searchController.text, true);
                    },
                    child: Text("View More"),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Post extends StatefulWidget {
  const Post({super.key, required this.postDetails});

  final Map<String, dynamic> postDetails;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  String numLikes = "0";
  String numViews = "0";
  String numComments = "0";
  String newReplyContent = "";
  bool isLiked = false;
  List<Map<String, dynamic>> comments = [];
  final HomePageService _homePageService = homePageService;
  @override
  void initState() {
    super.initState();
    getLikes();
    getViews();
    getCommentCount();
    checkIfLiked();
  }

  void getLikes() async {
    Future<int> likes = homePageService.getLikesCount(widget.postDetails['PostId']);
    likes.then((value) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        numLikes = value.toString();
      });
    });
  }

  void getViews() async {
    homePageService.addViewToPost(widget.postDetails['PostId'], profileDetails.userID);
    Future<int> views = homePageService.getViewsCount(widget.postDetails['PostId']);
    views.then((value) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        numViews = value.toString();
      });
    });
  }

  void getCommentCount() async {
    Future<int> commentCount = homePageService.getCommentsCount(widget.postDetails['PostId']);
    commentCount.then((value) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        numComments = value.toString();
      });
    });
  }

  Future<void> checkIfLiked() async {
    // Simulate an asynchronous operation
    bool liked = await homePageService.checkIfUserLikedPost(widget.postDetails['PostId'], profileDetails.userID);
    // Check if the widget is still mounted before calling setState
    if (!mounted) return;
    setState(() {
      isLiked = liked;
    });
  }

  @override
  void dispose() {
    // Perform any necessary cleanup here
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> getComments() async {
    List<Map<String, dynamic>> commentsList = await homePageService.getComments(widget.postDetails['PostId']);
    for (int i = 0; i < commentsList.length; i++) {
      Map<String, dynamic> comment = commentsList[i];
      Map<String, dynamic>? profileDetails = await ProfileService().getUserDetails(comment['userId']);
      // print("Profile Details: $profileDetails");
      comment['name'] = profileDetails!['name'] + ' ' + profileDetails['surname'];
      comment['pictureUrl'] = profileDetails['profilePictureUrl'];
      commentsList[i] = comment;
      print(commentsList[i]);
      print("");
    }

    commentsList.sort((a, b) => a['commentedAt'].compareTo(b['commentedAt']));

    return commentsList;
  }

  String formatDate() {
    DateTime date = widget.postDetails["CreatedAt"].toDate();
    String month = getMonthAbbreviation(date.month);
    return "${date.day} $month ${date.year}";
  }

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _replyToMessage(String postId) async {
    if (newReplyContent.isNotEmpty) {
      try {
        _homePageService.addCommentToPost(postId, profileDetails.userID, newReplyContent);
        //_PostContainerState()._fetchPosts();//refresh the posts
        setState(() {
          newReplyContent = '';
          numComments = (int.parse(numComments) + 1).toString();
        });
      } catch (e) {
        print('Error replying to post: $e');
      }
    }
  }

  Future<Map<String, dynamic>> fetchPostData({bool isLastPost = false}) async {
    // Fetch post labels and wiki links asynchronously
    List<String> postLabels = await homePageService.getPostLabels(widget.postDetails['PostId']);
    List<String> wikiLinks = await homePageService.getWikiLinks(postLabels);
    List<Map<String, dynamic>> comments = await getComments();

    // Fetch users who liked the post
    List<String> likedUsers = await homePageService.getLikes(widget.postDetails['PostId']);
    List<Map<String, dynamic>> likedUsersList = [];
    for (String userId in likedUsers) {
      Map<String, dynamic>? profileDetails = await ProfileService().getUserDetails(userId);
      likedUsersList.add({
        'username': (profileDetails?['name'] ?? 'Unknown') + ' ' + (profileDetails?['surname'] ?? ''),
        'pictureUrl': profileDetails?['profilePictureUrl'] ?? '',
        'userId': userId,
      });
    }

    // Combine the data in a map to be passed to the dialog
    return {
      "name": widget.postDetails["name"] ?? 'Unknown',
      "postLabels": postLabels,
      "wikiLinks": wikiLinks,
      "likedUsers": likedUsersList,
      "comments": comments,
      "PetIds": widget.postDetails["PetIds"] ?? [],
    };
  }

  final GlobalKey<NavigatorState> _loadingDialogKey = GlobalKey<NavigatorState>();

  Future<void> showPostDetails(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
          key: _loadingDialogKey,
        );
      },
    );

    try {
      // Fetch post details
      final postDetails = await fetchPostData();
      print("Post details: $postDetails");
      // Close the loading indicator
      if (_loadingDialogKey.currentContext != null) {
        Navigator.of(_loadingDialogKey.currentContext!).pop(); // Ensure the loading dialog is closed
      }

      // Show post details dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: themeSettings.cardColor,
            content: Container(
              width: 800,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section: Post Details
                    Row(
                      key: UniqueKey(),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 400,
                          padding: EdgeInsets.only(right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => User_Profile(userId: widget.postDetails["UserId"])));
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(widget.postDetails["pictureUrl"]),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.postDetails["name"],
                                        style: TextStyle(
                                          color: themeSettings.textColor,
                                        ),
                                      ),
                                      Text(
                                        "Posted on ${formatDate()}",
                                        style: TextStyle(
                                          color: themeSettings.textColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                widget.postDetails["Content"] ?? 'No content',
                                style: TextStyle(
                                  color: themeSettings.textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                              SizedBox(height: 20),
                              if (widget.postDetails['PetIds'] != null && widget.postDetails['PetIds'].length != 0) ...[
                                Text(
                                  "Pets included in this post: ",
                                  style: TextStyle(
                                    color: themeSettings.textColor.withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(height: 5),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (var pet in widget.postDetails['PetIds']) ...[
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(pet["pictureUrl"] ?? profileDetails.profilePicture),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                pet["name"] ?? 'Unnamed pet',
                                                style: TextStyle(color: themeSettings.textColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.postDetails["ImgUrl"] ?? profileDetails.profilePicture,
                            width: 300,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 30),
                        Column(
                          children: [
                            Tooltip(
                              message: "Like",
                              child: IconButton(
                                onPressed: () async {
                                  await homePageService.toggleLikeOnPost(widget.postDetails['PostId'], profileDetails.userID);
                                  bool liked = await homePageService.checkIfUserLikedPost(widget.postDetails['PostId'], profileDetails.userID);
                                  int likesCount = await homePageService.getLikesCount(widget.postDetails['PostId']);
                                  setState(() {
                                    print("Liked: $liked");
                                    isLiked = liked;
                                    numLikes = likesCount.toString();
                                  });
                                },
                                icon: isLiked
                                    ? Icon(
                                        Icons.pets,
                                        color: Colors.red.withOpacity(0.7),
                                      )
                                    : SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.red.withOpacity(0.7),
                                            BlendMode.srcIn,
                                          ),
                                          child: Image.asset('assets/images/paw1.png'),
                                        ),
                                      ),
                              ),
                            ),
                            Text(numLikes, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                            SizedBox(height: 20),
                            Tooltip(
                              message: "Comment",
                              child: IconButton(
                                onPressed: () async {
                                  showDialogBox(context);
                                  // await getCommments();
                                  homePageService.getCommentsCount(widget.postDetails['PostId']).then((value) {
                                    setState(() {
                                      numComments = value.toString();
                                    });
                                  });
                                },
                                icon: Icon(
                                  Icons.comment,
                                  color: Colors.blue.withOpacity(0.7),
                                ),
                              ),
                            ),
                            Text(numComments, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                            SizedBox(height: 20),
                            Tooltip(
                              message: "Views",
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Colors.green.withOpacity(0.7),
                              ),
                            ),
                            Text(numViews, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(
                                child: Text("Labels"),
                              ),
                              Tab(
                                child: Text("Comments"),
                              ),
                              Tab(
                                child: Text("Likes"),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 250, // Specify the height for the TabBarView
                            child: TabBarView(
                              children: [
                                // Labels Section
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    spacing: 10, // Adds some space between the labels
                                    runSpacing: 10, // Adds some space between the rows
                                    children: [
                                      for (int i = 0; i < postDetails['postLabels'].length; i++) ...[
                                        Container(
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: themeSettings.primaryColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () async {
                                                final Uri url = Uri.parse(postDetails['wikiLinks'][i]);
                                                if (!await launchUrl(url)) {
                                                  print('Could not launch $url');
                                                }
                                              },
                                              child: Center(
                                                child: Text(postDetails['postLabels'][i], style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      for (var user in postDetails['comments']) ...[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                                onTap: () {
                                                  // Handle profile click
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => User_Profile(userId: user['userId'])));
                                                },
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: NetworkImage(user['pictureUrl'] ?? ''),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          user['name'] ?? 'Unknown',
                                                          style: TextStyle(
                                                            color: themeSettings.textColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          user['comment'] ?? 'No content',
                                                          style: TextStyle(
                                                            color: themeSettings.textColor.withOpacity(0.7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    spacing: 8.0, // Adds some space between the users
                                    children: [
                                      for (var user in postDetails['likedUsers']) ...[
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: InkWell(
                                            onTap: () {
                                              // Handle profile click
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => User_Profile(userId: user['userId'])));
                                            },
                                            child: Container(
                                              width: 200,
                                              height: 50,
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                // color: themeSettings.primaryColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage(user['pictureUrl'] ?? ''),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    user['username'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      color: themeSettings.textColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Close",
                  style: TextStyle(color: themeSettings.primaryColor),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error fetching post details: $e");
      if (_loadingDialogKey.currentContext != null) {
        Navigator.of(_loadingDialogKey.currentContext!).pop(); // Close the loading dialog if an error occurs
      }

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while fetching post details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> showDialogBox(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: themeSettings.cardColor,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section: Post Details
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(widget.postDetails['pictureUrl'] ?? profileDetails.profilePicture),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.postDetails['name'] ?? 'Unknown',
                              style: TextStyle(
                                color: themeSettings.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Posted on ${formatDate()}",
                              style: TextStyle(
                                color: themeSettings.textColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.postDetails['Content'] ?? 'No content',
                      style: TextStyle(
                        color: themeSettings.textColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),

                    // Scrollable Comments Section
                    Flexible(
                      child: SingleChildScrollView(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: getComments(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error loading comments", style: TextStyle(color: Colors.red));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text("No comments available", style: TextStyle(color: themeSettings.textColor));
                            } else {
                              List<Map<String, dynamic>> comments = snapshot.data!;

                              return Column(
                                children: comments.map((comment) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(comment['pictureUrl'] ?? profileDetails.profilePicture),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment['name'] ?? 'Unknown',
                                                style: TextStyle(
                                                  color: themeSettings.textColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                comment['comment'] ?? 'No content',
                                                style: TextStyle(
                                                  color: themeSettings.textColor.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profileDetails.profilePicture),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              if (!mounted) return;
                              setState(() {
                                newReplyContent = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Post your reply",
                              hintStyle: TextStyle(color: themeSettings.textColor.withOpacity(0.7)),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(color: themeSettings.textColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: themeSettings.primaryColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _replyToMessage(widget.postDetails['PostId']);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: themeSettings.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  "Reply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error fetching post details: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while fetching post details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: UniqueKey(),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          padding: EdgeInsets.only(right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => User_Profile(userId: widget.postDetails["UserId"])));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.postDetails["pictureUrl"]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postDetails["name"],
                        style: TextStyle(
                          color: themeSettings.textColor,
                        ),
                      ),
                      Text(
                        "Posted on ${formatDate()}",
                        style: TextStyle(
                          color: themeSettings.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                widget.postDetails["Content"] ?? 'No content',
                style: TextStyle(
                  color: themeSettings.textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              SizedBox(height: 20),
              if (widget.postDetails['PetIds'] != null && widget.postDetails['PetIds'].length != 0) ...[
                Text(
                  "Pets included in this post: ",
                  style: TextStyle(
                    color: themeSettings.textColor.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var pet in widget.postDetails['PetIds']) ...[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(pet["pictureUrl"] ?? profileDetails.profilePicture),
                              ),
                              SizedBox(height: 5),
                              Text(
                                pet["name"] ?? 'Unnamed pet',
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        InkWell(
          onTap: () {
            showPostDetails(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.postDetails["ImgUrl"] ?? profileDetails.profilePicture,
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 30),
        Column(
          children: [
            Tooltip(
              message: "Like",
              child: IconButton(
                onPressed: () async {
                  await homePageService.toggleLikeOnPost(widget.postDetails['PostId'], profileDetails.userID);
                  bool liked = await homePageService.checkIfUserLikedPost(widget.postDetails['PostId'], profileDetails.userID);
                  int likesCount = await homePageService.getLikesCount(widget.postDetails['PostId']);
                  setState(() {
                    print("Liked: $liked");
                    isLiked = liked;
                    numLikes = likesCount.toString();
                  });
                },
                icon: isLiked
                    ? Icon(
                        Icons.pets,
                        color: Colors.red.withOpacity(0.7),
                      )
                    : SizedBox(
                        width: 24,
                        height: 24,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.red.withOpacity(0.7),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset('assets/images/paw1.png'),
                        ),
                      ),
              ),
            ),
            Text(numLikes, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
            SizedBox(height: 20),
            Tooltip(
              message: "Comment",
              child: IconButton(
                onPressed: () async {
                  showDialogBox(context);
                  // await getCommments();
                  homePageService.getCommentsCount(widget.postDetails['PostId']).then((value) {
                    setState(() {
                      numComments = value.toString();
                    });
                  });
                },
                icon: Icon(
                  Icons.comment,
                  color: Colors.blue.withOpacity(0.7),
                ),
              ),
            ),
            Text(numComments, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
            SizedBox(height: 20),
            Tooltip(
              message: "Views",
              child: Icon(
                Icons.remove_red_eye,
                color: Colors.green.withOpacity(0.7),
              ),
            ),
            Text(numViews, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
          ],
        ),
      ],
    );
  }
}

class UploadPostContainer extends StatefulWidget {
  const UploadPostContainer({super.key});

  @override
  State<UploadPostContainer> createState() => _UploadPostContainerState();
}

class _UploadPostContainerState extends State<UploadPostContainer> {
  int petIncludeCounter = 0;
  List<bool> petAdded = [];
  List<Map<String, dynamic>> petList = [];
  TextEditingController postController = TextEditingController();
  bool selectingPet = false;
  List<bool> removePet = [];
  ImageFilter imageFilter = ImageFilter();

  @override
  void initState() {
    super.initState();

    void getPets() async {
      if (!profileDetails.pets.isNotEmpty) {
        print("Pets not found. Fetching pets...");
        List<Map<String, dynamic>> pets = await GeneralService().getUserPets(FirebaseAuth.instance.currentUser!.uid);
        profileDetails.pets = pets;
      }

      setState(() {
        for (var _ in profileDetails.pets) {
          petAdded.add(false);
        }
      });
    }

    getPets();

    imagePicker.filesNotifier.addListener(() {
      setState(() {}); // Rebuild the widget when files are selected
    });
  }

  String errorText = "";
  bool errorVisible = false;
  String postText = "Post";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 450) * 0.3,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: themeSettings.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: Key('post-text-key'),
              controller: postController,
              decoration: InputDecoration(
                labelText: "What's on your mind",
              ),
              maxLines: null, // Allow unlimited lines
              keyboardType: TextInputType.multiline, // Enable multiline input
              style: TextStyle(color: themeSettings.textColor),
            ),
            SizedBox(height: 20),
            if (imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty) ...[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      imagePicker.filesNotifier.value![0].bytes!,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      color: Colors.white.withOpacity(0.5),
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      onPressed: () => imagePicker.clearCachedFiles(),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                key: Key('add-photo-button'),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
                child: GestureDetector(
                  onTap: () => imagePicker.pickFiles(),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            color: themeSettings.textColor.withOpacity(0.7),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Add a photo",
                            style: TextStyle(color: themeSettings.textColor.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 20),
            Text(
              "Include your pets",
              style: TextStyle(
                color: themeSettings.textColor.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(100),
                        color: themeSettings.textColor,
                        strokeWidth: 0.5,
                        dashPattern: [5, 5], // Modify the dash pattern to make the border more spread out
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              selectingPet = true;
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            color: themeSettings.textColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                      if (selectingPet) ...[
                        Positioned(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            width: (MediaQuery.of(context).size.width - 590) * 0.3,
                            constraints: BoxConstraints(maxHeight: 200), // Set the maximum width
                            decoration: BoxDecoration(
                              color: themeSettings.backgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Select a pet",
                                        style: TextStyle(
                                          color: themeSettings.textColor,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            selectingPet = false;
                                          });
                                        },
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  for (int i = 0; i < profileDetails.pets.length; i++) ...[
                                    if (petAdded[i] == false)
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              petIncludeCounter++;
                                              selectingPet = false;
                                              removePet.add(false);
                                              petList.add(
                                                {
                                                  'name': profileDetails.pets[i]['name'],
                                                  'pictureUrl': profileDetails.pets[i]['pictureUrl'],
                                                  'index': i,
                                                  'petID': profileDetails.pets[i]['petID'],
                                                },
                                              );
                                              petAdded[i] = true;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(profileDetails.pets[i]["pictureUrl"]),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  profileDetails.pets[i]['name'],
                                                  style: TextStyle(
                                                    color: themeSettings.textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(width: 10),
                  for (int i = 0; i < petIncludeCounter; i++) ...[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  removePet[i] = !removePet[i];
                                });
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(petList[i]["pictureUrl"]!),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            petList[i]["name"]!,
                            style: TextStyle(color: themeSettings.textColor),
                          ),
                          SizedBox(height: 5),
                          if (removePet[i]) ...[
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(100),
                              color: themeSettings.textColor,
                              strokeWidth: 0.5,
                              dashPattern: [5, 5], // Modify the dash pattern to make the border more spread out
                              child: IconButton(
                                iconSize: 15,
                                onPressed: () {
                                  setState(() {
                                    petIncludeCounter--;
                                    petAdded[petList[i]["index"]] = false;
                                    removePet.removeAt(i);
                                    petList.removeAt(i);
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: themeSettings.textColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    errorVisible = false;
                    postText = "Posting...";
                  });

                  if (!postController.text.isNotEmpty) {
                    setState(() {
                      errorText = "Cannot post without a message";
                      errorVisible = true;
                      postText = "Post";
                    });
                    return;
                  }

                  // Check if image is selected and moderate image
                  if (imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty) {
                    print("Image: ${imagePicker.filesNotifier.value![0].name}");
                    print("Image details: ${imagePicker.filesNotifier.value![0]}");
                    print("calling image filter");
                    Map<String, dynamic> moderationResult = await imageFilter.moderateImage(imagePicker.filesNotifier.value![0]);
                    print("Moderation result: $moderationResult");
                    //create dialog box for moderation
                    if (moderationResult['status'] == 'fail') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent, // Customize color if needed
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "🔞 Warning!",  // Title
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: themeSettings.textColor, // Customize text color
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                moderationResult['message'],  // Full message
                                style: TextStyle(color: themeSettings.textColor), // Customize text color
                              ),
                            ],
                          ),
                          duration: Duration(seconds: 20),  // Increase the duration if needed
                          behavior: SnackBarBehavior.floating,  // Makes the snackbar floating
                        ),
                      );
                      //prevent the post from being uploaded
                      setState(() {
                        errorText = "Inappropriate content detected";
                        errorVisible = true;
                        postText = "Post";
                        postController.clear();
                        imagePicker.clearCachedFiles();
                        petIncludeCounter = 0;
                        petList.clear();
                        petAdded.clear();
                        removePet.clear();
                        postText = "Post";
                      });
                      //stop image from being uploaded
                      return;
                    } else {
                      // Image is clean, proceed with uploading
                      // Proceed with uploading the image
                      print("Proceeding to upload image...");
                    }
                  } else {
                    setState(() {
                      errorText = "No image selected";
                      errorVisible = true;
                    });
                  }

                  List<Map<String, dynamic>> petIds = [];

                  if (petIncludeCounter > 0) {
                    for (int i = 0; i < petIncludeCounter; i++) {
                      petIds.add({'petId': petList[i]['petID'], 'name': petList[i]['name'], 'pictureUrl': petList[i]['pictureUrl']});
                    }
                  }

                  bool postAdded = false;

                  try {
                    postAdded = await homePageService.addPost(profileDetails.userID, imagePicker.filesNotifier.value![0], postController.text, petIds);
                  } catch (e) {
                    print("Error adding post: $e");

                    if (e.toString().contains("User has not verified their email address")) {
                      setState(() {
                        errorText = "Verify your email before you post";
                        errorVisible = true;
                        postText = "Post";
                      });
                    }
                    return;
                  }

                  if (postAdded) {
                    setState(() {
                      postController.clear();
                      imagePicker.clearCachedFiles();
                      petIncludeCounter = 0;
                      petList.clear();
                      petAdded.clear();
                      removePet.clear();
                      postText = "Post";
                    });

                    homepageVAF.postPosted.value = !homepageVAF.postPosted.value;
                  } else {
                    setState(() {
                      errorText = "An error occurred while posting";
                      errorVisible = true;
                      postText = "Post";
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    postText,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: errorVisible,
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
