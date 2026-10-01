import '../models/user_profile.dart';

class AuthRepository {
  // ---------------------------------------------------------------------------
  // TEMPORARY AUTHENTICATION CREDENTIALS
  // Used until Firebase Authentication is connected to the project.
  // ---------------------------------------------------------------------------
  static const String tempEmail = 'test@example.com';
  static const String tempPassword = '123456';

  UserProfile? _currentUser;
  bool _isLoggedIn = false;

  /// Checks if a user is currently logged in for the active session in memory.
  /// Does NOT use SharedPreferences, SecureStorage, Hive, or any local tokens.
  /// Automatically resets to null when the app is closed and reopened.
  Future<UserProfile?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _isLoggedIn ? _currentUser : null;
  }

  /// Temporary login logic: validates against [tempEmail] and [tempPassword].
  ///
  /// Later, replace with Firebase Authentication:
  /// ```dart
  /// final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  ///   email: email,
  ///   password: password,
  /// );
  /// return _mapFirebaseUser(credential.user);
  /// ```
  Future<UserProfile> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (email.trim().toLowerCase() == tempEmail.toLowerCase() && password == tempPassword) {
      _isLoggedIn = true;
      _currentUser = const UserProfile(
        id: 'u1',
        name: 'Alex Johnson',
        email: tempEmail,
        phone: '+1 (555) 234-5678',
        avatarIndex: 0,
        wishlistCount: 12,
        historyCount: 10,
      );
      return _currentUser!;
    } else {
      throw Exception('Invalid email or password. Please use $tempEmail and $tempPassword');
    }
  }

  /// Temporary register logic until Firebase Auth is connected.
  Future<UserProfile> register(String name, String email, String password, String phone) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _isLoggedIn = true;
    _currentUser = UserProfile(
      id: 'u2',
      name: name,
      email: email,
      phone: phone,
      avatarIndex: 0,
      wishlistCount: 0,
      historyCount: 0,
    );
    return _currentUser!;
  }

  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<UserProfile> updateUserProfile(String name, String phone, int avatarIndex) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = (_currentUser ?? const UserProfile(
      id: 'u1',
      name: 'Alex Johnson',
      email: tempEmail,
      phone: '+1 (555) 234-5678',
      avatarIndex: 0,
      wishlistCount: 12,
      historyCount: 10,
    )).copyWith(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isLoggedIn = false;
    _currentUser = null;
  }
}
