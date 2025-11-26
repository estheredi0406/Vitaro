import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Authentication Service for handling Firebase Auth operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  // Web Client ID for Google Sign-In
  static const String _serverClientId =
      '284994311059-nsd1bq2j9n9g91jdbegsij8834nnfier.apps.googleusercontent.com';

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  /// Returns a Map with 'success' boolean and 'message' string
  Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return {'success': true, 'message': 'Login successful'};
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address format.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message ?? 'Unknown error'}';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  /// Send password reset email
  /// Returns a Map with 'success' boolean and 'message' string
  Future<Map<String, dynamic>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return {
        'success': true,
        'message':
            'Password reset email sent to $email. Please check your inbox.',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address format.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage =
              'Failed to send reset email: ${e.message ?? 'Unknown error'}';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  /// Sign in with Google
  /// Returns a Map with 'success' boolean and 'message' string
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In with server client ID
      await _googleSignIn.initialize(serverClientId: _serverClientId);

      // Trigger the Google authentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Obtain the auth details from the Google account
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await _auth.signInWithCredential(credential);

      return {'success': true, 'message': 'Google sign-in successful'};
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'An account already exists with this email using a different sign-in method.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials. Please try again.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not enabled in Firebase Console.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage =
              'Google sign-in failed: ${e.message ?? 'Unknown error'}';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'Google sign-in error: ${e.toString()}',
      };
    }
  }

  /// Sign in with Facebook
  /// Returns a Map with 'success' boolean and 'message' string
  Future<Map<String, dynamic>> signInWithFacebook() async {
    try {
      // Trigger the Facebook Sign-In flow
      final LoginResult result = await _facebookAuth.login();

      // Check if login was successful
      if (result.status == LoginStatus.success) {
        // Get the access token
        final AccessToken? accessToken = result.accessToken;

        if (accessToken == null) {
          return {
            'success': false,
            'message': 'Failed to get Facebook access token',
          };
        }

        // Get the token string
        final String token = accessToken.token;

        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(
          token,
        );

        // Sign in to Firebase with the Facebook credential
        await _auth.signInWithCredential(credential);

        return {'success': true, 'message': 'Facebook sign-in successful'};
      } else if (result.status == LoginStatus.cancelled) {
        return {'success': false, 'message': 'Facebook sign-in cancelled'};
      } else {
        return {
          'success': false,
          'message':
              'Facebook sign-in failed: ${result.message ?? 'Unknown error'}',
        };
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'An account already exists with this email using a different sign-in method.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials. Please try again.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Facebook sign-in is not enabled.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage =
              'Facebook sign-in failed: ${e.message ?? 'Unknown error'}';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred during Facebook sign-in: $e',
      };
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();

    // Try to sign out from Google (ignore errors if not signed in with Google)
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore - user may not have signed in with Google
    }

    // Try to sign out from Facebook (ignore errors if not signed in with Facebook)
    try {
      await _facebookAuth.logOut();
    } catch (_) {
      // Ignore - user may not have signed in with Facebook
    }
  }

  /// Create account with email and password
  /// Returns a Map with 'success' boolean and 'message' string
  Future<Map<String, dynamic>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return {'success': true, 'message': 'Account created successfully'};
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address format.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage =
              'Password is too weak. Please use a stronger password.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage =
              'Account creation failed: ${e.message ?? 'Unknown error'}';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }
}
