import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? bloodType;
  final bool isDonor;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.bloodType,
    this.isDonor = false,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Handle difference between Google Auth (displayName) and Form Auth (firstName + lastName)
    String name = data['displayName'] ?? '';
    if (name.isEmpty) {
      final first = data['firstName'] ?? '';
      final last = data['lastName'] ?? '';
      name = '$first $last'.trim();
    }

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: name,
      photoUrl: data['photoURL'] ?? data['profileImageUrl'], // Handle both naming conventions
      phoneNumber: data['phoneNumber'],
      bloodType: data['bloodType'],
      isDonor: data['isDonor'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoUrl,
      'phoneNumber': phoneNumber,
      'bloodType': bloodType,
      'isDonor': isDonor,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? bloodType,
    bool? isDonor,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bloodType: bloodType ?? this.bloodType,
      isDonor: isDonor ?? this.isDonor,
    );
  }
}