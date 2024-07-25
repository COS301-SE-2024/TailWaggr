import 'package:cos301_capstone/Global_Variables.dart';
import 'package:cos301_capstone/Location/Location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMobile extends StatefulWidget {
  const LocationMobile({super.key});

  @override
  State<LocationMobile> createState() => _LocationMobileState();
}

class _LocationMobileState extends State<LocationMobile> {
  final ScrollController _scrollController = ScrollController();
  GoogleMapController? _googleMapController;

  TextEditingController _searchVetsController = TextEditingController();
  TextEditingController _searchDistanceController = TextEditingController(text: "10");

  void panCameraToLocation(double lat, double long) {
    // Check to see that the south west co-ordinate is less than the north east co-ordinate
    LatLngBounds bounds;
    if (LocationVAF.myLocation.target.longitude > lat) {
      bounds = LatLngBounds(
        northeast: LatLng(LocationVAF.myLocation.target.longitude, LocationVAF.myLocation.target.latitude),
        southwest: LatLng(lat, long),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(LocationVAF.myLocation.target.longitude, LocationVAF.myLocation.target.latitude),
        northeast: LatLng(lat, long),
      );
    }

    double zoomLevel = LocationVAF.calculateZoomLevel(bounds, context);

    _googleMapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, zoomLevel),
    );

    // remove all markers except the selected location
    setState(() {
      LocationVAF.markers.clear();
      LocationVAF.markers.add(
        Marker(
          markerId: MarkerId("Nearest Vet"),
          infoWindow: InfoWindow(title: "Nearest Vet"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(lat, long),
        ),
      );
      LocationVAF.markers.add(
        Marker(
          markerId: const MarkerId('My Location'),
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: LatLng(LocationVAF.myLocation.target.longitude, LocationVAF.myLocation.target.latitude),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    populateData() async {
      await LocationVAF.initializeLocation();
      await LocationVAF.getVets(LocationVAF.myLocation.target, 10);
      setState(() {});
    }

    populateData();
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
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            LocationVAF.getDirections(LatLng(25.758878914381995, 28.238580084657446));
          },
          child: Text("Find Nearest Vet"),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
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
    );
  }
}
