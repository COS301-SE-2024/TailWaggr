// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:animations/animations.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Desktop_View.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/HomePage/home_page_service.dart';
import 'package:cos301_capstone/services/Profile/profile_service.dart';
import 'package:cos301_capstone/services/general/general_service.dart';
import 'package:cos301_capstone/services/imageApi/imageFilter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> uploadPostContainerOpen = ValueNotifier(true);

class TabletHomepage extends StatefulWidget {
  const TabletHomepage({super.key});

  @override
  State<TabletHomepage> createState() => _TabletHomepageState();
}

class _TabletHomepageState extends State<TabletHomepage> {
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
  @override
  void initState() {
    super.initState();
    uploadPostContainerOpen.addListener(() {
      setState(() {});
    });

    Future<void> getPosts() async {
      Future<List<Map<String, dynamic>>> posts = HomePageService().getPosts();
      posts.then((value) {
        setState(() {
          profileDetails.posts = value;
        });
      });
    }

    homepageVAF.postPosted.addListener(() async {
      await getPosts();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 290),
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeSettings.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                for (int i = 0; i < profileDetails.posts.length; i++) ...{
                  Post(postDetails: profileDetails.posts[i]),
                  Divider(),
                },
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: OpenContainer(
              closedBuilder: (BuildContext context, void Function() action) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, color: Colors.white),
                );
              },
              closedColor: themeSettings.primaryColor,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              openBuilder: (BuildContext context, void Function() action) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: themeSettings.primaryColor,
                    iconTheme: IconThemeData(color: Colors.white),
                    title: Text(
                      "Upload Post",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  body: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: themeSettings.backgroundColor,
                    padding: EdgeInsets.all(20),
                    child: UploadPostContainer(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
  final HomePageService _homePageService = HomePageService();

  @override
  void initState() {
    super.initState();
    getLikes();
    getViews();
    getCommentCount();
    getUser();
  }

  void getUser() {
    homePageService.getUserDetails(widget.postDetails['UserId']).then((value) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        widget.postDetails['name'] = value['name'] + ' ' + value['surname'];
        widget.postDetails['pictureUrl'] = value['profilePictureUrl'];
      });
    });
  }

  void getLikes() async {
    Future<int> likes = HomePageService().getLikesCount(widget.postDetails['PostId']);
    likes.then((value) {
      setState(() {
        numLikes = value.toString();
      });
    });
  }

  void getViews() async {
    HomePageService().addViewToPost(widget.postDetails['PostId'], profileDetails.userID);
    Future<int> views = HomePageService().getViewsCount(widget.postDetails['PostId']);
    views.then((value) {
      setState(() {
        numViews = value.toString();
      });
    });
  }

  void getCommentCount() async {
    Future<int> commentCount = HomePageService().getCommentsCount(widget.postDetails['PostId']);
    commentCount.then((value) {
      setState(() {
        numComments = value.toString();
      });
    });
  }

  Future<List<Map<String, dynamic>>> getComments() async {
    List<Map<String, dynamic>> commentsList = await HomePageService().getComments(widget.postDetails['PostId']);
    for (int i = 0; i < commentsList.length; i++) {
      Map<String, dynamic> comment = commentsList[i];
      Map<String, dynamic>? profileDetails = await ProfileService().getUserDetails(comment['userId']);
      // print("Profile Details: $profileDetails");
      comment['name'] = profileDetails!['name'];
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
                              return Text("Error loading comments");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text("No comments available");
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
    return IntrinsicHeight(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.postDetails["pictureUrl"]),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                Spacer(),
                if (widget.postDetails['UserId'] == profileDetails.userID) ...{
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: themeSettings.textColor),
                    color: themeSettings.backgroundColor,
                    onSelected: (String result) async {
                      if (result == 'delete') {
                        // Add your delete post logic here
                        bool deleted = await homePageService.deletePost(widget.postDetails['PostId']);
                        if (deleted) {
                          setState(() {
                            profileDetails.posts.removeWhere((post) => post['PostId'] == widget.postDetails['PostId']);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Post deleted successfully'),
                            ),
                          );

                          homepageVAF.postPosted.value = !homepageVAF.postPosted.value;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Failed to delete post'),
                            ),
                          );
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 10),
                            Text('Delete Post', style: TextStyle(color: themeSettings.textColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                },
              ],
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.postDetails["ImgUrl"],
                width: MediaQuery.of(context).size.width,
                // height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.postDetails["Content"],
              style: TextStyle(
                color: themeSettings.textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
            SizedBox(height: 20),
            if (widget.postDetails['PetIds'].length != 0) ...[
              Text(
                "Pets included in this post: ",
                style: TextStyle(
                  color: themeSettings.textColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 10),
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
                              backgroundImage: NetworkImage(pet["pictureUrl"]),
                            ),
                            SizedBox(height: 5),
                            Text(
                              pet["name"],
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
            SizedBox(height: 20),
            Row(
              children: [
                Tooltip(
                  message: "Like",
                  child: IconButton(
                    onPressed: () {
                      HomePageService().toggleLikeOnPost(widget.postDetails['PostId'], profileDetails.userID);

                      HomePageService().getLikesCount(widget.postDetails['PostId']).then((value) {
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
                Text(numLikes, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                Spacer(),
                Tooltip(
                  message: "Comment",
                  child: IconButton(
                    onPressed: () {
                      showDialogBox(context);
                      HomePageService().getCommentsCount(widget.postDetails['PostId']).then((value) {
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
                Spacer(),
                Tooltip(
                  message: "Views",
                  child: Icon(
                    Icons.bar_chart,
                    color: Colors.green.withOpacity(0.7),
                  ),
                ),
                Text(numViews, style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
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
    imagePicker.filesNotifier.addListener(() {
      setState(() {}); // Rebuild the widget when files are selected
    });

    uploadPostContainerOpen.addListener(() {
      setState(() {});
    });

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
  }

  String errorText = "";
  bool errorVisible = false;
  String postText = "Post";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 450) * 0.5,
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
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => imagePicker.pickFiles(),
                  child: Container(
                    key: Key('add-photo-button'),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
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
                            width: (MediaQuery.of(context).size.width - 590) * 0.55,
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
                                                  overflow: TextOverflow.ellipsis,
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

                  print("---------------------------------------");
                  print("Post Details: ");

                  if (postController.text.isNotEmpty) {
                    print("Post text: ${postController.text}");
                  } else {
                    print("Cannot post without a message");
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
                                "🔞 Warning!", // Title
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: themeSettings.textColor, // Customize text color
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                moderationResult['message'], // Full message
                                style: TextStyle(color: themeSettings.textColor), // Customize text color
                              ),
                            ],
                          ),
                          duration: Duration(seconds: 20), // Increase the duration if needed
                          behavior: SnackBarBehavior.floating, // Makes the snackbar floating
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
                    print("No image selected");
                    setState(() {
                      errorText = "No image selected";
                      errorVisible = true;
                    });
                  }

                  List<Map<String, dynamic>> petIds = [];

                  if (petIncludeCounter > 0) {
                    print("Pets included: ");
                    for (int i = 0; i < petIncludeCounter; i++) {
                      petIds.add({'petId': petList[i]['petID'], 'name': petList[i]['name'], 'pictureUrl': petList[i]['pictureUrl']});
                    }
                  } else {
                    print("No pets included");
                  }

                  print("---------------------------------------");

                  bool postAdded = await HomePageService().addPost(profileDetails.userID, imagePicker.filesNotifier.value![0], postController.text, petIds);

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

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Post uploaded successfully'),
                      ),
                    );

                    Navigator.pop(context);
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
