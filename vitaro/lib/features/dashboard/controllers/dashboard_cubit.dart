import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Removed: equatable (not needed here anymore if used in state)
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:vitaro/features/dashboard/models/dashboard_user.dart';
import 'package:vitaro/features/dashboard/models/recent_activity.dart';

// CHANGED: Import the state file instead of using 'part'
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DashboardCubit({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance,
      super(DashboardInitial());

  Future<void> fetchDashboardData() async {
    try {
      emit(DashboardLoading());

      // runtime mock flag
      const useMock = bool.fromEnvironment(
        'USE_MOCK_DASHBOARD',
        defaultValue: false,
      );
      if (kDebugMode && useMock) {
        final mockUser = DashboardUser(
          id: 'mock-id',
          name: 'Dev User',
          bloodType: 'O+',
          profileImageUrl: '',
          isEligible: true,
          hemoglobin: 13.5,
          pulse: 72,
          bloodPressureSystolic: 120,
          bloodPressureDiastolic: 80,
        );
        final mockActivities = <RecentActivity>[];
        emit(DashboardLoaded(user: mockUser, activities: mockActivities));
        return;
      }

      // Ensure authenticated user
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        try {
          final credential = await _auth.signInAnonymously();
          firebaseUser = credential.user;
        } on FirebaseAuthException catch (authEx) {
          if (authEx.code == 'operation-not-allowed' ||
              (authEx.message?.toLowerCase().contains('administrators') ??
                  false)) {
            emit(DashboardUnauthenticated());
            return;
          }
          emit(
            DashboardError(
              'Authentication failed: ${authEx.message ?? authEx.code}',
            ),
          );
          return;
        } catch (e) {
          emit(DashboardError('Authentication failed.'));
          return;
        }
      }

      final userId = firebaseUser?.uid;
      if (userId == null) {
        emit(DashboardUnauthenticated());
        return;
      }

      // Ensure donor doc exists
      final userRef = _firestore.collection('users').doc(userId);
      late DocumentSnapshot<Map<String, dynamic>> userDoc;
      try {
        userDoc = await userRef.get();
      } catch (e) {
        emit(DashboardError('Failed to read donor data: $e'));
        return;
      }

      if (!userDoc.exists) {
        final created = await _createMinimalDonorRecord(userRef, userId);
        if (!created) {
          emit(
            DashboardError('Donor data not found and could not be created.'),
          );
          return;
        }
        userDoc = await userRef.get();
        if (!userDoc.exists) {
          emit(DashboardError('Donor data not found after creation.'));
          return;
        }
      }

      final user = DashboardUser.fromFirestore(userDoc);

      // Fetch recent donation activity
      final activities = <RecentActivity>[];
      try {
        final donationSnapshot = await _firestore
            .collection('donations')
            .where('donorId', isEqualTo: userId)
            .orderBy('donationDate', descending: true)
            .limit(1)
            .get();

        if (donationSnapshot.docs.isNotEmpty) {
          activities.add(
            RecentActivity.fromDonation(donationSnapshot.docs.first),
          );
        }
      } catch (e) {
        // non-fatal; continue
      }

      // Fetch recent alerts if bloodType available
      final bloodType = user.bloodType.toString().trim();
      if (bloodType.isNotEmpty && bloodType.toLowerCase() != 'unknown') {
        try {
          final alertSnapshot = await _firestore
              .collection('emergency_alerts')
              .where('bloodType', isEqualTo: bloodType)
              .orderBy('createdAt', descending: true)
              .limit(1)
              .get();

          if (alertSnapshot.docs.isNotEmpty) {
            activities.add(RecentActivity.fromAlert(alertSnapshot.docs.first));
          }
        } catch (e) {
          // non-fatal
        }
      }

      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      emit(
        DashboardLoaded(user: user, activities: activities.take(2).toList()),
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<bool> _createMinimalDonorRecord(
    DocumentReference userRef,
    String userId,
  ) async {
    try {
      await userRef.set({
        'uid': userId,
        'name': '',
        'bloodType': 'unknown',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }
}
