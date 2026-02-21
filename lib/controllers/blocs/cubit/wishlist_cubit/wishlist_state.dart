import 'package:kalivra/models/product_model.dart';

abstract class WishlistState {
  const WishlistState();
  List<ProductModel> get products => [];
  dynamic get error => null;
  bool get isLoading => false;
  bool get hasError => error != null;

  static const WishlistState initial = _WishlistInitial();
  static const WishlistState loading = _WishlistLoading();
  static WishlistState loaded(List<ProductModel> p) => _WishlistLoaded(p);
  static WishlistState failed(dynamic e, [StackTrace? st]) => _WishlistFailed(e, st);
}

final class _WishlistInitial extends WishlistState {
  const _WishlistInitial();
}

final class _WishlistLoading extends WishlistState {
  const _WishlistLoading();
  @override
  bool get isLoading => true;
}

final class _WishlistLoaded extends WishlistState {
  _WishlistLoaded(this.products);
  @override
  final List<ProductModel> products;
}

final class _WishlistFailed extends WishlistState {
  _WishlistFailed(this.error, [this.stackTrace]);
  @override
  final dynamic error;
  final StackTrace? stackTrace;
}
