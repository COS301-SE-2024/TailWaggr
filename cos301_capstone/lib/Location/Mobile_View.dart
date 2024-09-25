// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMobile extends StatefulWidget {
  const LocationMobile({super.key});

  @override
  State<LocationMobile> createState() => _LocationMobileState();
}

class _LocationMobileState extends State<LocationMobile> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late GoogleMapController _googleMapController;

  late AnimationController _animationController;
  bool cardExpanded = false;

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
      // print("Error disposing Google Map Controller: $e");
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

  void toggleCardExpansion() {
    setState(() {
      cardExpanded = !cardExpanded;
      if (cardExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Widget searchVets() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width - 290.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10.0),
              child: TextField(
                key: Key("search-vets-input"),
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
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 10.0),
              child: TextField(
                key: Key("search-vets-distance-input"),
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
            SizedBox(height: 10.0),
            MouseRegion(
              key: Key("apply-filters-button"),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  await LocationVAF.getVets(LocationVAF.myLocation.target, double.parse(LocationVAF.searchDistanceController.text));
                  setState(() {});
                },
                child: Container(
                  height: 48,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
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
            for (Vet vet in LocationVAF.vetList) ...[
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
                        await panCameraToLocation(vet.location.latitude, vet.location.longitude);
                        
                        // setState(() {
                          // toggleCardExpansion();
                        // });
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
                          "Address: ${vet.address == '' ? 'No Address provided' : vet.address}",
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
    );
  }

  Widget searchPetSitters() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width - 290.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10.0),
              child: TextField(
                key: Key("search-pet-sitters-input"),
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
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 10.0),
              child: TextField(
                key: Key("search-pet-sitters-distance-input"),
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
            SizedBox(height: 10.0),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  await LocationVAF.getPetSitters(LocationVAF.myLocation.target, double.parse(LocationVAF.searchPetSittersDistanceController.text));
                  setState(() {});
                },
                child: Container(
                  height: 48,
                  margin: EdgeInsets.only(bottom: 10),
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
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: themeSettings.backgroundColor,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height, // Adjusted height based on expansion state
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  padding: EdgeInsets.only(bottom: 5, right: 30),
                  duration: Duration(milliseconds: 300),
                  height: MediaQuery.of(context).size.height / 2 - 40,
                  // height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: themeSettings.cardColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: !cardExpanded,
                        child: DefaultTabController(
                           key: Key('tabController'),
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor: themeSettings.primaryColor,
                                indicatorColor: themeSettings.secondaryColor,
                                tabs: [
                                 Tab(
                                    key: Key('vetsTab'),
                                    text: 'Veterinary Clinics',
                                  ),
                                  Tab(
                                    key: Key('petSittersTab'),
                                    text: 'Pet Sitters',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 2 - 110,
                                child: TabBarView(
                                  key: Key('tabBarView'),
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
                      // Center(
                      //   child: MouseRegion(
                      //     cursor: SystemMouseCursors.click,
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         toggleCardExpansion();
                      //       },
                      //       child: SizedBox(
                      //         width: double.infinity,
                      //         height: 40,
                      //         child: Center(
                      //           child: Text(
                      //             cardExpanded ? 'Close' : 'Expand',
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(color: themeSettings.primaryColor, fontSize: 16.0),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                AnimatedContainer(
                  height: MediaQuery.of(context).size.height / 2 - 50,
                  width: MediaQuery.of(context).size.width,
                  duration: Duration(milliseconds: 300),
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
                          onMapCreated: (controller) {
                            _googleMapController = controller;
                          },
                          initialCameraPosition: LocationVAF.myLocation,
                          markers: LocationVAF.markers,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          polylines: {
                            if (LocationVAF.polylineResult.points.isNotEmpty)
                              Polyline(
                                polylineId: const PolylineId('polyline'),
                                color: themeSettings.primaryColor,
                                width: 4, // Change the line thickness here
                                points: LocationVAF.polylineResult.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                              ),
                          },
                        ),
                      );
                    },
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
