// products_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
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
      emit(
        ProductVariantSelected(
          product: product,
          selectedSize: firstSize,
          selectedColor: null,
        ),
      );
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
    emit(
      current.copyWith(
        selectedSize: size,
        clearColor: true,
        reviewStatus: ProductReviewStatus.idle,
        clearReviewError: true,
      ),
    );
  }

  void selectColor(ColorVariant color) {
    final current = state;
    if (current is! ProductVariantSelected) return;
    emit(
      current.copyWith(
        selectedColor: color,
        reviewStatus: ProductReviewStatus.idle,
        clearReviewError: true,
      ),
    );
  }

  Future<void> postProductReview({
    required int productId,
    required String comment,
    required int rating,
  }) async {
    final current = state;
    if (current is! ProductVariantSelected) return;

    try {
      final token = await LocalStore.getToken();
      if (token == null || token.isEmpty) {
        emit(current.copyWith(reviewStatus: ProductReviewStatus.loginRequired));
        return;
      }

      emit(
        current.copyWith(
          reviewStatus: ProductReviewStatus.submitting,
          clearReviewError: true,
        ),
      );
      await _productService.postProductReview(
        productId: productId,
        comment: comment,
        rating: rating,
      );
      final updatedProduct = await _productService.getProductById(productId);
      emit(
        current.copyWith(
          product: updatedProduct,
          reviewStatus: ProductReviewStatus.submitted,
          clearReviewError: true,
        ),
      );
    } catch (e) {
      emit(
        current.copyWith(
          reviewStatus: ProductReviewStatus.failure,
          reviewError: e.toString(),
        ),
      );
    }
  }
}
