// products_state.dart
import 'package:kalivra/model/product/product_model.dart';

abstract class ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  ProductsLoaded({required this.products});
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

  ProductVariantSelected({
    required this.product,
    this.selectedSize,
    this.selectedColor,
  });

  List<ColorVariant> get availableColors => selectedSize?.colors ?? [];

  ProductVariantSelected copyWith({
    VariantBySize? selectedSize,
    ColorVariant? selectedColor,
    bool clearColor = false,
  }) {
    return ProductVariantSelected(
      product: product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: clearColor ? null : (selectedColor ?? this.selectedColor),
    );
  }
}