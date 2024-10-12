// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/services/lostAndFound/lostAndFound.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LostAndFoundMobile extends StatefulWidget {
  const LostAndFoundMobile({super.key});

  @override
  State<LostAndFoundMobile> createState() => _LostAndFoundMobileState();
}

class _LostAndFoundMobileState extends State<LostAndFoundMobile> {
  late GoogleMapController _googleMapController;
  late TextEditingController searchDistanceController;
  String applyFiltersButtonText = "Apply Filters";
  String reportSightingText = "Report Sighting";

  bool fetchingPets = false;

  List<Pet> pets = [];

  final List<Marker> markers = [];

  ValueNotifier<int> selectedPet = ValueNotifier<int>(-1);
  ValueNotifier<GeoPoint> selectedLocation = ValueNotifier<GeoPoint>(GeoPoint(0, 0));

  bool mapControllerLoaded = false;

  Pet? lostPet;
  List<bool> selectedLostPet = [];

  Future<void> getPetsAndSetMarkers(double distance) async {
    setState(() {
      fetchingPets = true;
    });

    pets = await LostAndFoundService().getLostPetsNearby(LocationVAF.myLocation.target, distance);

    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId("My Location"),
          position: LatLng(LocationVAF.myLocation.target.latitude, LocationVAF.myLocation.target.longitude),
          infoWindow: InfoWindow(
            title: "My Location",
            snippet: "You are here",
          ),
        ),
      );
      for (Pet pet in pets) {
        markers.add(
          Marker(
            markerId: MarkerId(pet.petId),
            position: LatLng(pet.lastSeenLocation.latitude, pet.lastSeenLocation.longitude),
            infoWindow: InfoWindow(
              title: pet.petName,
              snippet: "Last seen: ${pet.lastSeen}",
            ),
          ),
        );
      }
    });

    setState(() {
      fetchingPets = false;
    });
  }

  @override
  void initState() {
    super.initState();

    searchDistanceController = TextEditingController(text: "20");

    getPetsAndSetMarkers(20);

    selectedPet.addListener(() {
      setMarkers(selectedPet.value);
    });

    selectedLocation.addListener(() {
      panCameraToLocation(selectedLocation.value.latitude, selectedLocation.value.longitude);
    });

    setState(() {
      for (int i = 0; i < profileDetails.pets.length; i++) {
        selectedLostPet.add(false);
      }
    });
  }

  void setMarkers(int index) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId("My Location"),
          position: LatLng(LocationVAF.myLocation.target.latitude, LocationVAF.myLocation.target.longitude),
          infoWindow: InfoWindow(
            title: "My Location",
            snippet: "You are here",
          ),
        ),
      );
      if (selectedPet.value == -1) {
        for (Pet pet in pets) {
          markers.add(
            Marker(
              markerId: MarkerId(pet.petId),
              position: LatLng(pet.lastSeenLocation.latitude, pet.lastSeenLocation.longitude),
              infoWindow: InfoWindow(
                title: pet.petName,
                snippet: "Last seen: ${pet.lastSeen}",
              ),
            ),
          );
        }
      } else {
        Pet pet = pets[index];
        markers.add(
          Marker(
            markerId: MarkerId(pet.petId),
            position: LatLng(pet.lastSeenLocation.latitude, pet.lastSeenLocation.longitude),
            infoWindow: InfoWindow(
              title: pet.petName,
              snippet: "Last seen: ${pet.lastSeen}",
            ),
          ),
        );

        for (Sighting sighting in pet.sightings) {
          markers.add(
            Marker(
              markerId: MarkerId(sighting.founderId),
              position: LatLng(sighting.locationFound.latitude, sighting.locationFound.longitude),
              infoWindow: InfoWindow(
                title: pet.petName,
                snippet: "Seen on: ${sighting.lastSeen}",
              ),
            ),
          );
        }
      }
    });
  }

  Future<void> panCameraToLocation(double lat, double long) async {
    try {
      await _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 17.0,
          ),
        ),
      );
    } catch (e) {
      print("Error panning camera: $e");
      print("Location that shouldve been panned to: $lat, $long");
    }
  }

  @override
  void dispose() {
    try {
      // if (mounted) {
      // print("Disposing Google Map Controller");
      _googleMapController.dispose();
      // }
      super.dispose();
    } catch (e) {
      // print("Error disposing Google Map Controller: $e");
    } finally {
      searchDistanceController.dispose();
      super.dispose();
    }
  }

  void _showPopupMenu() {
    void setLostPet(int index) {
      setState(() {
        for (int i = 0; i < selectedLostPet.length; i++) {
          if (i == index) {
            selectedLostPet[i] = true;
          } else {
            selectedLostPet[i] = false;
          }
        }
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeSettings.cardColor,
          title: Text('Report Lost Pet', style: TextStyle(color: themeSettings.textColor)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < profileDetails.pets.length; i++) ...[
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        // Update the local selectedPet variable
                        setLostPet(i);
                        // Rebuild the dialog
                        Navigator.of(context).pop(); // Close the dialog to rebuild
                        _showPopupMenu(); // Show the dialog again
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: themeSettings.cardColor,
                          border: Border.all(
                            color: selectedLostPet[i] ? themeSettings.primaryColor : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(profileDetails.pets[i]["pictureUrl"]),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profileDetails.pets[i]["name"], style: TextStyle(color: themeSettings.textColor, fontSize: 24)),
                                Text(profileDetails.pets[i]["bio"], style: TextStyle(color: themeSettings.textColor)),
                              ],
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedLostPet.contains(true)) {
                  for (int i = 0; i < selectedLostPet.length; i++) {
                    if (selectedLostPet[i]) {
                      try {
                        await LostAndFoundService().reportPetMissing(
                          profileDetails.pets[i]["petID"],
                          LocationVAF.myLocation.target,
                          profileDetails.userID,
                        );
                        getPetsAndSetMarkers(double.parse(searchDistanceController.text));
                      } catch (e) {
                        print("Error reporting lost pet: $e");
                      }
                      break;
                    }
                  }
                }

                Navigator.of(context).pop();
              },
              child: Text('Report'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        color: themeSettings.backgroundColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lost and Found",
                  style: TextStyle(
                    color: themeSettings.textColor,
                    fontSize: 30,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showPopupMenu();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                  ),
                  child: Text(
                    "Report Lost Pet",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    key: Key("search-lost-pets-distance-input"),
                    controller: searchDistanceController,
                    decoration: InputDecoration(
                      labelText: "Distance (km)",
                      labelStyle: TextStyle(
                        color: themeSettings.primaryColor,
                      ),
                      prefixIcon: Icon(
                        Icons.map_outlined,
                        color: themeSettings.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: themeSettings.primaryColor,
                        ),
                      ),
                    ),
                    style: TextStyle(color: themeSettings.textColor),
                  ),
                ),
                MouseRegion(
                  key: Key("apply-filters-button"),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      if (applyFiltersButtonText == "Applying Filters...") {
                        return;
                      }
                
                      setState(() {
                        applyFiltersButtonText = "Applying Filters...";
                      });
                
                      if (searchDistanceController.text.isEmpty) {
                        return;
                      }
                
                      // check that there are only numbers in the input using regex
                      RegExp regex = RegExp(r'^[0-9]+$');
                      if (!regex.hasMatch(searchDistanceController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a valid distance'),
                            backgroundColor: Colors.red,
                          ),
                        );
                
                        setState(() {
                          applyFiltersButtonText = "Apply Filters";
                        });
                        return;
                      }
                
                      double distance = double.parse(searchDistanceController.text);
                
                      await getPetsAndSetMarkers(distance);
                
                      setState(() {
                        applyFiltersButtonText = "Apply Filters";
                      });
                    },
                    child: Container(
                      height: 48,
                      margin: EdgeInsets.only(bottom: 10, left: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: themeSettings.primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          applyFiltersButtonText,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ),
                if (selectedPet.value != -1) ...[
                  MouseRegion(
                    key: Key("add-sighting-button"),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        if (reportSightingText == "Reporting Sighting...") {
                          return;
                        }
                
                        setState(() {
                          reportSightingText = "Reporting Sighting...";
                        });
                
                        try {
                          Pet pet = pets[selectedPet.value];
                
                          await LostAndFoundService().reportPetSighting(pet.petId, profileDetails.userID, LocationVAF.myLocation.target);
                          await getPetsAndSetMarkers(double.parse(searchDistanceController.text));
                
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sighting reported successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to report sighting'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                
                        setState(() {
                          reportSightingText = "Report Sighting";
                        });
                      },
                      child: Container(
                        height: 48,
                        margin: EdgeInsets.only(bottom: 10, left: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: themeSettings.primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            reportSightingText,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Divider(),
            if (fetchingPets) ...[
              Container(
                margin: EdgeInsets.only(right: 10),
                width: (MediaQuery.of(context).size.width),
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ] else ...[
              ListOfPets(
                pets: pets,
                markers: markers,
                selectedPet: selectedPet,
                selectedLocation: selectedLocation,
              ),
            ],
            SizedBox(
              width: (MediaQuery.of(context).size.width),
              height: MediaQuery.of(context).size.height - 313.0,
              child: FutureBuilder<String?>(
                future: LocationVAF.getMapStyle(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading map style'));
                  }
                
                  String? mapStyle = snapshot.data;
                
                  // return Text("Placeholder for Google Map");
                
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: GoogleMap(
                        key: Key('googleMap'),
                        style: mapStyle,
                        initialCameraPosition: LocationVAF.myLocation,
                        markers: markers.toSet(),
                        onMapCreated: (GoogleMapController controller) {
                          print("Google Map Controller created");
                          _googleMapController = controller;
                
                          if (selectedPet.value != -1) {
                            panCameraToLocation(pets[selectedPet.value].lastSeenLocation.latitude, pets[selectedPet.value].lastSeenLocation.longitude);
                          }
                        },
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                      ),
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListOfPets extends StatefulWidget {
  const ListOfPets({
    super.key,
    required this.pets,
    required this.markers,
    required this.selectedPet,
    required this.selectedLocation,
  });
  final List<Pet> pets;
  final List<Marker> markers;
  final ValueNotifier<int> selectedPet;
  final ValueNotifier<GeoPoint> selectedLocation;
  @override
  State<ListOfPets> createState() => _ListOfPetsState();
}

class _ListOfPetsState extends State<ListOfPets> {
  bool petSelected = false;
  Pet? selectedPet;

  @override
  void initState() {
    super.initState();
  }

  void setSelectedPet(Pet pet) {
    setState(() {
      selectedPet = pet;
      petSelected = true;
    });

    widget.selectedPet.value = widget.pets.indexOf(pet);
  }

  void clearSelectedPet() {
    setState(() {
      petSelected = false;
      selectedPet = null;
    });

    widget.selectedPet.value = -1;
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    if (petSelected) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        width: (MediaQuery.of(context).size.width),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      clearSelectedPet();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: themeSettings.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text("Sightings for ${selectedPet?.petName}", style: TextStyle(color: themeSettings.textColor, fontSize: 24)),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (Sighting sightings in selectedPet!.sightings) ...[
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          widget.selectedLocation.value = sightings.locationFound;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: themeSettings.cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_pin, color: themeSettings.primaryColor, size: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date: ${formatDate(sightings.lastSeen)}", style: TextStyle(color: themeSettings.textColor)),
                                  Text("Location: ${sightings.locationFound.latitude}, ${sightings.locationFound.longitude}", style: TextStyle(color: themeSettings.textColor)),
                                ],
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
            if (selectedPet == null || selectedPet!.sightings.isEmpty) ...[
              Text("No sightings found", style: TextStyle(color: themeSettings.textColor)),
            ],
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(right: 10),
        width: (MediaQuery.of(context).size.width),
        height: 100,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (Pet pet in widget.pets) ...[
                MouseRegion(
                  key: Key("pet-${widget.pets.indexOf(pet)}"),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   petSelected = true;
                      //   selectedPet = pet;
                      // });
                      setSelectedPet(pet);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(pet.pictureUrl),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(pet.petName, style: TextStyle(color: themeSettings.textColor, fontSize: 24)),
                                  if (pet.ownerId == profileDetails.userID) ...[
                                    SizedBox(width: 10),
                                    TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(themeSettings.primaryColor),
                                      ),
                                      onPressed: () async {
                                        await LostAndFoundService().reportPetFound(pet.petId);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Pet reported found'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      child: Text("Report Found", style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ],
                              ),
                              Text("Last seen: ${formatDate(pet.lastSeen!)}", style: TextStyle(color: themeSettings.textColor)),
                              Text("Sightings: ${pet.sightings.length}", style: TextStyle(color: themeSettings.textColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (widget.pets.isEmpty) ...[
                Text("No pets found", style: TextStyle(color: themeSettings.textColor)),
              ],
            ],
          ),
        ),
      );
    }
  }
}
