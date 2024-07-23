// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
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

  GoogleMapController? _googleMapController;
  final Set<Marker> _markers = {};
  late CameraPosition _initialLocation = CameraPosition(
    target: LatLng(-28.284535, 24.402177),
    zoom: 5.0,
  );

  Future<String?> _getMapStyle() async {
    if (themeSettings.themeMode == "Light") {
      return await rootBundle.loadString('assets/GoogleMaps/lightMode.json');
    }
    return await rootBundle.loadString('assets/GoogleMaps/darkMode.json');
  }

  Future<LatLng> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return Future.error("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permantly denied, we cannot request permissions.");
      return Future.error("Location permissions are permantly denied, we cannot request permissions.");
    }

    if (permission == LocationPermission.denied) {
      print("Location permissions are denied");
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print("Location permissions are denied (actual value: $permission).");
        return Future.error("Location permissions are denied (actual value: $permission).");
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  Future<void> _initializeLocation() async {
    try {
      LatLng currentLocation = await _getCurrentLocation();
      setState(() {
        _initialLocation = CameraPosition(
          target: currentLocation,
          zoom: 14.0,
        );
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: currentLocation,
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('brooklyn_vet'),
        position: LatLng(-25.758878914381995, 28.238580084657446),
        infoWindow: const InfoWindow(
          title: 'Brooklyn Vet',
          snippet: 'Veterinary Clinic',
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('bryanston_vet'),
        position: LatLng(-26.0565, 28.0248),
        infoWindow: const InfoWindow(
          title: 'Bryanston Vet',
          snippet: 'Veterinary Clinic',
        ),
      ),
    );

    _initializeLocation();
  }

  @override
  void dispose() {
    try {
      if (_googleMapController != null && mounted) {
        _googleMapController?.dispose();
      }
      super.dispose();
    } catch (e) {
      print("Error disposing Google Map Controller: $e");
    } finally {
      _scrollController.dispose();
      super.dispose();
    }
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
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: themeSettings.primaryColor,
                            indicatorColor: themeSettings.secondaryColor,
                            tabs: [
                              Tab(text: 'Veterinary Clinics'),
                              Tab(text: 'Pet Sitters'),
                              Tab(text: 'Pet Groomers'),
                            ],
                          ),
                          SizedBox(
                            height: 200.0,
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Search Veterinary Clinics',
                                            hintStyle: TextStyle(
                                              color: themeSettings.primaryColor.withOpacity(0.5),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: themeSettings.primaryColor,
                                            ),
                                            filled: true,
                                            fillColor: themeSettings.cardColor,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Scrollbar(
                                        // isAlwaysShown: true,
                                        controller: _scrollController,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          controller: _scrollController,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              for (int i = 0; i < 20; i++) ...[
                                                Container(
                                                  margin: EdgeInsets.only(right: 50, bottom: 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  child: MouseRegion(
                                                    cursor: SystemMouseCursors.click,
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Vet $i',
                                                            style: TextStyle(color: themeSettings.textColor),
                                                          ),
                                                          Text(
                                                            'Address $i',
                                                            style: TextStyle(color: themeSettings.textColor),
                                                          ),
                                                          Text(
                                                            "Phone number $i",
                                                            style: TextStyle(color: themeSettings.textColor),
                                                          ),
                                                          Text(
                                                            "Distance $i km",
                                                            style: TextStyle(color: themeSettings.textColor),
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
                                      )
                                    ],
                                  ),
                                ),
                                Text('Pet Stores'),
                                Text('Pet Groomers'),
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
                      future: _getMapStyle(),
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
                            initialCameraPosition: _initialLocation,
                            markers: _markers,
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
