import 'package:flutter/material.dart';
import 'package:kalivra/models/advertisement_model.dart';

/// Shared ads data for home slider and All Ads page.
class AdsData {
  AdsData._();

  static List<AdvertisementModel> getAds(ColorScheme colorScheme) {
    return [
      AdvertisementModel(
        title: 'عروض الدهانات',
        subtitle: 'خصم حتى 20% على تشكيلة الدهانات',
        gradientStart: colorScheme.primary,
        gradientEnd: colorScheme.primary.withValues(alpha: 0.8),
        companyName: 'دهانات النور',
        whatTheySell: 'دهانات داخلية وخارجية، برايمر، وألوان متخصصة',
        location: 'دمشق - المزة، شارع الثورة',
        phone: '+963 11 234 5678',
        website: 'https://example.com/dhnat',
        description: 'شركة متخصصة في الدهانات ومواد الطلاء بجودة عالية وأسعار منافسة.',
      ),
      AdvertisementModel(
        title: 'مواد البناء',
        subtitle: 'أسعار منافسة على السيراميك والحديد',
        gradientStart: colorScheme.secondary.withValues(alpha: 0.8),
        gradientEnd: colorScheme.secondary,
        companyName: 'بناء الشام',
        whatTheySell: 'سيراميك، حديد تسليح، أسمنت، أدوات صحية وكهربائية',
        location: 'حلب - الشهباء، دمشق - برزة، حمص - المدينة',
        phone: '+963 41 111 2233',
        website: 'https://example.com/building',
        description: 'توفير مواد البناء من مصانع معتمدة مع خدمة التوصيل لجميع المحافظات.',
      ),
      AdvertisementModel(
        title: 'توصيل سريع',
        subtitle: 'توصيل لجميع المناطق',
        gradientStart: colorScheme.primary,
        gradientEnd: colorScheme.surfaceContainerHighest,
        companyName: 'كليفرا للخدمات اللوجستية',
        whatTheySell: 'خدمات توصيل الطلبات والشحن السريع',
        location: 'دمشق - كفرسوسة، فرع في كل محافظة',
        phone: '+963 11 999 8877',
        website: 'https://kalivra.com',
        description: 'نوصل طلباتك إلى باب منزلك في جميع أنحاء البلاد خلال 24–48 ساعة.',
      ),
    ];
  }
}
