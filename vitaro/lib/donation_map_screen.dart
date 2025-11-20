import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationMapScreen extends StatefulWidget {
  const DonationMapScreen({super.key});

  @override
  State<DonationMapScreen> createState() => _DonationMapScreenState();
}

class _DonationMapScreenState extends State<DonationMapScreen> {
  late GoogleMapController mapController;
  // Default location: Kigali
  final LatLng _initialPosition = const LatLng(-1.9441, 30.0619);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadCenters();
  }

  void _loadCenters() {
    // These are the test spots. Later we connect this to your database.
    List<Map<String, dynamic>> centers = [
      {
        "id": "1",
        "name": "Kigali Regional Center",
        "lat": -1.9530,
        "lng": 30.0920,
      },
      {
        "id": "2",
        "name": "CHUK Hospital",
        "lat": -1.9550,
        "lng": 30.0600,
      }
    ];

    for (var c in centers) {
      _markers.add(Marker(
        markerId: MarkerId(c['id']),
        position: LatLng(c['lat'], c['lng']),
        infoWindow: InfoWindow(
          title: c['name'],
          snippet: "Tap for Directions",
          onTap: () => _launchMaps(c['lat'], c['lng']),
        ),
      ));
    }
    setState(() {});
  }

  Future<void> _launchMaps(double lat, double lng) async {
    final googleUrl = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      debugPrint('Could not launch maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}