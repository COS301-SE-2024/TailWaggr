// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cos301_capstone/Edit_Profile/Edit_Profile.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Homepage/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditProfileMobile extends StatefulWidget {
  const EditProfileMobile({super.key});

  @override
  State<EditProfileMobile> createState() => _EditProfileMobileState();
}

class _EditProfileMobileState extends State<EditProfileMobile> {
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
        title: Text(
          "Edit Profile",
          style: TextStyle(color: themeSettings.primaryColor, fontSize: 20),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.only(bottom: 60, top: 5),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DefaultTabController(
            initialIndex: 0,
            length: 3,
            child: Column(
              children: [
                TabBar(
                  labelColor: secondaryColor,
                  indicatorColor: secondaryColor,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Icon(Icons.pets),
                    ),
                    Tab(
                      child: Icon(Icons.palette),
                    ),
                    Tab(
                      child: Icon(Icons.menu),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: TabBarView(
                    children: [
                      UpdatePersonalDetails(),
                      UpdateTheme(),
                      UpdateNavbar(),
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

class UpdatePersonalDetails extends StatefulWidget {
  const UpdatePersonalDetails({super.key});

  @override
  State<UpdatePersonalDetails> createState() => _UpdatePersonalDetailsState();
}

class _UpdatePersonalDetailsState extends State<UpdatePersonalDetails> {
  bool isDatePickerVisible = false;
  bool isPhoneValid = true;

  ImagePicker imagePickerLocal = ImagePicker();

  @override
  void initState() {
    super.initState();
    imagePickerLocal.filesNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                imagePickerLocal.pickFiles();
              },
              child: CircleAvatar(
                radius: 75,
                backgroundImage: imagePickerLocal.filesNotifier.value != null && imagePickerLocal.filesNotifier.value!.isNotEmpty
                    ? MemoryImage(imagePickerLocal.filesNotifier.value![0].bytes!)
                    : NetworkImage(profileDetails.profilePicture) as ImageProvider,
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: EditProfileVariables.nameController,
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(
              color: themeSettings.textColor,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: EditProfileVariables.surnameController,
            decoration: InputDecoration(
              labelText: "Surname",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(
              color: themeSettings.textColor,
            ),
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
              profileDetails.dialCode = number.dialCode!;
              profileDetails.isoCode = number.isoCode!;
              profileDetails.phone = number.phoneNumber!;
            },
            onInputValidated: (bool value) {
              print("Validating phone number: $value");
              if (value != isPhoneValid) {
                setState(() {
                  isPhoneValid = value;
                });
              }
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              useBottomSheetSafeArea: true,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.onUserInteraction,
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
          TextField(
            controller: EditProfileVariables.birthdateController,
            decoration: InputDecoration(
              labelText: "Birth Date",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  setState(() {
                    isDatePickerVisible = !isDatePickerVisible;
                  });
                },
              ),
            ),
            style: TextStyle(
              color: themeSettings.textColor,
            ),
            onChanged: (value) {
              EditProfileVariables.birthdateController.text = profileDetails.birthdate;
            },
            // enabled: false,
          ),
          SizedBox(height: 20),
          Visibility(
            visible: isDatePickerVisible,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: themeSettings.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SfDateRangePickerTheme(
                  data: SfDateRangePickerThemeData(
                    activeDatesTextStyle: TextStyle(color: themeSettings.textColor),
                    headerTextStyle: TextStyle(color: themeSettings.primaryColor),
                    selectionColor: themeSettings.secondaryColor,
                    todayTextStyle: TextStyle(color: themeSettings.primaryColor),
                    weekNumberTextStyle: TextStyle(color: themeSettings.primaryColor),
                    viewHeaderTextStyle: TextStyle(color: themeSettings.primaryColor),
                    cellTextStyle: TextStyle(color: themeSettings.textColor),
                    todayCellTextStyle: TextStyle(color: themeSettings.primaryColor),
                  ),
                  child: SfDateRangePicker(
                    backgroundColor: themeSettings.cardColor,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      profileDetails.birthdate = args.value.toString();
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialDisplayDate: DateTime.now(),
                    showActionButtons: true,
                    confirmText: "Select",
                    cancelText: "Cancel",
                    headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: themeSettings.cardColor,
                      textAlign: TextAlign.center,
                    ),
                    todayHighlightColor: themeSettings.primaryColor,
                    showNavigationArrow: true,
                    onSubmit: (p0) {
                      EditProfileVariables.setBirthDateControllers(p0);
                      setState(() {
                        isDatePickerVisible = false;
                      });
                    },
                    onCancel: () {
                      setState(() {
                        EditProfileVariables.birthdateController.text = profileDetails.birthdate;
                        isDatePickerVisible = false;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isDatePickerVisible,
            child: SizedBox(height: 20),
          ),
          Column(
            children: [
              Text("Profile Visibility", style: TextStyle(color: themeSettings.textColor, fontSize: 14)),
              ListTile(
                title: Text('Public', style: TextStyle(color: themeSettings.textColor)),
                leading: Radio<bool>(
                  value: true,
                  fillColor: WidgetStateProperty.all(themeSettings.primaryColor),
                  groupValue: profileDetails.isPublic,
                  onChanged: (bool? value) {
                    setState(() {
                      profileDetails.isPublic = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Private', style: TextStyle(color: themeSettings.textColor)),
                leading: Radio<bool>(
                  value: false,
                  fillColor: WidgetStateProperty.all(themeSettings.primaryColor),
                  groupValue: profileDetails.isPublic,
                  onChanged: (bool? value) {
                    setState(() {
                      profileDetails.isPublic = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text("User Type", style: TextStyle(color: themeSettings.textColor, fontSize: 14)),
              ListTile(
                title: Text('Pet Enthusiast', style: TextStyle(color: themeSettings.textColor)),
                leading: Radio<String>(
                  value: "pet_owner",
                  fillColor: WidgetStateProperty.all(themeSettings.primaryColor),
                  groupValue: profileDetails.userType,
                  onChanged: (String? value) {
                    setState(() {
                      profileDetails.userType = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Pet Sitter', style: TextStyle(color: themeSettings.textColor)),
                leading: Radio<String>(
                  value: "PetSitter",
                  fillColor: WidgetStateProperty.all(themeSettings.primaryColor),
                  groupValue: profileDetails.userType,
                  onChanged: (String? value) {
                    setState(() {
                      profileDetails.userType = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: !isPhoneValid
                ? () {
                    print("Phone number is invalid");
                  }
                : () async {
                    await EditProfileVariables.updatePersonalDetails(context, imagePickerLocal);
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
      child: Column(
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
                  style: TextStyle(color: themeSettings.textColor),
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
                    onPressed: () async {
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
                      await EditProfileVariables.setNavbarPreferences(profileDetails.usingImage, profileDetails.usingDefaultImage);
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: themeSettings.textColor, fontSize: bodyTextSize),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  themeModeSelector = changeNotifier;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
              ),
              child: Text(
                "Change",
                style: TextStyle(
                  fontSize: bodyTextSize,
                  color: themeSettings.cardColor,
                ),
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
              themeSettingRow("Background Colour", backgroundColor, "BackgroundColour"),
              themeSettingRow("Text Colour", textColor, "TextColour"),
              themeSettingRow("Card Colour", cardColor, "CardColour"),

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

class UpdateNavbar extends StatefulWidget {
  const UpdateNavbar({super.key});

  @override
  State<UpdateNavbar> createState() => _UpdateNavbarState();
}

class _UpdateNavbarState extends State<UpdateNavbar> {
  bool useImage = true;
  bool useDefaultImage = true;
  bool viewNavbar = true;
  bool navbarTextColourSelector = false;
  TextEditingController changeColourtextController = TextEditingController();
  String saveChangesText = "Save Changes";

  void updateTextController(Color color) {
    changeColourtextController.text = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Widget changeColour() {
    void changeColor(Color newColor) {
      setState(() {
        updateTextController(newColor);
        navbarTextColor = newColor;
      });

      setState(() {
        useImage = profileDetails.usingImage;
        useDefaultImage = profileDetails.usingDefaultImage;
      });
    }

    void copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
    }

    // Ensure text controller is updated with the current color value
    updateTextController(navbarTextColor);

    return Container(
      decoration: BoxDecoration(
        color: themeSettings.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            width: 280,
            height: 320,
            child: ColorPicker(
              pickerColor: navbarTextColor,
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
                  style: TextStyle(color: themeSettings.textColor),
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
                Text("Text Example", style: TextStyle(color: navbarTextColor, fontSize: bodyTextSize)),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        navbarTextColor = themeSettings.navbarTextColour;
                        themeModeNotifier.value++;
                        navbarTextColourSelector = false;
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
                    onPressed: () async {
                      setState(() {
                        // themeSettings.setNavbarTextColor(navbarTextColor);
                        themeModeNotifier.value++;
                        navbarTextColourSelector = false;
                        saveChangesText = "Saving...";
                      });
                      await EditProfileVariables.setNavbarPreferences(profileDetails.usingImage, profileDetails.usingDefaultImage);
                      setState(() {
                        saveChangesText = "Save Changes";
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    child: Text(
                      saveChangesText,
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

  @override
  void initState() {
    super.initState();
    imagePicker.filesNotifier.addListener(() {
      setState(() {}); // Rebuild the widget when files are selected
    });

    setState(() {
      useImage = profileDetails.usingImage;
      useDefaultImage = profileDetails.usingDefaultImage;
    });
  }

  String errorText = "";
  bool errorVisible = false;
  String postText = "Post";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ToggleSwitch(
                minWidth: double.infinity,
                cornerRadius: 20.0,
                activeBgColors: [
                  [primaryColor],
                  [secondaryColor]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: viewNavbar ? 0 : 1,
                totalSwitches: 2,
                labels: ['View', 'Edit'],
                radiusStyle: true,
                animate: true,
                curve: Curves.easeInOut, // animate must be set to true when using custom curve
                animationDuration: 200,
                onToggle: (index) {
                  print('switched to: $index');
                  setState(() {
                    viewNavbar = index == 0;
                  });
                },
              ),
              SizedBox(height: 20),
              if (viewNavbar) ...[
                Container(
                  width: 175,
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height - 350,
                  decoration: useImage
                      ? !useDefaultImage
                          ? imagePicker.filesNotifier.value != null && imagePicker.filesNotifier.value!.isNotEmpty
                              ? BoxDecoration(image: DecorationImage(image: MemoryImage(imagePicker.filesNotifier.value![0].bytes!), fit: BoxFit.cover))
                              : BoxDecoration(image: DecorationImage(image: NetworkImage(profileDetails.sidebarImage), fit: BoxFit.cover))
                          : BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/pug.jpg"), fit: BoxFit.cover))
                      : BoxDecoration(color: primaryColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                themeSettings.navbarTextColour,
                                BlendMode.srcIn,
                              ),
                              child: Image.asset(width: 100, 'assets/images/Logo_transparent.png'),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.home, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Home", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.notifications, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Notifications", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.event, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Events", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.map_sharp, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Locate", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.pets, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Lost and Found", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.search, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Friends", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.forum_outlined, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Forums", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.person_outline, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Profile", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.gamepad, color: navbarTextColor),
                              SizedBox(width: 10),
                              Text("Pet Runner", style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(profileDetails.profilePicture),
                              ),
                              SizedBox(width: 10),
                              Text(profileDetails.name, style: TextStyle(color: navbarTextColor, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Use image", style: TextStyle(color: themeSettings.primaryColor, fontSize: bodyTextSize)),
                        Switch(
                          value: useImage,
                          activeColor: themeSettings.primaryColor,
                          inactiveThumbColor: themeSettings.secondaryColor,
                          onChanged: (value) => setState(() => useImage = value),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (useImage) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Use default image", style: TextStyle(color: themeSettings.secondaryColor, fontSize: bodyTextSize)),
                          Switch(
                            value: useDefaultImage,
                            activeColor: themeSettings.primaryColor,
                            inactiveThumbColor: themeSettings.secondaryColor,
                            onChanged: (value) => setState(() => useDefaultImage = value),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Visibility(
                        visible: !useDefaultImage,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.transparent),
                          margin: EdgeInsets.only(bottom: 20),
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
                                      "Change background",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Navbar text colour", style: TextStyle(color: themeSettings.primaryColor, fontSize: bodyTextSize)),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              navbarTextColourSelector = true;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(primaryColor),
                            textStyle: WidgetStateProperty.all(TextStyle(color: themeSettings.textColor)),
                          ),
                          child: Text(
                            "Change",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          print("Saving changes");
                          setState(() {
                            profileDetails.usingImage = useImage;
                            profileDetails.usingDefaultImage = useDefaultImage;
                            saveChangesText = "Saving...";
                          });
                          await EditProfileVariables.setNavbarPreferences(useImage, useDefaultImage);
                          setState(() {
                            saveChangesText = "Save Changes";
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(primaryColor),
                        ),
                        child: Text(
                          saveChangesText,
                          style: TextStyle(
                            fontSize: bodyTextSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (navbarTextColourSelector) ...[
          Positioned(
            child: changeColour(),
          ),
        ]
      ],
    );
  }
}
