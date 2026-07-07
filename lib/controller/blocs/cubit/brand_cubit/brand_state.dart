part of 'brand_cubit.dart';

@immutable
sealed class BrandState {}

final class BrandLoading extends BrandState {}
final class OneBrandFetched extends BrandState {
  final BrandModel brand;
  OneBrandFetched(this.brand);
}
final class BrandsFetched extends BrandState {
  final List<BrandModel> brands;
  BrandsFetched(this.brands);
}
final class BrandProductsLoading extends BrandState {}
final class BrandProductFetched extends BrandState {
  final List<ProductModel> brandProducts;
  BrandProductFetched(this.brandProducts);
}
final class BrandFailure extends BrandState {
  final String message;
  BrandFailure(this.message);
}
final class BrandProductsFailure extends BrandState {
  final String message;
  BrandProductsFailure(this.message);
}
