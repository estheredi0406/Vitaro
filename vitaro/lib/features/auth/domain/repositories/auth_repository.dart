// lib/features/auth/domain/repositories/auth_repository.dart

abstract class AuthRepository {
  /// Retrieves the unique ID of the currently authenticated user.
  ///
  /// Returns the user's ID as a String, or null if no user is signed in.
  Future<String?> getCurrentUserId();

  // Future<void> signIn(String email, String password); // Example of a future method
}
