import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:vitaro/core/models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  final String _cloudName = 'dnpomawqd';
  final String _uploadPreset = 'Vitaro';

  ProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Get current user profile
  Future<UserModel> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      // If doc doesn't exist (rare), create a basic one from Auth data
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
        photoUrl: user.photoURL,
      );
    }
    return UserModel.fromFirestore(doc);
  }

  // Update text details
  Future<void> updateProfile(UserModel updatedUser) async {
    await _firestore
        .collection('users')
        .doc(updatedUser.uid)
        .update(updatedUser.toMap());

    // Also update the Auth object for immediate consistency
    await _auth.currentUser?.updateDisplayName(updatedUser.displayName);
    if (updatedUser.photoUrl != null) {
      await _auth.currentUser?.updatePhotoURL(updatedUser.photoUrl);
    }
  }

  // Upload Image to Cloudinary
  Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(responseString);
      return jsonMap['secure_url'];
    } else {
      throw Exception('Failed to upload image: $responseString');
    }
  }
}