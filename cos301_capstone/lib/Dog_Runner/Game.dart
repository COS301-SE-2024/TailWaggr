import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:cos301_capstone/services/Leaderboard/leaderboard_service.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: themeSettings,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            // drawer: NavbarDrawer(),
            // appBar: AppBar(
            //   backgroundColor: themeSettings.primaryColor,
            //   title: Text(
            //     "TailWaggr",
            //     style: TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            body: GameView(),
          );
        },
      ),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // padding: EdgeInsets.all(20),
        color: themeSettings.backgroundColor,
        child: Row(
          children: [
            DesktopNavbar(),
            Container(
              width: MediaQuery.of(context).size.width - 290,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(20),
              child: WillPopScope(
                onWillPop: () async {
                  // Pop the category page if Android back button is pressed.
                  return true;
                },
                child: Stack(children: <Widget>[
                  UnityWidget(
                    borderRadius: BorderRadius.circular(20),
                    onUnityCreated: onUnityCreated,
                    onUnityMessage: onUnityMessage,
                    onUnitySceneLoaded: onUnitySceneLoaded,
                    fullscreen: false,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
    print("Score is: ${profileDetails.score}");
  }

  void onUnityMessage(message) {
    print("function running");
    print("Score is: ${profileDetails.score}");
    if(message == "Send Me"){
      _unityWidgetController?.postMessage(
        'FlutterMessenger',
        'ReceiveMe',
        profileDetails.name + "," + profileDetails.score.toString(),
      );
    }
    if (message == "Refresh the leaderboard") {
      print("leaderboard sent");
      sendLeaderboard();
    } else {
      try {
        print("score posting");
        int convertedScore = int.parse(message as String);
        LeaderboardService().setScore(profileDetails.userID, convertedScore);
      } catch (e) {
        print('Error with leaderboard submission: $e');
      }
    }
  }

  Future<void> sendLeaderboard() async {
    try {
      List<Map<String, dynamic>> leaderbord = await LeaderboardService().getTopScores(6);

      String leaderboardData = leaderbord.map((entry) {
        String name = entry['name'];
        int score = entry['score'];
        return "{'$name', $score}";
      }).join(', ');

      _unityWidgetController?.postMessage(
        'FlutterMessenger',
        'ReceiveLeaderboard',
        leaderboardData,
      );
    } catch (e) {
      print('Error with leaderboard retrieval leaderboard: $e');
    }
  }

  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      print('Received scene loaded from unity: ${sceneInfo.name}');
      print("Score is: ${profileDetails.score}");
      _unityWidgetController?.postMessage(
        'FlutterMessenger',
        'ReceiveMe',
        "${profileDetails.name},${profileDetails.score}",
      );
      print('Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
    }
  }
}
