import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vitaro/features/centers/models/blood_center.dart';

class CentersRepository {
  CentersRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<BloodCenter>> fetchCenters() async {
    final query = await _firestore.collection('centers').get();
    return query.docs
        .map((doc) => BloodCenter.fromFirestore(doc))
        .toList(growable: false);
  }

  Future<List<BloodCenter>> fetchNearbyCenters(
    Position position, {
    double radiusInKm = 50,
  }) async {
    final centers = await fetchCenters();
    return centers
        .where(
          (center) =>
              _distanceInKm(
                position.latitude,
                position.longitude,
                center.location.latitude,
                center.location.longitude,
              ) <=
              radiusInKm,
        )
        .toList(growable: false);
  }

  double _distanceInKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a =
        (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            (math.sin(dLon / 2) * math.sin(dLon / 2));
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);
}
