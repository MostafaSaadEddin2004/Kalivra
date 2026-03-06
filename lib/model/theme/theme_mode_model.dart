import 'package:flutter/material.dart';

/// Model for theme mode option (Dark, Light, System).
class ThemeModeModel {
  const ThemeModeModel({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.index,
    required this.prefValue,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final int index;
  /// Value stored in prefs (e.g. PrefKeys.darkModeKey).
  final String prefValue;
}
