import 'package:flutter/material.dart';

class AdvertisementModel {
  const AdvertisementModel({
    required this.title,
    required this.subtitle,
    required this.gradientStart,
    required this.gradientEnd,
    this.companyName,
    this.whatTheySell,
    this.location,
    this.phone,
    this.website,
    this.description,
  });

  final String title;
  final String subtitle;
  final Color gradientStart;
  final Color gradientEnd;
  /// Company or brand name.
  final String? companyName;
  /// What the company sells (e.g. product category or list).
  final String? whatTheySell;
  /// Company address or location.
  final String? location;
  /// Company phone number.
  final String? phone;
  /// Company website URL.
  final String? website;
  /// Additional description or details.
  final String? description;
}