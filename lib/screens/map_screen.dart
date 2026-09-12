import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NationalPark {
  final String name;
  final LatLng mainGate;

  const NationalPark(this.name, this.mainGate);
}

// Approximate main-gate coordinates. Good enough to determine which park is
// nearest, but verify against official sources before using for navigation.
const kNationalParks = [
  NationalPark("Kruger National Park", LatLng(-25.0128, 31.1858)), // Numbi Gate
  NationalPark("Addo Elephant National Park", LatLng(-33.4828, 25.7538)),
  NationalPark("Table Mountain National Park", LatLng(-34.0522, 18.4023)),
  NationalPark("Kgalagadi Transfrontier Park", LatLng(-25.8880, 20.6194)), // Twee Rivieren Gate
  NationalPark("Golden Gate Highlands National Park", LatLng(-28.5167, 28.6167)),
  NationalPark("Mapungubwe National Park", LatLng(-22.2038, 29.3877)),
  NationalPark("Marakele National Park", LatLng(-24.5333, 27.5167)),
  NationalPark("Hluhluwe-iMfolozi Park", LatLng(-28.1770, 31.9926)), // Memorial Gate
];

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  // Falls back to Kruger National Park until the user's location is known.
  static const _fallbackCenter = LatLng(-23.9884, 31.5547);

  Position? _userPosition;
  NationalPark? _nearestPark;
  bool _loadingLocation = false;
  String? _locationError;

  Future<bool> _ensureLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      _locationError = "Location services are turned off on this device.";
      return false;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      _locationError =
          "Location permission was denied. Enable it in your device settings.";
      return false;
    }
    if (permission == LocationPermission.denied) {
      _locationError = "Location permission is required to find the nearest park.";
      return false;
    }
    return true;
  }

  Future<void> _findNearestPark() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });

    final hasPermission = await _ensureLocationPermission();
    if (!hasPermission) {
      setState(() => _loadingLocation = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      var nearest = kNationalParks.first;
      var nearestDistance = double.infinity;
      for (final park in kNationalParks) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          park.mainGate.latitude,
          park.mainGate.longitude,
        );
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearest = park;
        }
      }

      setState(() {
        _userPosition = position;
        _nearestPark = nearest;
        _loadingLocation = false;
      });

      final userLatLng = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(_bounds(userLatLng, nearest.mainGate), 80),
      );
    } catch (e) {
      setState(() {
        _locationError = "Couldn't get your location. Please try again.";
        _loadingLocation = false;
      });
    }
  }

  LatLngBounds _bounds(LatLng a, LatLng b) {
    return LatLngBounds(
      southwest: LatLng(min(a.latitude, b.latitude), min(a.longitude, b.longitude)),
      northeast: LatLng(max(a.latitude, b.latitude), max(a.longitude, b.longitude)),
    );
  }

  Future<void> _startDirections() async {
    final park = _nearestPark;
    if (park == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${park.mainGate.latitude},${park.mainGate.longitude}'
      '&travelmode=driving',
    );

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open directions.")),
      );
    }
  }

  Set<Marker> get _markers {
    final markers = <Marker>{};
    final position = _userPosition;
    if (position != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('me'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: "You are here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }
    final park = _nearestPark;
    if (park != null) {
      markers.add(
        Marker(
          markerId: MarkerId(park.name),
          position: park.mainGate,
          infoWindow: InfoWindow(title: park.name, snippet: "Main Gate"),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🗺️ Safari Map"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(target: _fallbackCenter, zoom: 6),
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            markers: _markers,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel() {
    if (_loadingLocation) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text("Finding your nearest park..."),
        ],
      );
    }

    if (_locationError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_locationError!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _findNearestPark,
            child: const Text("Try Again"),
          ),
        ],
      );
    }

    final park = _nearestPark;
    final position = _userPosition;
    if (park == null || position == null) {
      return ElevatedButton.icon(
        onPressed: _findNearestPark,
        icon: const Icon(Icons.my_location),
        label: const Text("Find Nearest Park"),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      );
    }

    final distanceKm = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          park.mainGate.latitude,
          park.mainGate.longitude,
        ) /
        1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Nearest Park: ${park.name}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text("${distanceKm.toStringAsFixed(1)} km away"),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _startDirections,
          icon: const Icon(Icons.directions),
          label: const Text("Start Directions to Main Gate"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
