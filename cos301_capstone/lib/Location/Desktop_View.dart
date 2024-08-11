// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDesktop extends StatefulWidget {
  const LocationDesktop({super.key});

  @override
  State<LocationDesktop> createState() => _LocationDesktopState();
}

class _LocationDesktopState extends State<LocationDesktop> {
  final ScrollController _scrollController = ScrollController();
  late GoogleMapController _googleMapController;

  @override
  void initState() {
    super.initState();

    try {
      populateData() async {
        await LocationVAF.getVets(LocationVAF.myLocation.target, 100);
        await LocationVAF.getPetSitters(LocationVAF.myLocation.target, 100);
        setState(() {});
      }

      populateData();
    } catch (e) {
      print("Error initializing location: $e");
    }
  }

  @override
  void dispose() {
    try {
      if (mounted) {
        _googleMapController.dispose();
      }
      super.dispose();
    } catch (e) {
      print("Error disposing Google Map Controller: $e");
    } finally {
      _scrollController.dispose();
      super.dispose();
    }
  }

  Future<void> panCameraToLocation(double lat, double long) async {
    print("Panning camera to location: $lat, $long");
    print("Google Map Controller: $_googleMapController");
    try {
      await _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 15.0,
          ),
        ),
      );
    } catch (e) {
      print("Error panning camera: $e");
    }
  }

  Widget searchVets() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 400,
                margin: EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: LocationVAF.searchVetsController,
                  decoration: InputDecoration(
                    labelText: "Search Veterinary Clinics",
                    labelStyle: TextStyle(
                      color: themeSettings.primaryColor,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
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
              SizedBox(width: 20.0),
              Container(
                width: 200,
                padding: EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: LocationVAF.searchDistanceController,
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
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await LocationVAF.getVets(LocationVAF.myLocation.target, double.parse(LocationVAF.searchDistanceController.text));
                    setState(() {});
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
                        "Apply Filters",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (User vet in LocationVAF.vetList) ...[
                    Container(
                      margin: EdgeInsets.only(right: 50, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              panCameraToLocation(vet.location.latitude, vet.location.longitude);
                            } catch (e) {
                              print("Error getting directions: $e");
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vet.name,
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                              Text(
                                "Email: ${vet.email == '' ? 'No email provided' : vet.email}",
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                              Text(
                                "Phone number: ${vet.phone == '' ? 'No phone number provided' : vet.phone}",
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                              Text(
                                "Distance: ${vet.distance.toStringAsFixed(2)}km",
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (LocationVAF.vetList.isEmpty)
                    Text(
                      "No veterinary clinics found within the specified radius, try increasing the search radius.",
                      style: TextStyle(color: themeSettings.textColor),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchPetSitters() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 400,
                margin: EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: LocationVAF.searchPetSittersController,
                  decoration: InputDecoration(
                    labelText: "Search Pet Sitters",
                    labelStyle: TextStyle(
                      color: themeSettings.primaryColor,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
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
              SizedBox(width: 20.0),
              Container(
                width: 200,
                padding: EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: LocationVAF.searchPetSittersDistanceController,
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
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await LocationVAF.getPetSitters(LocationVAF.myLocation.target, double.parse(LocationVAF.searchPetSittersDistanceController.text));
                    setState(() {});
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
                        "Apply Filters",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (User petSitter in LocationVAF.petKeeperList) ...[
                    Container(
                      margin: EdgeInsets.only(right: 50, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              panCameraToLocation(petSitter.location.latitude, petSitter.location.longitude);
                            } catch (e) {
                              print("Error getting directions: $e");
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                petSitter.name,
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                              Text(
                                "Email: ${petSitter.email == '' ? 'No email provided' : petSitter.email}",
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                              Text(
                                "Phone number: ${petSitter.phone == '' ? 'No phone number provided' : petSitter.phone}",
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                              Text(
                                "Distance: ${petSitter.distance.toStringAsFixed(2)}km",
                                style: TextStyle(color: themeSettings.textColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (LocationVAF.petKeeperList.isEmpty)
                    Text(
                      "No pet sitters found within the specified radius, try increasing the search radius.",
                      style: TextStyle(color: themeSettings.textColor),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: themeSettings.backgroundColor,
        child: Row(
          children: [
            DesktopNavbar(),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 290.0,
                    decoration: BoxDecoration(
                      color: themeSettings.cardColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: themeSettings.primaryColor,
                            indicatorColor: themeSettings.secondaryColor,
                            tabs: [
                              Tab(text: 'Veterinary Clinics'),
                              Tab(text: 'Pet Sitters'),
                            ],
                          ),
                          SizedBox(
                            height: 200.0,
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                searchVets(),
                                searchPetSitters(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 290.0,
                    height: MediaQuery.of(context).size.height - 320.0,
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

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: GoogleMap(
                            style: mapStyle,
                            initialCameraPosition: LocationVAF.myLocation,
                            markers: LocationVAF.markers,
                            onMapCreated: (GoogleMapController controller) {
                              _googleMapController = controller;
                            },
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
