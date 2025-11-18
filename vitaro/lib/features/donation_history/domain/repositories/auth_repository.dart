// lib/features/auth/domain/repositories/auth_repository.dart

abstract class AuthRepository {
  Future<String?> getCurrentUserId();
}
