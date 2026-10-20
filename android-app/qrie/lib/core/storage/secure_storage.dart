import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Service
/// Uses Android Keystore-backed AES encryption to store authentication tokens
/// and sensitive student session identifiers.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                resetOnError: true,
              ),
            );

  static const _keyAccessToken = 'qrie_access_token';
  static const _keyRefreshToken = 'qrie_refresh_token';
  static const _keyStudentId = 'qrie_student_id';
  static const _keySchoolId = 'qrie_school_id';
  static const _keyUserRole = 'qrie_user_role';

  Future<void> saveAuthTokens({
    required String accessToken,
    String? refreshToken,
    required String studentId,
    String? schoolId,
    String role = 'student',
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    }
    await _storage.write(key: _keyStudentId, value: studentId);
    if (schoolId != null) {
      await _storage.write(key: _keySchoolId, value: schoolId);
    }
    await _storage.write(key: _keyUserRole, value: role);
  }

  Future<String?> getAccessToken() async => await _storage.read(key: _keyAccessToken);
  Future<String?> getRefreshToken() async => await _storage.read(key: _keyRefreshToken);
  Future<String?> getStudentId() async => await _storage.read(key: _keyStudentId);
  Future<String?> getSchoolId() async => await _storage.read(key: _keySchoolId);
  Future<String?> getUserRole() async => await _storage.read(key: _keyUserRole);

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyStudentId);
    await _storage.delete(key: _keySchoolId);
    await _storage.delete(key: _keyUserRole);
  }
}
