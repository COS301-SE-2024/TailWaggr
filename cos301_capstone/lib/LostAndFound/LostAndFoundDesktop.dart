// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LostAndFoundDesktop extends StatefulWidget {
  const LostAndFoundDesktop({super.key});

  @override
  State<LostAndFoundDesktop> createState() => _LostAndFoundDesktopState();
}

class _LostAndFoundDesktopState extends State<LostAndFoundDesktop> {
  late GoogleMapController _googleMapController;

  final List<Map<String, dynamic>> pets = [
    {
      "petName": "Bella",
      "lastSeen": "2021-09-01",
      "location": GeoPoint(-25.751065353022884, 28.24424206468121),
      "potentialSightings": []
    },
    {
      "petName": "Max",
      "lastSeen": "2021-09-05",
      "location": GeoPoint(-26.2041028, 28.0473051),
      "potentialSightings": []
    },
    {
      "petName": "Lucy",
      "lastSeen": "2021-08-20",
      "location": GeoPoint(-33.9248685, 18.4240553),
      "potentialSightings": [
        {
          "seenDate": "2021-08-21",
          "location": GeoPoint(-33.9249, 18.4240),
        },
      ]
    },
    {
      "petName": "Charlie",
      "lastSeen": "2021-07-15",
      "location": GeoPoint(-34.603722, -58.381592),
      "potentialSightings": [
        {
          "seenDate": "2021-07-16",
          "location": GeoPoint(-34.6037, -58.3815),
        },
        {
          "seenDate": "2021-07-17",
          "location": GeoPoint(-34.6038, -58.3814),
        },
        {
          "seenDate": "2021-07-18",
          "location": GeoPoint(-34.6039, -58.3813),
        },
      ]
    },
    {
      "petName": "Milo",
      "lastSeen": "2021-06-10",
      "location": GeoPoint(51.5074, -0.1278),
      "potentialSightings": [
        {
          "seenDate": "2021-06-11",
          "location": GeoPoint(51.5073, -0.1277),
        },
      ]
    },
    {
      "petName": "Rocky",
      "lastSeen": "2021-10-25",
      "location": GeoPoint(40.712776, -74.005974),
      "potentialSightings": [
        {
          "seenDate": "2021-10-26",
          "location": GeoPoint(40.7127, -74.0060),
        },
        {
          "seenDate": "2021-10-27",
          "location": GeoPoint(40.7128, -74.0059),
        },
      ]
    }
  ];

  final List<Marker> markers = [];

  ValueNotifier<int> selectedPet = ValueNotifier<int>(-1);
  ValueNotifier<GeoPoint> selectedLocation = ValueNotifier<GeoPoint>(GeoPoint(0, 0));

  bool mapControllerLoaded = false;

  Map<String, dynamic> lostPet = {};
  List<bool> selectedLostPet = [];

