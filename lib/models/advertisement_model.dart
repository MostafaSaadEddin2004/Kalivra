import 'package:flutter/material.dart';

class AdvertisementModel {
  const AdvertisementModel({
    required this.title,
    required this.subtitle,
    required this.gradientStart,
    required this.gradientEnd,
  });

  final String title;
  final String subtitle;
  final Color gradientStart;
  final Color gradientEnd;
}