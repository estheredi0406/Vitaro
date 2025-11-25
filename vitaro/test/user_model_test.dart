import 'package:flutter_test/flutter_test.dart';
import 'package:vitaro/core/models/user_model.dart';

void main() {
  group('UserModel Unit Tests', () {
    // Test Case 1: Verify it correctly handles "Form Auth" data (First/Last name split)
    test('fromMap creates UserModel correctly with full name fallback logic', () {
      // Arrange: Create a simple map (no Firestore classes needed!)
      const userId = 'test_uid_123';
      final userData = {
        'email': 'john.doe@example.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'phoneNumber': '1234567890',
        'bloodType': 'A+',
        'isDonor': true,
        // Note: 'displayName' and 'username' are missing to test fallback logic
      };

      // Act: Use our new testable factory
      final user = UserModel.fromMap(userData, userId);

      // Assert: Check if logic worked
      expect(user.uid, userId);
      expect(user.email, 'john.doe@example.com');
      expect(user.displayName, 'John Doe'); // Logic combined first + last
      expect(user.username, 'john.doe'); // Logic fell back to email prefix
      expect(user.bloodType, 'A+');
      expect(user.isDonor, true);
    });

    // Test Case 2: Verify it correctly handles "Google Auth" data (displayName present)
    test('fromMap uses existing displayName and username if present', () {
      // Arrange
      const userId = 'test_uid_456';
      final userData = {
        'email': 'jane@example.com',
        'displayName': 'Jane Smith', // Already set
        'username': 'janesmith88',   // Already set
        'photoURL': 'http://example.com/pic.jpg',
      };

      // Act
      final user = UserModel.fromMap(userData, userId);

      // Assert
      expect(user.displayName, 'Jane Smith'); // Should use existing, not fallback
      expect(user.username, 'janesmith88');   // Should use existing
      expect(user.photoUrl, 'http://example.com/pic.jpg');
    });
  });
}