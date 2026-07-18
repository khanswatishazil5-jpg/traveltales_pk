import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

/// Handles signup/login/logout for a single local profile, stored on-device
/// with SharedPreferences. This is a frontend-only stand-in: once the
/// backend phase resumes, these methods are the natural place to swap in
/// real HTTP calls to an auth endpoint (same shape as ApiService already
/// does for posts) — nothing in the screens should need to change.
///
/// NOTE: password is hashed (SHA-256) before storage, but there's no
/// server, no salt, and no real session/token — this is only meant to
/// simulate "signed up and remembered" on one device, not production auth.
class AuthService {
  static const _kUsername = 'profile_username';
  static const _kEmail = 'profile_email';
  static const _kBio = 'profile_bio';
  static const _kAvatarInitials = 'profile_avatar_initials';
  static const _kAvatarImage = 'profile_avatar_image_base64';
  static const _kPasswordHash = 'profile_password_hash';
  static const _kLoggedIn = 'profile_logged_in';

  String _hash(String value) => sha256.convert(utf8.encode(value)).toString();

  String _initialsFrom(String username) {
    final trimmed = username.trim();
    if (trimmed.length >= 2) return trimmed.substring(0, 2).toUpperCase();
    if (trimmed.isEmpty) return '??';
    return trimmed.toUpperCase();
  }

  /// True once a profile has ever been created on this device
  /// (even if the user is currently logged out).
  Future<bool> hasAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_kUsername);
  }

  /// True if there's a profile AND the user is currently logged in,
  /// i.e. the app should open straight to the home shell.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  Future<ProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_kUsername);
    if (username == null) return null;
    return ProfileModel(
      username: username,
      email: prefs.getString(_kEmail) ?? '',
      bio: prefs.getString(_kBio) ?? '',
      avatarInitials: prefs.getString(_kAvatarInitials) ?? _initialsFrom(username),
      avatarImageBase64: prefs.getString(_kAvatarImage),
    );
  }

  Future<void> updateAvatarImage(String base64Image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAvatarImage, base64Image);
  }

  /// Creates the one profile this device holds. Returns an error message
  /// on failure, or null on success.
  Future<String?> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final cleanEmail = email.trim();

    if (cleanUsername.length < 3) {
      return 'Username must be at least 3 characters.';
    }
    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      return 'Enter a valid email address.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_kUsername)) {
      return 'An account already exists on this device. Log in instead.';
    }

    await prefs.setString(_kUsername, cleanUsername);
    await prefs.setString(_kEmail, cleanEmail);
    await prefs.setString(_kBio, 'New to Travel Tales ✈️');
    await prefs.setString(_kAvatarInitials, _initialsFrom(cleanUsername));
    await prefs.setString(_kPasswordHash, _hash(password));
    await prefs.setBool(_kLoggedIn, true);
    return null;
  }

  /// Logs into the one profile this device holds. Returns an error message
  /// on failure, or null on success.
  Future<String?> logIn({
    required String usernameOrEmail,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString(_kUsername);
    final storedEmail = prefs.getString(_kEmail);
    final storedHash = prefs.getString(_kPasswordHash);

    if (storedUsername == null) {
      return 'No account found on this device. Sign up first.';
    }

    final input = usernameOrEmail.trim().toLowerCase();
    final matchesIdentity = input == storedUsername.toLowerCase() ||
        input == (storedEmail ?? '').toLowerCase();
    if (!matchesIdentity) {
      return 'No account matches that username or email.';
    }
    if (_hash(password) != storedHash) {
      return 'Incorrect password.';
    }

    await prefs.setBool(_kLoggedIn, true);
    return null;
  }

  Future<void> updateBio(String bio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBio, bio);
  }

  /// Logs out but keeps the account itself, so the same username/password
  /// can log back in later — this only clears the "logged in" flag.
  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
  }
}
