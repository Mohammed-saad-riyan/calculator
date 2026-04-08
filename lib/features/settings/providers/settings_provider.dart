import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<Map<String, dynamic>> build() async {
    return await _loadSettings();
  }

  Future<Map<String, dynamic>> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'theme': prefs.getString('theme') ?? 'light',
      'notifications': prefs.getBool('notifications') ?? true,
    };
  }

  Future<void> updateTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    
    final currentSettings = state.value ?? {};
    state = AsyncValue.data({
      ...currentSettings,
      'theme': theme,
    });
  }

  Future<void> updateNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
    
    final currentSettings = state.value ?? {};
    state = AsyncValue.data({
      ...currentSettings,
      'notifications': enabled,
    });
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme');
    await prefs.remove('notifications');
    
    state = const AsyncValue.data({
      'theme': 'light',
      'notifications': true,
    });
  }
}