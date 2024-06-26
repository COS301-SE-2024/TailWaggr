// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

ValueNotifier<int> themeModeNotifier = ValueNotifier<int>(0);
Color primaryColor = themeSettings.primaryColor;
Color secondaryColor = themeSettings.secondaryColor;
Color backgroundColor = themeSettings.backgroundColor;
Color textColor = themeSettings.textColor;
Color cardColor = themeSettings.cardColor;

class EditProfileDesktop extends StatefulWidget {
  const EditProfileDesktop({super.key});

  @override
  State<EditProfileDesktop> createState() => _EditProfileDesktopState();
}

class _EditProfileDesktopState extends State<EditProfileDesktop> {
  @override
  void initState() {
    super.initState();
    themeModeNotifier.addListener(_onThemeModeChanged);
  }

  @override
  void dispose() {
    themeModeNotifier.removeListener(_onThemeModeChanged);
    super.dispose();
  }

  void _onThemeModeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Center(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.only(bottom: 60, top: 5),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DefaultTabController(
            initialIndex: 1,
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: secondaryColor,
                  indicatorColor: secondaryColor,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pets),
                          SizedBox(width: 10),
                          Text("Edit Profile"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.palette),
                          SizedBox(width: 10),
                          Text("Edit Theme"),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: TabBarView(
                    children: [
                      UpdatePersonalDetails(),
                      UpdateTheme(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdatePersonalDetails extends StatelessWidget {
  const UpdatePersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  try {} catch (e) {
                    print("Error: $e");
                  }
                },
                child: CircleAvatar(
                  radius: 75,
                  // backgroundImage: AssetImage("assets/images/profile.jpg"),
                  backgroundImage: NetworkImage(profileDetails.profilePicture),
                ),
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 370,
                    child: TextField(
                      controller: EditProfileVariables.nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        color: themeSettings.textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 370,
                    child: TextField(
                      controller: EditProfileVariables.surnameController,
                      decoration: InputDecoration(
                        labelText: "Surname",
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        color: themeSettings.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: EditProfileVariables.bioController,
            decoration: InputDecoration(
              labelText: "Bio",
              border: OutlineInputBorder(),
            ),
            maxLines: null, // Allow the field to expand
            style: TextStyle(
              color: themeSettings.textColor,
            ),
          ),
          SizedBox(height: 20),
          InternationalPhoneNumberInput(
            textStyle: TextStyle(
              color: themeSettings.textColor,
            ),
            onInputChanged: (PhoneNumber number) {
              // print(number.phoneNumber);
            },
            onInputValidated: (bool value) {
              // print(value);
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              useBottomSheetSafeArea: true,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            // selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: PhoneNumber(
              dialCode: profileDetails.dialCode,
              isoCode: profileDetails.isoCode,
              phoneNumber: profileDetails.phone,
            ),
            textFieldController: EditProfileVariables.phoneController,
            formatInput: true,
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            inputBorder: OutlineInputBorder(
              borderSide: BorderSide(
                // color: Colors.transparent,
                width: 0,
              ),
            ),
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: EditProfileVariables.addressController,
            decoration: InputDecoration(
              labelText: "Address",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(
              color: themeSettings.textColor,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              profileDetails.name = EditProfileVariables.nameController.text;
              profileDetails.surname = EditProfileVariables.surnameController.text;
              profileDetails.bio = EditProfileVariables.bioController.text;
              profileDetails.location = EditProfileVariables.addressController.text;
              profileDetails.isEditing.value++;
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
            ),
            child: Text(
              "Save Changes",
              style: TextStyle(
                fontSize: bodyTextSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateTheme extends StatefulWidget {
  const UpdateTheme({super.key});

  @override
  State<UpdateTheme> createState() => _UpdateThemeState();
}

class _UpdateThemeState extends State<UpdateTheme> {
  String themeModeSelector = "";

  TextEditingController changeColourtextController = TextEditingController();

  void updateTextController(Color color) {
    changeColourtextController.text = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Widget changeColour() {
    void changeColor(Color newColor) {
      setState(() {
        updateTextController(newColor);
        switch (themeModeSelector) {
          case "PrimaryColour":
            primaryColor = newColor;
            // themeSettings.setPrimaryColor(newColor);
            themeModeNotifier.value++;
            break;
          case "SecondaryColour":
            secondaryColor = newColor;
            // themeSettings.setSecondaryColor(newColor);
            themeModeNotifier.value++;
            break;
          case "BackgroundColour":
            backgroundColor = newColor;
            // themeSettings.setBackgroundColor(newColor);
            themeModeNotifier.value++;
            break;
          case "TextColour":
            textColor = newColor;
            // themeSettings.setTextColor(newColor);
            themeModeNotifier.value++;
            break;
          case "CardColour":
            cardColor = newColor;
            // themeSettings.setCardColor(newColor);
            themeModeNotifier.value++;
            break;
          default:
            break;
        }
      });
    }

    void copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
    }

    Color getColour() {
      switch (themeModeSelector) {
        case "PrimaryColour":
          return primaryColor;
        case "SecondaryColour":
          return secondaryColor;
        case "BackgroundColour":
          return backgroundColor;
        case "TextColour":
          return textColor;
        case "CardColour":
          return cardColor;
        default:
          return Colors.white;
      }
    }

    // Ensure text controller is updated with the current color value
    updateTextController(getColour());

    return Container(
      decoration: BoxDecoration(
        color: themeSettings.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 280,
            height: 320,
            child: ColorPicker(
              pickerColor: getColour(),
              onColorChanged: changeColor,
              colorPickerWidth: 300,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              labelTypes: const [],
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              hexInputController: changeColourtextController,
              portraitOnly: true,
            ),
          ),
          Spacer(),
          Container(
            width: 240,
            height: 320,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: changeColourtextController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.tag),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.content_paste_rounded),
                      onPressed: () => copyToClipboard(changeColourtextController.text),
                    ),
                  ),
                  autofocus: true,
                  maxLength: 9,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
                  ],
                ),
                Text("Text Example", style: TextStyle(color: getColour(), fontSize: bodyTextSize)),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: getColour(),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "Button Example",
                      style: TextStyle(color: Colors.white, fontSize: textSize),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        primaryColor = themeSettings.primaryColor;
                        secondaryColor = themeSettings.secondaryColor;
                        backgroundColor = themeSettings.backgroundColor;
                        textColor = themeSettings.textColor;
                        cardColor = themeSettings.cardColor;
                        themeModeSelector = "";
                        themeModeNotifier.value++;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(BorderSide(color: secondaryColor, width: 2)),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: bodyTextSize,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        switch (themeModeSelector) {
                          case "PrimaryColour":
                            print("Setting primary color to: $primaryColor");
                            themeSettings.setPrimaryColor(primaryColor);
                            themeModeSelector = "";
                            break;
                          case "SecondaryColour":
                            themeSettings.setSecondaryColor(secondaryColor);
                            themeModeSelector = "";
                            break;
                          case "BackgroundColour":
                            themeSettings.setBackgroundColor(backgroundColor);
                            themeModeSelector = "";
                            break;
                          case "TextColour":
                            themeSettings.setTextColor(textColor);
                            themeModeSelector = "";
                            break;
                          case "CardColour":
                            themeSettings.setCardColor(cardColor);
                            themeModeSelector = "";
                            break;
                          default:
                            break;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: bodyTextSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget themeSettingRow(String title, Color color, String changeNotifier) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontSize: bodyTextSize),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                themeModeSelector = changeNotifier;
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(color),
            ),
            child: Text(
              "Change",
              style: TextStyle(
                fontSize: bodyTextSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              themeSettingRow("Primary Colour", primaryColor, "PrimaryColour"),
              themeSettingRow("Secondary Colour", secondaryColor, "SecondaryColour"),
              themeSettingRow("Background Colour", textColor, "BackgroundColour"),
              themeSettingRow("Text Colour", textColor, "TextColour"),
              themeSettingRow("Card Colour", textColor, "CardColour"),

              // Add more color change buttons as needed
            ],
          ),
        ),
        if (themeModeSelector != "") ...[
          Positioned(
            child: changeColour(),
          ),
        ]
      ],
    );
  }
}
