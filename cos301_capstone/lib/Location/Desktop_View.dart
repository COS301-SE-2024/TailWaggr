// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Navbar/Desktop_View.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDesktop extends StatefulWidget {
  const LocationDesktop({super.key});

  @override
  State<LocationDesktop> createState() => _LocationDesktopState();
}

class _LocationDesktopState extends State<LocationDesktop> {
  GoogleMapController? _googleMapController;
  final Set<Marker> _markers = {};
  late CameraPosition _initialLocation = CameraPosition(
    target: LatLng(-28.284535, 24.402177),
    zoom: 5.0,
  );

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

    _initializeLocation();
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
  void dispose() {
    try {
      if (_googleMapController != null && mounted) {
      _googleMapController?.dispose();
    }
    super.dispose();
    } catch (e) {
      print("Error disposing Google Map Controller: $e");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DesktopNavbar(),
          Container(
            color: themeSettings.Background_Colour,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextField(
                    // controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search for a vet clinic",
                      hintStyle: TextStyle(color: themeSettings.Text_Colour.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search),
                    ),
                    style: TextStyle(color: themeSettings.Text_Colour), // Add this line
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (controller) {
                  _googleMapController = controller;
                },
                initialCameraPosition: _initialLocation,
                markers: _markers,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
