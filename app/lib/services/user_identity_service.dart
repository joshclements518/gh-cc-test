import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Honor system user identity service (ADR-1)
/// Stores user UUID and display name in localStorage (shared_preferences)
class UserIdentityService {
  static const String _keyUserId = 'snack-voting:currentUser:id';
  static const String _keyUserName = 'snack-voting:currentUser:name';

  SharedPreferences? _prefs;
  String? _userId;
  String? _userName;

  /// Initialize the service and load existing user identity
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _userId = _prefs?.getString(_keyUserId);
    _userName = _prefs?.getString(_keyUserName);
  }

  /// Check if user identity exists
  bool get hasIdentity => _userId != null && _userName != null;

  /// Get current user ID (UUID)
  String? get userId => _userId;

  /// Get current user display name
  String? get userName => _userName;

  /// Create new user identity with display name
  /// Generates UUID and persists to localStorage
  Future<void> createIdentity(String displayName) async {
    if (_prefs == null) {
      throw StateError('UserIdentityService not initialized');
    }

    final uuid = const Uuid().v4();
    _userId = uuid;
    _userName = displayName;

    await _prefs!.setString(_keyUserId, uuid);
    await _prefs!.setString(_keyUserName, displayName);
  }

  /// Clear user identity from localStorage
  /// Returns user to first-time visitor state
  Future<void> clearIdentity() async {
    if (_prefs == null) {
      throw StateError('UserIdentityService not initialized');
    }

    await _prefs!.remove(_keyUserId);
    await _prefs!.remove(_keyUserName);
    _userId = null;
    _userName = null;
  }

  /// Update display name (keeps same UUID)
  Future<void> updateDisplayName(String newName) async {
    if (_prefs == null) {
      throw StateError('UserIdentityService not initialized');
    }
    if (_userId == null) {
      throw StateError('No user identity exists');
    }

    _userName = newName;
    await _prefs!.setString(_keyUserName, newName);
  }
}
