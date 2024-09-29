import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({super.key, required this.postDetails, this.isTestMode = false});

  final Map<String, dynamic> postDetails;
  final bool isTestMode;

  String getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String formatDate() {
    DateTime date = postDetails["CreatedAt"];
    String month = getMonthAbbreviation(date.month);
    return "${date.day} $month ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(postDetails["pictureUrl"]),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postDetails["name"],
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
                const SizedBox(height: 20),
                Text(
                  postDetails["Content"] ?? 'No content',
                  style: TextStyle(
                    color: themeSettings.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
                const Spacer(),
                if (postDetails['PetIds'] != null && postDetails['PetIds'].isNotEmpty) ...[
                  Text(
                    "Pets included in this post: ",
                    style: TextStyle(
                      color: themeSettings.textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var pet in postDetails['PetIds']) ...[
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(pet["pictureUrl"]),
                                ),
                                const SizedBox(height: 5),
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
                const Spacer(),
                Row(
                  children: [
                    Tooltip(
                      message: "Like",
                      child: IconButton(
                        onPressed: () {
                          // Handle like button press
                        },
                        icon: Icon(
                          Icons.pets_outlined,
                          color: Colors.red.withOpacity(0.7),
                        ),
                      ),
                    ),
                    // Like count
                    Text(postDetails['numLikes'], style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                    const Spacer(),
                    Tooltip(
                      message: "Comment",
                      child: IconButton(
                        onPressed: () {
                          // Handle comment button press
                        },
                        icon: Icon(
                          Icons.comment,
                          color: Colors.blue.withOpacity(0.7),
                        ),
                      ),
                    ),
                    // Comment count
                    Text(postDetails['numComments'], style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                    const Spacer(),
                    Tooltip(
                      message: "Views",
                      child: Icon(
                        Icons.bar_chart,
                        color: Colors.green.withOpacity(0.7),
                      ),
                    ),
                    // View count
                    Text(postDetails['numViews'], style: TextStyle(color: themeSettings.textColor.withOpacity(0.7))),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),  // Space between content and image
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: isTestMode
                ? Container(
                    color: Colors.grey,
                    height: 300,
                  )
                : Image.network(
                    postDetails["ImgUrl"] ?? 'default_image_url',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }
}
