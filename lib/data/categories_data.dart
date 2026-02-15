import 'package:flutter/material.dart';
import 'package:kalivra/models/category_model.dart';
import 'package:kalivra/models/product_model.dart';

/// In-memory categories and products for the categories tab.
/// Replace with API/repository when backend is ready.
class CategoriesData {
  CategoriesData._();

  static  List<CategoryModel> categories = [
    CategoryModel(id: 'all', name: 'الكل', icon: Icons.apps_rounded),
    CategoryModel(
      id: 'paint',
      name: 'دهانات',
      icon: Icons.format_paint_rounded,
    ),
    CategoryModel(id: 'tiles', name: 'سيراميك', icon: Icons.grid_4x4_rounded),
    CategoryModel(
      id: 'plumbing',
      name: 'أدوات صحية',
      icon: Icons.water_drop_rounded,
    ),
    CategoryModel(id: 'iron', name: 'حديد', icon: Icons.construction_rounded),
    CategoryModel(
      id: 'electrical',
      name: 'كهربائيات',
      icon: Icons.electrical_services_rounded,
    ),
    CategoryModel(id: 'decor', name: 'ديكور', icon: Icons.palette_rounded),
  ];

  static  List<ProductModel> products = [
    ProductModel(
      id: '1',
      name: 'دهان داخلي لامع 18 لتر',
      categoryId: 'paint',
      price: 285.0,
      quantity: 5,
      brandId: 'brand1',
      imageUrls: ['https://picsum.photos/400/400?random=1a', 'https://picsum.photos/400/400?random=1b', 'https://picsum.photos/400/400?random=1c'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'كريمي', color: Color(0xFFFFFDD0)),
        ProductColorOption(name: 'بيج', color: Color(0xFFF5DEB3)),
        ProductColorOption(name: 'أزرق فاتح', color: Color(0xFFE6F3FF)),
      ],
      sizes:  ['5 لتر', '10 لتر', '18 لتر'],
    ),
    ProductModel(
      id: '2',
      name: 'دهان خارجي مقاوم للماء',
      categoryId: 'paint',
      price: 420.0,
      quantity: 3,
      brandId: 'brand1',
      imageUrls: ['https://picsum.photos/400/400?random=2a', 'https://picsum.photos/400/400?random=2b'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E)),
        ProductColorOption(name: 'بيج', color: Color(0xFFD2B48C)),
      ],
      sizes:  ['10 لتر', '20 لتر'],
    ),
    ProductModel(
      id: '3',
      name: 'برايمر للجدران',
      categoryId: 'paint',
      price: 95.0,
      quantity: 8,
      brandId: 'brand1',
      imageUrls: ['https://picsum.photos/400/400?random=3a', 'https://picsum.photos/400/400?random=3b'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'شفاف', color: Color(0xFFF0F8FF)),
      ],
      sizes:  ['5 لتر', '10 لتر'],
    ),
    ProductModel(
      id: '4',
      name: 'سيراميك 60×60 سم',
      categoryId: 'tiles',
      price: 45.0,
      unit: 'م²',
      quantity: 10,
      brandId: 'brand2',
      imageUrls: ['https://picsum.photos/400/400?random=4a', 'https://picsum.photos/400/400?random=4b', 'https://picsum.photos/400/400?random=4c'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'رمادي', color: Color(0xFF757575)),
        ProductColorOption(name: 'بيج', color: Color(0xFFBC8F8F)),
        ProductColorOption(name: 'أسود', color: Color(0xFF2D2D2D)),
      ],
      sizes:  ['60×60 سم', '60×120 سم', '30×60 سم'],
    ),
    ProductModel(
      id: '5',
      name: 'سيراميك حمام 30×30',
      categoryId: 'tiles',
      price: 32.0,
      unit: 'م²',
      quantity: 6,
      brandId: 'brand2',
      imageUrls: ['https://picsum.photos/400/400?random=5a', 'https://picsum.photos/400/400?random=5b'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'أزرق فاتح', color: Color(0xFFB3E5FC)),
        ProductColorOption(name: 'أخضر فاتح', color: Color(0xFFC8E6C9)),
      ],
      sizes:  ['30×30 سم', '30×60 سم'],
    ),
    ProductModel(
      id: '6',
      name: 'بورسلين أرضيات',
      categoryId: 'tiles',
      price: 78.0,
      unit: 'م²',
      quantity: 4,
      brandId: 'brand3',
      imageUrls: ['https://picsum.photos/400/400?random=6a', 'https://picsum.photos/400/400?random=6b', 'https://picsum.photos/400/400?random=6c'],
      colors:  [
        ProductColorOption(name: 'رمادي', color: Color(0xFF616161)),
        ProductColorOption(name: 'بيج', color: Color(0xFFD7CCC8)),
        ProductColorOption(name: 'أبيض رخامي', color: Color(0xFFEEEEEE)),
      ],
      sizes:  ['60×60 سم', '80×80 سم', '120×60 سم'],
    ),
    ProductModel(
      id: '7',
      name: 'حنفية حمام كروم',
      categoryId: 'plumbing',
      price: 340.0,
      quantity: 5,
      brandId: 'brand3',
      imageUrls: ['https://picsum.photos/400/400?random=7a', 'https://picsum.photos/400/400?random=7b'],
      colors:  [
        ProductColorOption(name: 'كروم', color: Color(0xFFE8E8E8)),
        ProductColorOption(name: 'أسود مات', color: Color(0xFF37474F)),
        ProductColorOption(name: 'ذهبي', color: Color(0xFFD4AF37)),
      ],
      sizes:  ['قياسي', 'عالية', 'جدارية'],
    ),
    ProductModel(
      id: '8',
      name: 'خلاط مطبخ',
      categoryId: 'plumbing',
      price: 185.0,
      quantity: 7,
      brandId: 'brand4',
      imageUrls: ['https://picsum.photos/400/400?random=8a', 'https://picsum.photos/400/400?random=8b'],
      colors:  [
        ProductColorOption(name: 'كروم', color: Color(0xFFE8E8E8)),
        ProductColorOption(name: 'أسود', color: Color(0xFF424242)),
      ],
      sizes:  ['قياسي', 'طويل'],
    ),
    ProductModel(
      id: '9',
      name: 'سيفون أرضي',
      categoryId: 'plumbing',
      price: 65.0,
      quantity: 12,
      brandId: 'brand4',
      imageUrls: ['https://picsum.photos/400/400?random=9a', 'https://picsum.photos/400/400?random=9b'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E)),
      ],
      sizes:  ['3 بوصة', '4 بوصة'],
    ),
    ProductModel(
      id: '10',
      name: 'حديد تسليح 12 ملم',
      categoryId: 'iron',
      price: 28.0,
      unit: 'م',
      quantity: 20,
      brandId: 'brand5',
      imageUrls: ['https://picsum.photos/400/400?random=10a', 'https://picsum.photos/400/400?random=10b'],
      colors:  [
        ProductColorOption(name: 'أسود طبيعي', color: Color(0xFF37474F)),
        ProductColorOption(name: 'مطلي', color: Color(0xFF455A64)),
      ],
      sizes:  ['6 م', '12 م'],
    ),
    ProductModel(
      id: '11',
      name: 'شبك حديد ملحوم',
      categoryId: 'iron',
      price: 55.0,
      unit: 'م²',
      quantity: 15,
      brandId: 'brand5',
      imageUrls: ['https://picsum.photos/400/400?random=11a', 'https://picsum.photos/400/400?random=11b'],
      colors:  [
        ProductColorOption(name: 'أسود', color: Color(0xFF37474F)),
        ProductColorOption(name: 'مطلي أخضر', color: Color(0xFF2E7D32)),
      ],
      sizes:  ['2×6 م', '2×12 م', '1×2 م'],
    ),
    ProductModel(
      id: '12',
      name: 'زوايا حديدية',
      categoryId: 'iron',
      price: 42.0,
      unit: 'م',
      quantity: 9,
      brandId: 'brand5',
      imageUrls: ['https://picsum.photos/400/400?random=12a', 'https://picsum.photos/400/400?random=12b'],
      colors:  [
        ProductColorOption(name: 'أسود', color: Color(0xFF37474F)),
        ProductColorOption(name: 'مجلفن', color: Color(0xFFB0BEC5)),
      ],
      sizes:  ['3 م', '6 م', '12 م'],
    ),
    ProductModel(
      id: '13',
      name: 'كابل كهرباء 2.5 ملم',
      categoryId: 'electrical',
      price: 3.5,
      unit: 'م',
      quantity: 25,
      brandId: 'brand6',
      imageUrls: ['https://picsum.photos/400/400?random=13a', 'https://picsum.photos/400/400?random=13b'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'أسود', color: Color(0xFF212121)),
        ProductColorOption(name: 'رمادي', color: Color(0xFF757575)),
      ],
      sizes:  ['50 م', '100 م', '200 م'],
    ),
    ProductModel(
      id: '14',
      name: 'مفاتيح ومقابس',
      categoryId: 'electrical',
      price: 22.0,
      quantity: 10,
      brandId: 'brand6',
      imageUrls: ['https://picsum.photos/400/400?random=14a', 'https://picsum.photos/400/400?random=14b'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'عاجي', color: Color(0xFFFFF8E1)),
        ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E)),
      ],
      sizes:  ['مفرد', 'مزدوج', 'ثلاثي'],
    ),
    ProductModel(
      id: '15',
      name: 'لوحة توزيع 12 خط',
      categoryId: 'electrical',
      price: 125.0,
      quantity: 4,
      brandId: 'brand7',
      imageUrls: ['https://picsum.photos/400/400?random=15a', 'https://picsum.photos/400/400?random=15b'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E)),
      ],
      sizes:  ['12 خط', '18 خط', '24 خط'],
    ),
    ProductModel(
      id: '16',
      name: 'ورق جدران فاخر',
      categoryId: 'decor',
      price: 85.0,
      unit: 'لفة',
      quantity: 6,
      brandId: 'brand8',
      imageUrls: ['https://picsum.photos/400/400?random=16a', 'https://picsum.photos/400/400?random=16b', 'https://picsum.photos/400/400?random=16c'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'كريمي', color: Color(0xFFFFFDD0)),
        ProductColorOption(name: 'أزرق فاتح', color: Color(0xFFADD8E6)),
        ProductColorOption(name: 'رمادي', color: Color(0xFFB0B0B0)),
      ],
      sizes:  ['لفة صغيرة', 'لفة متوسطة', 'لفة كبيرة'],
    ),
    ProductModel(
      id: '17',
      name: 'إطار مرآة خشبي',
      categoryId: 'decor',
      price: 180.0,
      quantity: 3,
      brandId: 'brand8',
      imageUrls: ['https://picsum.photos/400/400?random=17a', 'https://picsum.photos/400/400?random=17b'],
      colors:  [
        ProductColorOption(name: 'خشب طبيعي', color: Color(0xFF8D6E63)),
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'أسود', color: Color(0xFF212121)),
      ],
      sizes:  ['40×60 سم', '60×80 سم', '80×120 سم'],
    ),
    ProductModel(
      id: '18',
      name: 'ستائر رول',
      categoryId: 'decor',
      price: 95.0,
      unit: 'م²',
      quantity: 8,
      brandId: 'brand8',
      imageUrls: ['https://picsum.photos/400/400?random=18a', 'https://picsum.photos/400/400?random=18b', 'https://picsum.photos/400/400?random=18c'],
      colors:  [
        ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)),
        ProductColorOption(name: 'كريمي', color: Color(0xFFFFFDD0)),
        ProductColorOption(name: 'رمادي', color: Color(0xFFBDBDBD)),
        ProductColorOption(name: 'أزرق', color: Color(0xFF90CAF9)),
      ],
      sizes:  ['1.4 م عرض', '2 م عرض', '2.8 م عرض'],
    ),
  ];
  static  List<ProductModel> saleProducts = [
    ProductModel(id: '1', name: 'دهان داخلي لامع 18 لتر', categoryId: 'paint', price: 285.0, salePrice: 213.75, quantity: 5, brandId: 'brand1', imageUrls: ['https://picsum.photos/400/400?random=1a', 'https://picsum.photos/400/400?random=1b', 'https://picsum.photos/400/400?random=1c'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'كريمي', color: Color(0xFFFFFDD0)), ProductColorOption(name: 'بيج', color: Color(0xFFF5DEB3)), ProductColorOption(name: 'أزرق فاتح', color: Color(0xFFE6F3FF))], sizes:  ['5 لتر', '10 لتر', '18 لتر']),
    ProductModel(id: '2', name: 'دهان خارجي مقاوم للماء', categoryId: 'paint', price: 420.0, salePrice: 294.0, quantity: 3, brandId: 'brand1', imageUrls: ['https://picsum.photos/400/400?random=2a', 'https://picsum.photos/400/400?random=2b'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E)), ProductColorOption(name: 'بيج', color: Color(0xFFD2B48C))], sizes:  ['10 لتر', '20 لتر']),
    ProductModel(id: '3', name: 'برايمر للجدران', categoryId: 'paint', price: 95.0, salePrice: 80.75, quantity: 8, brandId: 'brand1', imageUrls: ['https://picsum.photos/400/400?random=3a', 'https://picsum.photos/400/400?random=3b'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'شفاف', color: Color(0xFFF0F8FF))], sizes:  ['5 لتر', '10 لتر']),
    ProductModel(id: '4', name: 'سيراميك 60×60 سم', categoryId: 'tiles', price: 45.0, unit: 'م²', salePrice: 36.0, quantity: 10, brandId: 'brand2', imageUrls: ['https://picsum.photos/400/400?random=4a', 'https://picsum.photos/400/400?random=4b', 'https://picsum.photos/400/400?random=4c'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'رمادي', color: Color(0xFF757575)), ProductColorOption(name: 'بيج', color: Color(0xFFBC8F8F)), ProductColorOption(name: 'أسود', color: Color(0xFF2D2D2D))], sizes:  ['60×60 سم', '60×120 سم', '30×60 سم']),
    ProductModel(id: '5', name: 'سيراميك حمام 30×30', categoryId: 'tiles', price: 32.0, unit: 'م²', salePrice: 28.8, quantity: 6, brandId: 'brand2', imageUrls: ['https://picsum.photos/400/400?random=5a', 'https://picsum.photos/400/400?random=5b'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'أزرق فاتح', color: Color(0xFFB3E5FC)), ProductColorOption(name: 'أخضر فاتح', color: Color(0xFFC8E6C9))], sizes:  ['30×30 سم', '30×60 سم']),
    ProductModel(id: '6', name: 'بورسلين أرضيات', categoryId: 'tiles', price: 78.0, unit: 'م²', salePrice: 50.7, quantity: 4, brandId: 'brand3', imageUrls: ['https://picsum.photos/400/400?random=6a', 'https://picsum.photos/400/400?random=6b', 'https://picsum.photos/400/400?random=6c'], colors:  [ProductColorOption(name: 'رمادي', color: Color(0xFF616161)), ProductColorOption(name: 'بيج', color: Color(0xFFD7CCC8)), ProductColorOption(name: 'أبيض رخامي', color: Color(0xFFEEEEEE))], sizes:  ['60×60 سم', '80×80 سم', '120×60 سم']),
    ProductModel(id: '7', name: 'حنفية حمام كروم', categoryId: 'plumbing', price: 340.0, salePrice: 204.0, quantity: 5, brandId: 'brand3', imageUrls: ['https://picsum.photos/400/400?random=7a', 'https://picsum.photos/400/400?random=7b'], colors:  [ProductColorOption(name: 'كروم', color: Color(0xFFE8E8E8)), ProductColorOption(name: 'أسود مات', color: Color(0xFF37474F)), ProductColorOption(name: 'ذهبي', color: Color(0xFFD4AF37))], sizes:  ['قياسي', 'عالية', 'جدارية']),
    ProductModel(id: '8', name: 'خلاط مطبخ', categoryId: 'plumbing', price: 185.0, salePrice: 151.7, quantity: 7, brandId: 'brand4', imageUrls: ['https://picsum.photos/400/400?random=8a', 'https://picsum.photos/400/400?random=8b'], colors:  [ProductColorOption(name: 'كروم', color: Color(0xFFE8E8E8)), ProductColorOption(name: 'أسود', color: Color(0xFF424242))], sizes:  ['قياسي', 'طويل']),
    ProductModel(id: '9', name: 'سيفون أرضي', categoryId: 'plumbing', price: 65.0, salePrice: 57.2, quantity: 12, brandId: 'brand4', imageUrls: ['https://picsum.photos/400/400?random=9a', 'https://picsum.photos/400/400?random=9b'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E))], sizes:  ['3 بوصة', '4 بوصة']),
    ProductModel(id: '10', name: 'حديد تسليح 12 ملم', categoryId: 'iron', price: 28.0, unit: 'م', salePrice: 25.76, quantity: 20, brandId: 'brand5', imageUrls: ['https://picsum.photos/400/400?random=10a', 'https://picsum.photos/400/400?random=10b'], colors:  [ProductColorOption(name: 'أسود طبيعي', color: Color(0xFF37474F)), ProductColorOption(name: 'مطلي', color: Color(0xFF455A64))], sizes:  ['6 م', '12 م']),
    ProductModel(id: '11', name: 'شبك حديد ملحوم', categoryId: 'iron', price: 55.0, unit: 'م²', salePrice: 42.9, quantity: 15, brandId: 'brand5', imageUrls: ['https://picsum.photos/400/400?random=11a', 'https://picsum.photos/400/400?random=11b'], colors:  [ProductColorOption(name: 'أسود', color: Color(0xFF37474F)), ProductColorOption(name: 'مطلي أخضر', color: Color(0xFF2E7D32))], sizes:  ['2×6 م', '2×12 م', '1×2 م']),
    ProductModel(id: '12', name: 'زوايا حديدية', categoryId: 'iron', price: 42.0, unit: 'م', salePrice: 36.12, quantity: 9, brandId: 'brand5', imageUrls: ['https://picsum.photos/400/400?random=12a', 'https://picsum.photos/400/400?random=12b'], colors:  [ProductColorOption(name: 'أسود', color: Color(0xFF37474F)), ProductColorOption(name: 'مجلفن', color: Color(0xFFB0BEC5))], sizes:  ['3 م', '6 م', '12 م']),
    ProductModel(id: '13', name: 'كابل كهرباء 2.5 ملم', categoryId: 'electrical', price: 3.5, unit: 'م', salePrice: 3.33, quantity: 25, brandId: 'brand6', imageUrls: ['https://picsum.photos/400/400?random=13a', 'https://picsum.photos/400/400?random=13b'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'أسود', color: Color(0xFF212121)), ProductColorOption(name: 'رمادي', color: Color(0xFF757575))], sizes:  ['50 م', '100 م', '200 م']),
    ProductModel(id: '14', name: 'مفاتيح ومقابس', categoryId: 'electrical', price: 22.0, salePrice: 15.84, quantity: 10, brandId: 'brand6', imageUrls: ['https://picsum.photos/400/400?random=14a', 'https://picsum.photos/400/400?random=14b'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'عاجي', color: Color(0xFFFFF8E1)), ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E))], sizes:  ['مفرد', 'مزدوج', 'ثلاثي']),
    ProductModel(id: '15', name: 'لوحة توزيع 12 خط', categoryId: 'electrical', price: 125.0, salePrice: 83.75, quantity: 4, brandId: 'brand7', imageUrls: ['https://picsum.photos/400/400?random=15a', 'https://picsum.photos/400/400?random=15b'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'رمادي', color: Color(0xFF9E9E9E))], sizes:  ['12 خط', '18 خط', '24 خط']),
    ProductModel(id: '16', name: 'ورق جدران فاخر', categoryId: 'decor', price: 85.0, unit: 'لفة', salePrice: 46.75, quantity: 6, brandId: 'brand8', imageUrls: ['https://picsum.photos/400/400?random=16a', 'https://picsum.photos/400/400?random=16b', 'https://picsum.photos/400/400?random=16c'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'كريمي', color: Color(0xFFFFFDD0)), ProductColorOption(name: 'أزرق فاتح', color: Color(0xFFADD8E6)), ProductColorOption(name: 'رمادي', color: Color(0xFFB0B0B0))], sizes:  ['لفة صغيرة', 'لفة متوسطة', 'لفة كبيرة']),
    ProductModel(id: '17', name: 'إطار مرآة خشبي', categoryId: 'decor', price: 180.0, salePrice: 90.0, quantity: 3, brandId: 'brand8', imageUrls: ['https://picsum.photos/400/400?random=17a', 'https://picsum.photos/400/400?random=17b'], colors:  [ProductColorOption(name: 'خشب طبيعي', color: Color(0xFF8D6E63)), ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'أسود', color: Color(0xFF212121))], sizes:  ['40×60 سم', '60×80 سم', '80×120 سم']),
    ProductModel(id: '18', name: 'ستائر رول', categoryId: 'decor', price: 95.0, unit: 'م²', salePrice: 80.75, quantity: 8, brandId: 'brand8', imageUrls: ['https://picsum.photos/400/400?random=18a', 'https://picsum.photos/400/400?random=18b', 'https://picsum.photos/400/400?random=18c'], colors:  [ProductColorOption(name: 'أبيض', color: Color(0xFFFFFBF7)), ProductColorOption(name: 'كريمي', color: Color(0xFFFFFDD0)), ProductColorOption(name: 'رمادي', color: Color(0xFFBDBDBD)), ProductColorOption(name: 'أزرق', color: Color(0xFF90CAF9))], sizes:  ['1.4 م عرض', '2 م عرض', '2.8 م عرض']),
  ];

  static List<ProductModel> productsForCategory(String categoryId) {
    if (categoryId == 'all') return List.from(products);
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  static List<ProductModel> productsForBrand(String brandId) {
    return products.where((p) => p.brandId == brandId).toList();
  }

  static List<ProductModel> saleProductsForBrand(String brandId) {
    return saleProducts.where((p) => p.brandId == brandId).toList();
  }
}
