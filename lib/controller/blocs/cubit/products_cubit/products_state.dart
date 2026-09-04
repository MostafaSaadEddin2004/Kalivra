// products_state.dart
import 'package:kalivra/model/product/product_model.dart';

abstract class ProductsState {}

enum ProductReviewStatus { idle, submitting, submitted, loginRequired, failure }

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  ProductsLoaded({
    required this.products,
    this.currentPage = 1,
    this.hasMoreProducts = false,
    this.isLoadingMore = false,
  });

  final List<ProductModel> products;
  final int currentPage;
  final bool hasMoreProducts;
  final bool isLoadingMore;

  ProductsLoaded copyWith({
    List<ProductModel>? products,
    int? currentPage,
    bool? hasMoreProducts,
    bool? isLoadingMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class OneProductLoaded extends ProductsState {
  final ProductModel product;
  OneProductLoaded({required this.product});
}

final class ProductsFailed extends ProductsState {
  final String message;
  ProductsFailed({required this.message});
}

final class ProductVariantSelected extends ProductsState {
  final ProductModel product;
  final VariantBySize? selectedSize;
  final ColorVariant? selectedColor;
  final ProductReviewStatus reviewStatus;
  final String? reviewError;

  ProductVariantSelected({
    required this.product,
    this.selectedSize,
    this.selectedColor,
    this.reviewStatus = ProductReviewStatus.idle,
    this.reviewError,
  });

  List<ColorVariant> get availableColors => selectedSize?.colors ?? [];

  ProductVariantSelected copyWith({
    ProductModel? product,
    VariantBySize? selectedSize,
    ColorVariant? selectedColor,
    bool clearColor = false,
    ProductReviewStatus? reviewStatus,
    String? reviewError,
    bool clearReviewError = false,
  }) {
    return ProductVariantSelected(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: clearColor ? null : (selectedColor ?? this.selectedColor),
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewError: clearReviewError ? null : (reviewError ?? this.reviewError),
    );
  }
}
