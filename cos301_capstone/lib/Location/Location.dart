import 'dart:math';

import 'package:cos301_capstone/Location/Desktop_View.dart';
import 'package:cos301_capstone/Location/Mobile_View.dart';
import 'package:cos301_capstone/Location/Tablet_View.dart';
import 'package:cos301_capstone/Navbar/Mobile_View.dart';
import 'package:cos301_capstone/services/Location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:cos301_capstone/Global_Variables.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationVAF {
  static final Set<Marker> markers = {};
  static List<User> vetList = [];
  static List<User> petKeeperList = [];
  static CameraPosition myLocation = CameraPosition(
    target: LatLng(-28.284535, 24.402177),
    zoom: 5.0,
  );

  static TextEditingController searchVetsController = TextEditingController();
  static TextEditingController searchDistanceController = TextEditingController(text: "100");

  static TextEditingController searchPetSittersController = TextEditingController();
  static TextEditingController searchPetSittersDistanceController = TextEditingController(text: "100");

  static PolylineResult polylineResult = PolylineResult(points: []);

  static Future<String?> getMapStyle() async {
    if (themeSettings.themeMode == "Light") {
      return await rootBundle.loadString('assets/GoogleMaps/lightMode.json');
    }
    return await rootBundle.loadString('assets/GoogleMaps/darkMode.json');
  }

  static Future<LatLng> getCurrentLocation() async {
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

  static Future<void> initializeLocation() async {
    try {
      LatLng currentLocation = await getCurrentLocation();
      myLocation = CameraPosition(
        target: currentLocation,
        zoom: 14.0,
      );
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: currentLocation,
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  static void getDirections(LatLng destLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PointLatLng _origin = PointLatLng(myLocation.target.latitude, myLocation.target.longitude);
    PointLatLng _destination = PointLatLng(destLocation.latitude, destLocation.longitude);

    print('Fetched location');

    try {
      PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyAK92a9EH6D2_HL14GhePhna0B3ovYkyQA",
        request: PolylineRequest(
          origin: _origin,
          destination: _destination,
          mode: TravelMode.driving,
        ),
      );
    } catch (e) {
      print("Error getting polyline: $e");
    }

    print('Fetched polyline result');

    // if (polylineResult.points.isNotEmpty) {
    //   polylineResult.points.clear();
    //   for (var point in polylineResult.points) {
    //     polylineResult.points.add(PointLatLng(point.latitude, point.longitude));
    //   }
    // }
  }

  static double calculateZoomLevel(LatLngBounds bounds, BuildContext context) {
    const double padding = 50.0;
    double maxZoom = 18.0;

    double minZoom = 0.0;
    double zoom = minZoom;

    double width = MediaQuery.of(context).size.width - (2 * padding);
    double height = MediaQuery.of(context).size.height - (2 * padding);

    double angle = bounds.northeast.longitude - bounds.southwest.longitude;
    if (angle < 0) {
      angle += 360;
    }

    double zoomH = _calculateZoomToFit(width, angle);
    double zoomV = _calculateZoomToFit(height, bounds.northeast.latitude - bounds.southwest.latitude);

    zoom = min(zoomH, zoomV);
    zoom = min(maxZoom, max(minZoom, zoom));

    return zoom;
  }

  static double _calculateZoomToFit(double size, double distance) {
    // const double earthRadius = 6378137;
    double metersPerPixel = (distance * 1000) / size;
    double zoomLevel = (16 - log(metersPerPixel) / log(2));

    return zoomLevel;
  }

  static Future<void> panCameraToLocation(double lat, double long, GoogleMapController googleMapController) async {
    print("Panning camera to location");
    try {
      await googleMapController.animateCamera(
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

  String getDistanceFromMe(double lat, double long) {
    double distanceInKilometers = (Geolocator.distanceBetween(lat, long, myLocation.target.latitude, myLocation.target.longitude) / 1000);
    if (distanceInKilometers < 1000) {
      return "${(distanceInKilometers).toStringAsFixed(0)} m";
    }

    return "${(Geolocator.distanceBetween(lat, long, myLocation.target.latitude, myLocation.target.longitude) / 1000).toStringAsFixed(2)} km";
  }

  static Future<List<User>> getVets(LatLng userLocation, double radius) async {
    print("Getting vets");
    vetList.clear();
    List<User> vets = await LocationService().getVets(userLocation, radius);
    for (User vet in vets) {
      vetList.add(vet);
      markers.add(
        Marker(
          markerId: MarkerId(vet.id),
          position: LatLng(vet.location.latitude, vet.location.longitude),
          infoWindow: InfoWindow(
            title: vet.name,
            snippet: "Get directions ${vet.distance.toStringAsFixed(2)}km",
            onTap: () async {
              print("Navigating to google maps");
              final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${vet.location.latitude},${vet.location.longitude}');
              if (!await launchUrl(url)) {
                print('Could not launch $url');
              }
            },
          ),
        ),
      );
    }
    return vets;
  }

  static Future<List<User>> getPetSitters(LatLng userLocation, double radius) async {
    print("Getting pet sitters");
    petKeeperList.clear();
    List<User> petKeepers = await LocationService().getPetKeepers(userLocation, radius);
    for (User petKeeper in petKeepers) {
      petKeeperList.add(petKeeper);
      markers.add(
        Marker(
          markerId: MarkerId(petKeeper.id),
          position: LatLng(petKeeper.location.latitude, petKeeper.location.longitude),
          infoWindow: InfoWindow(
            title: petKeeper.name,
            snippet: "Get directions ${petKeeper.distance.toStringAsFixed(2)}km",
            onTap: () async {
              print("Navigating to google maps");
              final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${petKeeper.location.latitude},${petKeeper.location.longitude}');
              if (!await launchUrl(url)) {
                print('Could not launch $url');
              }
            },
          ),
        ),
      );
    }
    return petKeepers;
  }
}

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeSettings,
      builder: (BuildContext context, Widget? child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1100) {
              return LocationDesktop();
            } else if (constraints.maxWidth > 800) {
              return Scaffold(
                body: LocationTablet(),
              );
            } else {
              return Scaffold(
                drawer: NavbarDrawer(),
                appBar: AppBar(
                  backgroundColor: themeSettings.primaryColor,
                  title: Text(
                    "TailWaggr",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                body: LocationMobile(),
              );
            }
          },
        );
      },
    );
  }
}
