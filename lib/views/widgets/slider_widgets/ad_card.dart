import 'package:flutter/material.dart';
import 'package:kalivra/models/advertisement_model.dart';

class AdCard extends StatelessWidget {
  const AdCard({super.key, required this.slide});

  final AdvertisementModel slide;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [slide.gradientStart, slide.gradientEnd],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.campaign_rounded,
          size: 48,
          color: colorScheme.onPrimary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
