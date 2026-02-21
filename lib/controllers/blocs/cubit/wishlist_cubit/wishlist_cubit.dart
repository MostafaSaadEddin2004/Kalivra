import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/wishlist_cubit/wishlist_state.dart';
import 'package:kalivra/models/api/product_api_model.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/services/api/mappers/product_mapper.dart';
import 'package:kalivra/services/api/wishlist_api_service.dart';

export 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit(this._wishlistService) : super(WishlistState.initial);

  final WishlistApiService _wishlistService;

  Future<void> loadWishlist() async {
    emit(WishlistState.loading);
    try {
      final list = await _wishlistService.getWishlist();
      final products = <ProductModel>[];
      for (final w in list) {
        if (w.product != null) {
          try {
            final p = ProductApiModel.fromJson(w.product!);
            products.add(ProductMapper.fromApi(p));
          } catch (_) {}
        }
      }
      emit(WishlistState.loaded(products));
    } catch (e, st) {
      emit(WishlistState.failed(e, st));
    }
  }

  Future<void> add(int productId) async {
    try {
      await _wishlistService.addToWishlist(productId);
      loadWishlist();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> remove(int itemId) async {
    try {
      await _wishlistService.removeFromWishlist(itemId);
      loadWishlist();
    } catch (_) {
      rethrow;
    }
  }
}
