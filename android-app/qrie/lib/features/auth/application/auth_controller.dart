import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/rfc7807_error.dart';
import '../../../core/storage/secure_storage.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  guestMode,
  unauthenticated,
  sessionExpired,
  unauthorizedRole,
  error,
}

class AuthUser {
  final String id;
  final String name;
  final String role;
  final String? schoolId;
  final String grade;
  final String board;

  const AuthUser({
    required this.id,
    required this.name,
    this.role = 'student',
    this.schoolId,
    required this.grade,
    required this.board,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String? ?? 'guest-id',
      name: json['name'] as String? ?? 'Student',
      role: json['role'] as String? ?? 'student',
      schoolId: json['school_id'] as String?,
      grade: json['grade'] as String? ?? 'Class 8',
      board: json['board'] as String? ?? 'CBSE',
    );
  }

  factory AuthUser.guest() {
    return const AuthUser(
      id: 'guest_student',
      name: 'Curious Learner',
      role: 'student',
      grade: 'Class 8',
      board: 'CBSE',
    );
  }
}

class AuthController extends ChangeNotifier {
  final ApiClient apiClient;
  final SecureStorageService secureStorage;

  AuthStatus _status = AuthStatus.initial;
  AuthUser? _currentUser;
  String? _errorMessage;

  AuthController({
    required this.apiClient,
    required this.secureStorage,
  });

  AuthStatus get status => _status;
  AuthUser? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated || _status == AuthStatus.guestMode;

  /// Check stored session on startup
  Future<void> initializeSession() async {
    try {
      final token = await secureStorage.getAccessToken();
      final role = await secureStorage.getUserRole();
      final studentId = await secureStorage.getStudentId();

      if (token != null && token.isNotEmpty) {
        if (role != null && role != 'student') {
          _status = AuthStatus.unauthorizedRole;
          _errorMessage = 'Only student accounts can access the student mobile app.';
          notifyListeners();
          return;
        }

        // Student has stored session
        _currentUser = AuthUser(
          id: studentId ?? 'student_restored',
          name: 'Student',
          role: role ?? 'student',
          grade: 'Class 8',
          board: 'CBSE',
        );
        _status = AuthStatus.authenticated;
      } else {
        // By default on first open, let user explore as guest or sign in
        _currentUser = AuthUser.guest();
        _status = AuthStatus.guestMode;
      }
    } catch (e) {
      _currentUser = AuthUser.guest();
      _status = AuthStatus.guestMode;
    }
    notifyListeners();
  }

  /// Sign in with school code & student ID
  Future<bool> signInWithSchoolCode({
    required String schoolCode,
    required String studentRollOrEmail,
    required String pinOrPassword,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiClient.post(
        '/auth/session',
        data: {
          'school_code': schoolCode.trim().toUpperCase(),
          'identifier': studentRollOrEmail.trim(),
          'credential': pinOrPassword,
        },
      );

      if (response is Map<String, dynamic>) {
        final role = response['user']?['role'] as String? ?? 'student';
        if (role != 'student') {
          _status = AuthStatus.unauthorizedRole;
          _errorMessage = 'This login is for student accounts only. Teachers/Admins must use the Web portal.';
          notifyListeners();
          return false;
        }

        final accessToken = response['access_token'] as String? ?? '';
        final refreshToken = response['refresh_token'] as String?;
        final userMap = (response['user'] as Map<String, dynamic>?) ?? {};

        _currentUser = AuthUser.fromJson(userMap);

        await secureStorage.saveAuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          studentId: _currentUser!.id,
          schoolId: _currentUser!.schoolId,
          role: role,
        );

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }

      throw ProblemDetails(
        title: 'Authentication Failed',
        status: 400,
        detail: 'Invalid response from server.',
      );
    } on ProblemDetails catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.detail;
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Sign in failed. Please check credentials or continue as guest.';
      notifyListeners();
      return false;
    }
  }

  /// Continue as Guest (instant offline-first access without barriers)
  void continueAsGuest() {
    _currentUser = AuthUser.guest();
    _status = AuthStatus.guestMode;
    _errorMessage = null;
    notifyListeners();
  }

  /// Sign out
  Future<void> signOut() async {
    await secureStorage.clearSession();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Triggered on 401 session expiration
  void handleSessionExpired() {
    _status = AuthStatus.sessionExpired;
    _errorMessage = 'Your session has expired. Please sign in again.';
    notifyListeners();
  }
}
