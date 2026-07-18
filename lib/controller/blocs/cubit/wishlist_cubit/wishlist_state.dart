import 'package:kalivra/model/wishlist/wishlist_api_model.dart';

abstract class WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoginRequired extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  final List<WishlistApiModel> wishlist;

  WishlistLoaded({required this.wishlist});
}

final class AddedToWishlistSuccessfully extends WishlistState {
  final String message;

  AddedToWishlistSuccessfully({required this.message});
}
final class WishlistFailed extends WishlistState {
  final String message;

  WishlistFailed({required this.message});
}