  @override
  void initState() {
    super.initState();

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
      for (Map<String, dynamic> pet in pets) {
        markers.add(
          Marker(
            markerId: MarkerId(pet["petName"]),
            position: LatLng(pet["location"].latitude, pet["location"].longitude),
            infoWindow: InfoWindow(
              title: pet["petName"],
              snippet: "Last seen: ${pet["lastSeen"]}",
            ),
          ),
        );
      }
    });

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
        for (Map<String, dynamic> pet in pets) {
          markers.add(
            Marker(
              markerId: MarkerId(pet["petName"]),
              position: LatLng(pet["location"].latitude, pet["location"].longitude),
              infoWindow: InfoWindow(
                title: pet["petName"],
                snippet: "Last seen: ${pet["lastSeen"]}",
              ),
            ),
          );
        }
      } else {
        Map<String, dynamic> pet = pets[index];
        markers.add(
          Marker(
            markerId: MarkerId(pet["petName"]),
            position: LatLng(pet["location"].latitude, pet["location"].longitude),
            infoWindow: InfoWindow(
              title: pet["petName"],
              snippet: "Last seen: ${pet["lastSeen"]}",
            ),
          ),
        );

        for (Map<String, dynamic> sighting in pet["potentialSightings"]) {
          markers.add(
            Marker(
              markerId: MarkerId(sighting["seenDate"]),
              position: LatLng(sighting["location"].latitude, sighting["location"].longitude),
              infoWindow: InfoWindow(
                title: pet["petName"],
                snippet: "Seen on: ${sighting["seenDate"]}",
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
      // _scrollController.dispose();
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
              onPressed: () {
                // Add your logic to report the lost pet here
                if (selectedPet != null) {
                  // Use selectedPet to report
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
        color: themeSettings.backgroundColor,
        child: Row(
          children: [
            DesktopNavbar(),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width - 290,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeSettings.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
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
                        width: 400,
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: TextField(
                          key: Key("search-lost-pets-distance-input"),
                          // controller: LocationVAF.searchDistanceController,
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
                          onTap: () async {},
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
                                "Apply Filters",
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
                            onTap: () async {},
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
                                  "Add sighting",
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
                  Row(
                    children: [
                      ListOfPets(
                        pets: pets,
                        markers: markers,
                        selectedPet: selectedPet,
                        selectedLocation: selectedLocation,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 290) / 3 * 2 - 30,
                        height: MediaQuery.of(context).size.height - 197.0,
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

                            return Text("Placeholder for Google Map");

                          //   return ClipRRect(
                          //     borderRadius: BorderRadius.circular(20.0),
                          //     child: GoogleMap(
                          //       key: Key('googleMap'),
                          //       style: mapStyle,
                          //       initialCameraPosition: LocationVAF.myLocation,
                          //       markers: markers.toSet(),
                          //       onMapCreated: (GoogleMapController controller) {
                          //         print("Google Map Controller created");
                          //         _googleMapController = controller;

                          //         if (selectedPet.value != -1) {
                          //           panCameraToLocation(pets[selectedPet.value]["location"].latitude, pets[selectedPet.value]["location"].longitude);
                          //         }
                          //       },
                          //       myLocationButtonEnabled: true,
                          //       zoomControlsEnabled: true,
                          //     ),
                          //   );
                          },
                        ),
                      ),
                    ],
                  )
                ],
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
  final List<Map<String, dynamic>> pets;
  final List<Marker> markers;
  final ValueNotifier<int> selectedPet;
  final ValueNotifier<GeoPoint> selectedLocation;
  @override
  State<ListOfPets> createState() => _ListOfPetsState();
}

class _ListOfPetsState extends State<ListOfPets> {
  bool petSelected = false;
  Map<String, dynamic> selectedPet = {};

  @override
  void initState() {
    super.initState();
  }

  void setSelectedPet(Map<String, dynamic> pet) {
    setState(() {
      selectedPet = pet;
      petSelected = true;
    });

    widget.selectedPet.value = widget.pets.indexOf(pet);
  }

  void clearSelectedPet() {
    setState(() {
      petSelected = false;
      selectedPet = {};
    });

    widget.selectedPet.value = -1;
  }

  @override
  Widget build(BuildContext context) {
    if (petSelected) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        width: (MediaQuery.of(context).size.width - 290) / 3,
        height: MediaQuery.of(context).size.height - 197.0,
        child: SingleChildScrollView(
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
                  Text("Sightings for ${selectedPet["petName"]}", style: TextStyle(color: themeSettings.textColor, fontSize: 24)),
                ],
              ),
              for (Map<String, dynamic> sightings in selectedPet["potentialSightings"]) ...[
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      widget.selectedLocation.value = sightings["location"];
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
                              Text("Date: ${sightings["seenDate"]}", style: TextStyle(color: themeSettings.textColor)),
                              Text("Location: ${sightings["location"].latitude}, ${sightings["location"].longitude}", style: TextStyle(color: themeSettings.textColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (selectedPet["potentialSightings"] == null || selectedPet["potentialSightings"].isEmpty) ...[
                Text("No sightings found", style: TextStyle(color: themeSettings.textColor)),
              ],
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(right: 10),
        width: (MediaQuery.of(context).size.width - 290) / 3,
        height: MediaQuery.of(context).size.height - 197.0,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (Map<String, dynamic> pet in widget.pets) ...[
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
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            // backgroundImage: AssetImage("assets/images/dog.png"),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pet["petName"], style: TextStyle(color: themeSettings.textColor, fontSize: 24)),
                              Text("Last seen: ${pet["lastSeen"]}", style: TextStyle(color: themeSettings.textColor)),
                              Text("Sightings: ${pet["potentialSightings"].length}", style: TextStyle(color: themeSettings.textColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    }
  }
}
