import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/products_cubit/products_state.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/services/api/category_api_service.dart';
import 'package:kalivra/services/api/mappers/category_mapper.dart';
import 'package:kalivra/services/api/mappers/product_mapper.dart';
import 'package:kalivra/services/api/product_api_service.dart';

export 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({
    required CategoryApiService categoryApiService,
    required ProductApiService productApiService,
  })  : _categoryService = categoryApiService,
        _productService = productApiService,
        super(ProductsState.initial);

  final CategoryApiService _categoryService;
  final ProductApiService _productService;

  Future<void> loadCategories() async {
    emit(ProductsState.categoriesLoading);
    try {
      final list = await _categoryService.getCategories();
      final categories = list.map(CategoryMapper.fromApi).toList();
      emit(ProductsState.categoriesLoaded(categories));
    } catch (e, st) {
      emit(ProductsState.categoriesFailed(e, st));
    }
  }

  Future<void> loadProducts({int? categoryId}) async {
    emit(ProductsState.productsLoading);
    try {
      final list = await _productService.getProducts(categoryId: categoryId);
      final products = list.map(ProductMapper.fromApi).toList();
      emit(ProductsState.productsLoaded(products));
    } catch (e, st) {
      emit(ProductsState.productsFailed(e, st));
    }
  }

  Future<void> loadAll() async {
    emit(ProductsState.loading);
    try {
      final categories = await _categoryService.getCategories();
      final products = await _productService.getProducts();
      emit(ProductsState.loaded(
        categories: categories.map(CategoryMapper.fromApi).toList(),
        products: products.map(ProductMapper.fromApi).toList(),
      ));
    } catch (e, st) {
      emit(ProductsState.failed(e, st));
    }
  }

  Future<ProductModel?> loadProductById(int id) async {
    try {
      final api = await _productService.getProductById(id);
      return api != null ? ProductMapper.fromApi(api) : null;
    } catch (_) {
      return null;
    }
  }
}
