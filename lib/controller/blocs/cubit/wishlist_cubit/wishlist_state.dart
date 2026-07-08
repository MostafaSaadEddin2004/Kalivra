import 'package:kalivra/model/product/product_model.dart';

abstract class WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoginRequired extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  final List<ProductModel> wishlist;

  WishlistLoaded({required this.wishlist});
}

final class WishlistFailed extends WishlistState {
  final String message;

  WishlistFailed({required this.message});
}
