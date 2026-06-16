// products_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_state.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/services/api/product_api_service.dart';

export 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsLoading());
  final ProductApiService _productService = ProductApiService();

  Future<void> loadProducts() async {
    emit(ProductsLoading());
    try {
      final products = await _productService.getProducts();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsFailed(message: e.toString()));
    }
  }
  Future<void> loadSaleProducts() async {
    emit(ProductsLoading());
    try {
      final products = await _productService.getSaleProducts();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsFailed(message: e.toString()));
    }
  }


  Future<void> loadProductById(int productId) async {
    emit(ProductsLoading());
    try {
      final product = await _productService.getProductById(productId);
      final firstSize = product.variants?.variantsBySize.firstOrNull;
      emit(ProductVariantSelected(
        product: product,
        selectedSize: firstSize,
        selectedColor: null,
      ));
    } catch (e) {
      emit(ProductsFailed(message: e.toString()));
    }
  }

  Future<void> loadProductByCategoryId(int categoryId) async {
    emit(ProductsLoading());
    try {
      final product = await _productService.getProductsByCategoryId(categoryId);
      emit(ProductsLoaded(products: product));
    } catch (e) {
      emit(ProductsFailed(message: e.toString()));
    }
  }

  void selectSize(VariantBySize size) {
    final current = state;
    if (current is! ProductVariantSelected) return;
    emit(current.copyWith(selectedSize: size, clearColor: true));
  }

  void selectColor(ColorVariant color) {
    final current = state;
    if (current is! ProductVariantSelected) return;
    emit(current.copyWith(selectedColor: color));
  }
}