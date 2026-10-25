import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';

/// Local-only auth for demo builds. Replace with [AppRepository] login/signup later.
class DemoAuthService extends ChangeNotifier {
  static const _loggedInKey = 'demo_is_logged_in';
  static const _sessionKey = 'demo_session_user';
  static const _usersKey = 'demo_registered_users';

  bool _loaded = false;
  bool _isLoggedIn = false;
  DemoUserProfile? _sessionUser;

  bool get isLoaded => _loaded;
  bool get isLoggedIn => _isLoggedIn;
  DemoUserProfile? get sessionUser => _sessionUser;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    final raw = prefs.getString(_sessionKey);
    if (raw != null) {
      _sessionUser = DemoUserProfile.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    }
    await _ensureSeedDemoAccount(prefs);
    _loaded = true;
    notifyListeners();
  }

  Future<void> _ensureSeedDemoAccount(SharedPreferences prefs) async {
    final users = await _readUsers(prefs);
    const seedEmail = 'demo@softkhata.app';
    if (!users.any((u) => u.email.toLowerCase() == seedEmail)) {
      users.add(
        _StoredUser(
          name: 'Asad Khan',
          email: seedEmail,
          phone: '+92 300 1234567',
          password: 'demo123',
          businessName: 'Asad Traders',
          businessCategory: 'General Store',
        ),
      );
      await _writeUsers(prefs, users);
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _readUsers(prefs);
    final match = users.where(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (match.isEmpty) {
      return 'No account found for this email. Please register first.';
    }
    final user = match.first;
    if (user.password != password) {
      return 'Incorrect password. Try again or use demo@softkhata.app / demo123';
    }
    await _persistSession(prefs, user.toProfile());
    return null;
  }

  Future<String?> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String businessName,
    required String businessCategory,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _readUsers(prefs);
    final normalized = email.trim().toLowerCase();
    if (users.any((u) => u.email.toLowerCase() == normalized)) {
      return 'An account with this email already exists. Please log in.';
    }
    final stored = _StoredUser(
      name: name.trim(),
      email: normalized,
      phone: phone.trim(),
      password: password,
      businessName: businessName.trim(),
      businessCategory: businessCategory.trim(),
    );
    users.add(stored);
    await _writeUsers(prefs, users);
    await _persistSession(prefs, stored.toProfile());
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    await prefs.remove(_sessionKey);
    _isLoggedIn = false;
    _sessionUser = null;
    notifyListeners();
  }

  Future<void> _persistSession(
    SharedPreferences prefs,
    DemoUserProfile profile,
  ) async {
    _sessionUser = profile;
    _isLoggedIn = true;
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_sessionKey, jsonEncode(profile.toJson()));
    notifyListeners();
  }

  Future<List<_StoredUser>> _readUsers(SharedPreferences prefs) async {
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => _StoredUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeUsers(
    SharedPreferences prefs,
    List<_StoredUser> users,
  ) async {
    await prefs.setString(
      _usersKey,
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }
}

class _StoredUser {
  _StoredUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.businessName,
    required this.businessCategory,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final String businessName;
  final String businessCategory;

  factory _StoredUser.fromJson(Map<String, dynamic> json) => _StoredUser(
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        password: json['password'] as String,
        businessName: json['businessName'] as String,
        businessCategory: json['businessCategory'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'businessName': businessName,
        'businessCategory': businessCategory,
      };

  DemoUserProfile toProfile() => DemoUserProfile(
        name: name,
        phone: phone,
        email: email,
        role: StaffRole.owner,
        businessName: businessName,
        businessCategory: businessCategory,
      );
}
