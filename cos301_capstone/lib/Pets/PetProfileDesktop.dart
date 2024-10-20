// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Pets/Pet_Profile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PetProfileDesktop extends StatefulWidget {
  const PetProfileDesktop({
    super.key,
    required this.creatingNewPet,
  });

  final bool creatingNewPet;

  @override
  State<PetProfileDesktop> createState() => _PetProfileDesktopState();
}

class _PetProfileDesktopState extends State<PetProfileDesktop> {
  bool isDatePickerVisible = false;
  String creatingNewPetText = "Create Your Pet's Profile";
  bool isCreateButtonDisabled = false;

  String edittingPetText = "Update Your Pet's Profile";
  bool usingNewImage = false;

  String removePetText = 'Remove Pet Profile';

  String originalPetBirthday = '';

  void showCustomSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        message,
        style: TextStyle(color: themeSettings.textColor),
        textAlign: TextAlign.center,
      ),
    );

    // Display the snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool?> showConfirmationDialog(BuildContext context, String name) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeSettings.cardColor,
          title: SizedBox(
            width: 450,
            child: Text('Are you sure you wish to remove $name from your family?', style: TextStyle(color: themeSettings.textColor)),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(themeSettings.cardColor),
                backgroundColor: WidgetStateProperty.all(themeSettings.cardColor),
                side: WidgetStateProperty.all(BorderSide(color: themeSettings.secondaryColor)),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel', style: TextStyle(color: themeSettings.textColor)),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                side: WidgetStateProperty.all(BorderSide(color: themeSettings.primaryColor)),
              ),
              child: Text('Confirm', style: TextStyle(color: themeSettings.textColor)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    PetProfileVariables.imagePicker.filesNotifier.addListener(() {
      setState(() {});
    });

    if (!widget.creatingNewPet) {
      originalPetBirthday = PetProfileVariables.birthdateController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSettings.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeSettings.backgroundColor,
        iconTheme: IconThemeData(color: themeSettings.primaryColor),
      ),
      body: Center(
        child: Container(
          width: 600,
          // height: 600,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeSettings.cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.creatingNewPet ? "Create Your Pet's Profile" : "Update Your Pet's Profile",
                  style: TextStyle(color: themeSettings.primaryColor, fontSize: subtitleTextSize),
                ),
                if (widget.creatingNewPet) ...[
                  Text(
                    "Please fill in the details below to create your pet's profile",
                    style: TextStyle(
                      color: themeSettings.textColor,
                      fontSize: bodyTextSize,
                    ),
                  ),
                ],
                SizedBox(height: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      PetProfileVariables.imagePicker.pickFiles();
                    },
                    child: widget.creatingNewPet
                        // When creating a new pet
                        ? PetProfileVariables.imagePicker.filesNotifier.value != null && PetProfileVariables.imagePicker.filesNotifier.value!.isNotEmpty
                            // If there is an image selected
                            ? CircleAvatar(
                                radius: 75,
                                backgroundImage: MemoryImage(PetProfileVariables.imagePicker.filesNotifier.value![0].bytes!),
                              )
                            // If there is no image selected
                            : Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: themeSettings.primaryColor),
                                ),
                                child: Icon(Icons.add_a_photo, color: themeSettings.textColor),
                              )
                        // When updating an existing pet
                        : PetProfileVariables.imagePicker.filesNotifier.value != null && PetProfileVariables.imagePicker.filesNotifier.value!.isNotEmpty
                            // If there is a new image selected
                            ? CircleAvatar(
                                radius: 75,
                                backgroundImage: MemoryImage(PetProfileVariables.imagePicker.filesNotifier.value![0].bytes!),
                              )
                            // If there is no new image selected
                            : CircleAvatar(
                                radius: 75,
                                backgroundImage: NetworkImage(PetProfileVariables.profilePicture!),
                              ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: PetProfileVariables.nameController,
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
                  controller: PetProfileVariables.bioController,
                  decoration: InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: themeSettings.textColor,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: PetProfileVariables.birthdateController,
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
                    PetProfileVariables.birthdateController.text = originalPetBirthday;
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
                            PetProfileVariables.birthdateController.text = args.value.toString();
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
                            PetProfileVariables.setBirthDateControllers(p0);
                            setState(() {
                              isDatePickerVisible = false;
                            });
                          },
                          onCancel: () {
                            setState(() {
                              PetProfileVariables.birthdateController.text = PetProfileVariables.birthdateController.text;
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
                if (widget.creatingNewPet) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (PetProfileVariables.nameController.text.isEmpty || PetProfileVariables.bioController.text.isEmpty || PetProfileVariables.birthdateController.text.isEmpty) {
                            showCustomSnackBar(context, 'Please make sure all fields are filled in', Colors.red);
                            return;
                          }

                          if (PetProfileVariables.imagePicker.filesNotifier.value == null || PetProfileVariables.imagePicker.filesNotifier.value!.isEmpty) {
                            showCustomSnackBar(context, 'Please select an image for your pet', Colors.red);
                            return;
                          }

                          if (isCreateButtonDisabled) {
                            showCustomSnackBar(context, 'Pet is already aparrt of your family', Colors.orange);
                            return;
                          }

                          setState(() {
                            isCreateButtonDisabled = true;
                            creatingNewPetText = 'Creating Pet Profile...';
                          });

                          await PetProfileVariables.createPet();

                          showCustomSnackBar(context, 'Sucessfully created your pets profile', Colors.green);

                          Navigator.pop(context);

                          return;
                        } catch (e) {
                          print('Error creating pet profile: $e');
                          showCustomSnackBar(context, 'Error creating pet profile', Colors.red);
                          setState(() {
                            isCreateButtonDisabled = false;
                          });
                        } finally {
                          setState(() {
                            creatingNewPetText = "Create Your Pet's Profile";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeSettings.primaryColor,
                      ),
                      child: Text(creatingNewPetText, style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      SizedBox(
                        width: 270,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              bool? result = await showConfirmationDialog(context, PetProfileVariables.nameController.text);

                              if (result == null || !result) {
                                return;
                              }

                              setState(() {
                                removePetText = 'Removing Pet Profile...';
                              });

                              await PetProfileVariables.deletePet();

                              showCustomSnackBar(context, "Pet removed from profile, We are sorry to see ${PetProfileVariables.nameController.text} go.", Colors.green);
                              
                              Navigator.pop(context);
                              
                              return;
                            } catch (e) {
                              print('Error removing pet profile: $e');
                              showCustomSnackBar(context, 'Error removing pet profile', Colors.red);
                            } finally {
                              setState(() {
                                removePetText = 'Remove Pet Profile';
                              });
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(themeSettings.cardColor),
                            backgroundColor: WidgetStateProperty.all(themeSettings.cardColor),
                            side: WidgetStateProperty.all(BorderSide(color: themeSettings.secondaryColor)),
                          ),
                          child: Text(removePetText, style: TextStyle(color: themeSettings.textColor)),
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 270,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              if (PetProfileVariables.nameController.text.isEmpty || PetProfileVariables.bioController.text.isEmpty || PetProfileVariables.birthdateController.text.isEmpty) {
                                showCustomSnackBar(context, 'Please make sure all fields are filled in', Colors.red);
                                return;
                              }

                              setState(() {
                                edittingPetText = 'Updating Pet Profile...';
                              });

                              if (PetProfileVariables.imagePicker.filesNotifier.value != null && PetProfileVariables.imagePicker.filesNotifier.value!.isNotEmpty) {
                                setState(() {
                                  usingNewImage = true;
                                });
                              }

                              await PetProfileVariables.updatePet(usingNewImage);

                              showCustomSnackBar(context, 'Sucessfully updated your pets profile', Colors.green);
                              
                              Navigator.pop(context);
                              
                              return;
                            } catch (e) {
                              print('Error creating pet profile: $e');
                              showCustomSnackBar(context, 'Error creating pet profile', Colors.red);
                            } finally {
                              setState(() {
                                edittingPetText = "Update Your Pet's Profile";
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeSettings.primaryColor,
                          ),
                          child: Text(edittingPetText, style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
