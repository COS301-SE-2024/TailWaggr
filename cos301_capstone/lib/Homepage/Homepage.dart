// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Desktop_View.dart';
import 'package:cos301_capstone/Homepage/Mobile_View.dart';
import 'package:cos301_capstone/Homepage/Tablet_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:cos301_capstone/services/HomePage/home_page_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();

    void getPosts() async {
      Future<List<Map<String, dynamic>>> posts = HomePageService().getPosts();
      posts.then((value) {
        for (var post in value) {
          print(post);
        }
        setState(() {
          profileDetails.posts = value;
        });
      });
    }

    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: themeSettings,
        builder: (BuildContext context, Widget? child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1100) {
                return DesktopHomepage();
              } else if (constraints.maxWidth > 800) {
                return TabletHomepage();
              } else {
                return Scaffold(
                  drawer: NavbarDrawer(),
                  appBar: AppBar(
                    backgroundColor: themeSettings.primaryColor,
                    title: Text(
                      "TailWaggr",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  body: MobileHomepage(),
                );
              }
            },
          );
        },
      ),
    );
  }
}

/// Image Picker
/// This class allows the user to open up their file explorer to choose an image to upload.
/// The user can also clear the image that they have selected.
///
/// The image picker class includes the following functions:
/// - pickFiles: Opens the file explorer to choose an image to upload. The image is stored in the format of a PlatformFile.
/// - clearCachedFiles: Clears the image that the user has selected.
/// - logException: Logs an exception if an error occurs.
/// - resetState: Resets the state of the image picker.
class ImagePicker {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final defaultFileNameController = TextEditingController();
  final dialogTitleController = TextEditingController();
  final initialDirectoryController = TextEditingController();
  final fileExtensionController = TextEditingController();
  String? fileName;
  String? saveAsFileName;
  List<PlatformFile>? paths;
  String? directoryPath;
  String? extension;
  bool isLoading = false;
  bool lockParentWindow = false;
  bool userAborted = false;
  bool multiPick = false;
  FileType pickingType = FileType.image;

  ValueNotifier<List<PlatformFile>?> filesNotifier = ValueNotifier<List<PlatformFile>?>(null);

  void initState() {
    fileExtensionController.addListener(() => extension = fileExtensionController.text);
  }

  void pickFiles() async {
    resetState();
    try {
      directoryPath = null;
      paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: pickingType,
        allowMultiple: multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (extension?.isNotEmpty ?? false) ? extension?.replaceAll(' ', '').split(',') : null,
        dialogTitle: dialogTitleController.text,
        initialDirectory: initialDirectoryController.text,
        lockParentWindow: lockParentWindow,
      ))
          ?.files;

      filesNotifier.value = paths;
    } on PlatformException catch (e) {
      logException('Unsupported operation$e');
    } catch (e) {
      logException(e.toString());
    }
    isLoading = false;
    fileName = paths != null ? paths!.map((e) => e.name).toString() : '...';
    userAborted = paths == null;
  }

  void clearCachedFiles() async {
    resetState();

    filesNotifier.value = null;
  }

  void logException(String message) {
    print(message);
  }

  void resetState() {
    isLoading = true;
    directoryPath = null;
    fileName = null;
    paths = null;
    saveAsFileName = null;
    userAborted = false;
  }
}

ImagePicker imagePicker = ImagePicker();
