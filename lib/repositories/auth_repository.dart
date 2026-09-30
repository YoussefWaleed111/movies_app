import '../models/user_profile.dart';

class AuthRepository {
  UserProfile _currentUser = const UserProfile(
    id: 'u1',
    name: 'Alex Johnson',
    email: 'alex.johnson@cinemabloc.com',
    phone: '+1 (555) 234-5678',
    avatarIndex: 0,
    wishlistCount: 12,
    historyCount: 10,
  );

  bool _isLoggedIn = true;

  Future<UserProfile?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _isLoggedIn ? _currentUser : null;
  }

  Future<UserProfile> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _isLoggedIn = true;
    _currentUser = _currentUser.copyWith(email: email);
    return _currentUser;
  }

  Future<UserProfile> register(String name, String email, String password, String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
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
    return _currentUser;
  }

  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserProfile> updateUserProfile(String name, String phone, int avatarIndex) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = _currentUser.copyWith(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
    );
    return _currentUser;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoggedIn = false;
  }
}
