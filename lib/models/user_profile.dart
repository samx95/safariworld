import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds profile state shared across screens (e.g. the home screen greeting
/// and the profile screen itself), so an edit in one place is reflected
/// everywhere without threading state through navigation. Persisted to disk
/// via [SharedPreferences] so it survives app restarts on the same device.
class UserProfile {
  UserProfile._();

  static final instance = UserProfile._();

  static const _nameKey = 'profile_name';
  static const _avatarKey = 'profile_avatar_base64';

  final ValueNotifier<String> name = ValueNotifier<String>("Explorer Name");
  final ValueNotifier<Uint8List?> avatarBytes = ValueNotifier<Uint8List?>(null);

  bool _loaded = false;

  /// Loads any previously saved profile data. Call once at startup, before
  /// the UI reads [name] or [avatarBytes].
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    final prefs = await SharedPreferences.getInstance();

    final storedName = prefs.getString(_nameKey);
    if (storedName != null && storedName.isNotEmpty) {
      name.value = storedName;
    }

    final storedAvatar = prefs.getString(_avatarKey);
    if (storedAvatar != null) {
      try {
        avatarBytes.value = base64Decode(storedAvatar);
      } catch (_) {
        // Corrupt/old data, ignore and keep the default.
      }
    }
  }

  Future<void> setName(String newName) async {
    name.value = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, newName);
  }

  Future<void> setAvatar(Uint8List bytes) async {
    avatarBytes.value = bytes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, base64Encode(bytes));
  }
}
