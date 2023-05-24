import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class Mapps extends StatefulWidget {
  const Mapps({Key? key}) : super(key: key);

  @override
  _MappsState createState() => _MappsState();
}

class _MappsState extends State<Mapps> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
      (error, stackTrace) async {
        await Geolocator.requestPermission();
        print("ERROR" + error.toString());
      },
    );
    return await Geolocator.getCurrentPosition();
  }

  Future<void> showRoute(LatLng destination) async {
    final currentPosition = await getUserCurrentLocation();
    final currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    final List<Location> locations = await locationFromAddress(destination.toString());
    final destinationLatLng = LatLng(locations[0].latitude, locations[0].longitude);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            currentLatLng.latitude < destinationLatLng.latitude
                ? currentLatLng.latitude
                : destinationLatLng.latitude,
            currentLatLng.longitude < destinationLatLng.longitude
                ? currentLatLng.longitude
                : destinationLatLng.longitude,
          ),
          northeast: LatLng(
            currentLatLng.latitude > destinationLatLng.latitude
                ? currentLatLng.latitude
                : destinationLatLng.latitude,
            currentLatLng.longitude > destinationLatLng.longitude
                ? currentLatLng.longitude
                : destinationLatLng.longitude,
          ),
        ),
        100.0,
      ),
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: destinationLatLng,
          infoWindow: InfoWindow(
            title: 'Selected Location',
          ),
        ),
      );
    });

    final directions = await DirectionsRepository().getDirections(currentLatLng, destinationLatLng);

    if (directions != null) {
      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId('directions'),
            points: directions,
            color: Colors.blue,
            width: 3,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF36B8F5),
        title: Text("Nearest Hospitals"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            final currentPosition = LatLng(value.latitude, value.longitude);

            setState(() {
              _markers.clear();
              _polylines.clear();
              _markers.add(
                Marker(
                  markerId: MarkerId('current'),
                  position: currentPosition,
                  infoWindow: InfoWindow(
                    title: 'My Current Location',
                  ),
                ),
              );
            });

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newLatLng(currentPosition));

            // Call a method to show the nearest places
            // and allow the user to select a place for routing
          });
        },
        child: Icon(Icons.local_activity),
      ),
    );
  }
}

class DirectionsRepository {
  Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    // Implement your logic to fetch directions from origin to destination using an API (e.g., Google Directions API)
    // and return the result as a List of LatLng points representing the polyline.
    // For demonstration purposes, let's return a dummy polyline here.
    return [
      LatLng(20.42796133580664, 80.885749655962),
      LatLng(20.42896133580664, 80.886749655962),
      LatLng(20.42996133580664, 80.887749655962),
    ];
  }
}
