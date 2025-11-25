import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String username; // Added
  final String? photoUrl;
  final String? phoneNumber;
  final String? bloodType; // Added
  final bool isDonor;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.username,
    this.photoUrl,
    this.phoneNumber,
    this.bloodType,
    this.isDonor = false,
  });

  // Factory that calls the helper method, keeping Firestore dependency isolated
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>? ?? {}, doc.id);
  }

  // New helper factory for easier testing (and cleaner code)
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    // Handle Name Logic
    String name = data['displayName'] ?? '';
    if (name.isEmpty) {
      final first = data['firstName'] ?? '';
      final last = data['lastName'] ?? '';
      name = '$first $last'.trim();
    }

    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      displayName: name,
      // Fallback to email prefix if username is missing
      username: data['username'] ?? (data['email']?.split('@')[0] ?? 'User'),
      photoUrl: data['photoURL'] ?? data['profileImageUrl'],
      phoneNumber: data['phoneNumber'],
      bloodType: data['bloodType'],
      isDonor: data['isDonor'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'username': username,
      'photoURL': photoUrl,
      'phoneNumber': phoneNumber,
      'bloodType': bloodType,
      'isDonor': isDonor,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? username,
    String? photoUrl,
    String? phoneNumber,
    String? bloodType,
    bool? isDonor,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bloodType: bloodType ?? this.bloodType,
      isDonor: isDonor ?? this.isDonor,
    );
  }
}