import 'package:flutter/material.dart';
import 'package:kalivra/models/category_model.dart';
import 'package:kalivra/models/product_model.dart';

/// In-memory categories and products for the categories tab.
/// Replace with API/repository when backend is ready.
class CategoriesData {
  CategoriesData._();

  static const List<CategoryModel> categories = [
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

  static const List<ProductModel> products = [
    ProductModel(id: '1', name: 'دهان داخلي لامع 18 لتر', categoryId: 'paint', price: 285.0, quantity: 5),
    ProductModel(id: '2', name: 'دهان خارجي مقاوم للماء', categoryId: 'paint', price: 420.0, quantity: 3),
    ProductModel(id: '3', name: 'برايمر للجدران', categoryId: 'paint', price: 95.0, quantity: 8),
    ProductModel(id: '4', name: 'سيراميك 60×60 سم', categoryId: 'tiles', price: 45.0, unit: 'م²', quantity: 10),
    ProductModel(id: '5', name: 'سيراميك حمام 30×30', categoryId: 'tiles', price: 32.0, unit: 'م²', quantity: 6),
    ProductModel(id: '6', name: 'بورسلين أرضيات', categoryId: 'tiles', price: 78.0, unit: 'م²', quantity: 4),
    ProductModel(id: '7', name: 'حنفية حمام كروم', categoryId: 'plumbing', price: 340.0, quantity: 5),
    ProductModel(id: '8', name: 'خلاط مطبخ', categoryId: 'plumbing', price: 185.0, quantity: 7),
    ProductModel(id: '9', name: 'سيفون أرضي', categoryId: 'plumbing', price: 65.0, quantity: 12),
    ProductModel(id: '10', name: 'حديد تسليح 12 ملم', categoryId: 'iron', price: 28.0, unit: 'م', quantity: 20),
    ProductModel(id: '11', name: 'شبك حديد ملحوم', categoryId: 'iron', price: 55.0, unit: 'م²', quantity: 15),
    ProductModel(id: '12', name: 'زوايا حديدية', categoryId: 'iron', price: 42.0, unit: 'م', quantity: 9),
    ProductModel(id: '13', name: 'كابل كهرباء 2.5 ملم', categoryId: 'electrical', price: 3.5, unit: 'م', quantity: 25),
    ProductModel(id: '14', name: 'مفاتيح ومقابس', categoryId: 'electrical', price: 22.0, quantity: 10),
    ProductModel(id: '15', name: 'لوحة توزيع 12 خط', categoryId: 'electrical', price: 125.0, quantity: 4),
    ProductModel(id: '16', name: 'ورق جدران فاخر', categoryId: 'decor', price: 85.0, unit: 'لفة', quantity: 6),
    ProductModel(id: '17', name: 'إطار مرآة خشبي', categoryId: 'decor', price: 180.0, quantity: 3),
    ProductModel(id: '18', name: 'ستائر رول', categoryId: 'decor', price: 95.0, unit: 'م²', quantity: 8),
  ];
  static const List<ProductModel> saleProducts = [
    ProductModel(id: '1', name: 'دهان داخلي لامع 18 لتر', categoryId: 'paint', price: 285.0, salePrice: 213.75, quantity: 5),
    ProductModel(id: '2', name: 'دهان خارجي مقاوم للماء', categoryId: 'paint', price: 420.0, salePrice: 294.0, quantity: 3),
    ProductModel(id: '3', name: 'برايمر للجدران', categoryId: 'paint', price: 95.0, salePrice: 80.75, quantity: 8),
    ProductModel(id: '4', name: 'سيراميك 60×60 سم', categoryId: 'tiles', price: 45.0, unit: 'م²', salePrice: 36.0, quantity: 10),
    ProductModel(id: '5', name: 'سيراميك حمام 30×30', categoryId: 'tiles', price: 32.0, unit: 'م²', salePrice: 28.8, quantity: 6),
    ProductModel(id: '6', name: 'بورسلين أرضيات', categoryId: 'tiles', price: 78.0, unit: 'م²', salePrice: 50.7, quantity: 4),
    ProductModel(id: '7', name: 'حنفية حمام كروم', categoryId: 'plumbing', price: 340.0, salePrice: 204.0, quantity: 5),
    ProductModel(id: '8', name: 'خلاط مطبخ', categoryId: 'plumbing', price: 185.0, salePrice: 151.7, quantity: 7),
    ProductModel(id: '9', name: 'سيفون أرضي', categoryId: 'plumbing', price: 65.0, salePrice: 57.2, quantity: 12),
    ProductModel(id: '10', name: 'حديد تسليح 12 ملم', categoryId: 'iron', price: 28.0, unit: 'م', salePrice: 25.76, quantity: 20),
    ProductModel(id: '11', name: 'شبك حديد ملحوم', categoryId: 'iron', price: 55.0, unit: 'م²', salePrice: 42.9, quantity: 15),
    ProductModel(id: '12', name: 'زوايا حديدية', categoryId: 'iron', price: 42.0, unit: 'م', salePrice: 36.12, quantity: 9),
    ProductModel(id: '13', name: 'كابل كهرباء 2.5 ملم', categoryId: 'electrical', price: 3.5, unit: 'م', salePrice: 3.33, quantity: 25),
    ProductModel(id: '14', name: 'مفاتيح ومقابس', categoryId: 'electrical', price: 22.0, salePrice: 15.84, quantity: 10),
    ProductModel(id: '15', name: 'لوحة توزيع 12 خط', categoryId: 'electrical', price: 125.0, salePrice: 83.75, quantity: 4),
    ProductModel(id: '16', name: 'ورق جدران فاخر', categoryId: 'decor', price: 85.0, unit: 'لفة', salePrice: 46.75, quantity: 6),
    ProductModel(id: '17', name: 'إطار مرآة خشبي', categoryId: 'decor', price: 180.0, salePrice: 90.0, quantity: 3),
    ProductModel(id: '18', name: 'ستائر رول', categoryId: 'decor', price: 95.0, unit: 'م²', salePrice: 80.75, quantity: 8),
  ];

  static List<ProductModel> productsForCategory(String categoryId) {
    if (categoryId == 'all') return List.from(products);
    return products.where((p) => p.categoryId == categoryId).toList();
  }
}
