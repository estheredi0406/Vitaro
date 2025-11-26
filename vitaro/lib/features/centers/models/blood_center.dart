import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BloodCenter extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String status;
  final GeoPoint location;
  final List<String> services;
  final String openingHours;

  const BloodCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.status,
    required this.location,
    required this.services,
    required this.openingHours,
  });

  factory BloodCenter.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return BloodCenter(
      id: doc.id,
      name: data['name'] as String? ?? 'Unknown Center',
      address: data['address'] as String? ?? 'No address provided',
      phone: data['phone'] as String? ?? 'N/A',
      status: data['status'] as String? ?? 'Unknown',
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      services: List<String>.from(
        data['services'] as List? ?? const <String>[],
      ),
      openingHours: data['openingHours'] as String? ?? 'Not specified',
    );
  }

  LatLng get coordinates => LatLng(location.latitude, location.longitude);

  bool get isOpen => status.toLowerCase() == 'open';

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    phone,
    status,
    location,
    services,
    openingHours,
  ];
}
