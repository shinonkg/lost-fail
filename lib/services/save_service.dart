import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/save_state.dart';

class SaveService {
  static const _saveKey = 'kayip_dosyalar_save_v1';

  Future<SaveState> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_saveKey);
    if (raw == null || raw.isEmpty) {
      return SaveState();
    }
    return SaveState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(SaveState state) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_saveKey, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_saveKey);
  }
}
