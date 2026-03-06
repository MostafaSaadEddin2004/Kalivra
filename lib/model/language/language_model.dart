import 'package:flutter/material.dart';

/// Model for language option (e.g. Arabic, English).
class LanguageModel {
  const LanguageModel({
    required this.title,
    required this.subtitle,
    required this.languageCode,
    required this.index,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String languageCode;
  final int index;
  final IconData icon;
}
