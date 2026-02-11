import 'package:kalivra/models/brand_model.dart';

/// In-memory brands. Replace with API when backend is ready.
class BrandsData {
  BrandsData._();

  static const List<BrandModel> brands = [
    BrandModel(
      id: 'brand1',
      name: 'براند 1',
      shopCount: 5,
      locations: ['دمشق - المزة', 'دمشق - برزة', 'حلب - الشهباء', 'حمص - المدينة', 'طرطوس - الميناء'],
      description: 'علامة تجارية رائدة في مواد البناء والديكور.',
      phone: '+963 11 234 5678',
      website: 'https://example.com',
    ),
    BrandModel(
      id: 'brand2',
      name: 'براند ٢',
      shopCount: 3,
      locations: ['دمشق - كفرسوسة', 'حلب - العزيزية', 'اللاذقية - وسط المدينة'],
      description: 'تشكيلة واسعة من الدهانات والسيراميك.',
      phone: '+963 41 111 2233',
    ),
    BrandModel(
      id: 'brand3',
      name: 'براند ٣',
      shopCount: 4,
      locations: ['دمشق - الميدان', 'دمشق - ركن الدين', 'حمص - وادي النصارى', 'حماة'],
      phone: '+963 33 444 5566',
    ),
    BrandModel(
      id: 'brand4',
      name: 'براند ٤',
      shopCount: 2,
      locations: ['دمشق', 'حلب'],
      description: 'أدوات صحية وكهربائيات.',
    ),
    BrandModel(
      id: 'brand5',
      name: 'براند ٥',
      shopCount: 6,
      locations: ['دمشق - جوبر', 'دمشق - قدسيا', 'حلب', 'حمص', 'اللاذقية', 'طرطوس'],
      description: 'حديد وتسليح ومواد بناء.',
      phone: '+963 11 999 8877',
    ),
    BrandModel(
      id: 'brand6',
      name: 'براند ٦',
      shopCount: 1,
      locations: ['دمشق - المزة فيستيفال سيتي'],
    ),
    BrandModel(
      id: 'brand7',
      name: 'براند ٧',
      shopCount: 2,
      locations: ['حلب - الشهباء', 'إدلب'],
    ),
    BrandModel(
      id: 'brand8',
      name: 'براند ٨',
      shopCount: 3,
      locations: ['دمشق', 'حمص', 'درعا'],
      description: 'ديكور وورق جدران وإكسسوارات.',
    ),
  ];

  static BrandModel? brandById(String id) {
    try {
      return brands.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
