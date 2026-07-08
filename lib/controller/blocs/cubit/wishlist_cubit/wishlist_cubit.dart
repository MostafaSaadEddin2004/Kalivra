import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/services/api/wishlist_api_service.dart';

export 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistLoading());

  final WishlistApiService _wishlistService = WishlistApiService();

  Future<void> loadWishlist() async {
    emit(WishlistLoading());
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(WishlistLoginRequired());
      return;
    }

    try {
      final list = await _wishlistService.getWishlist();
      final products = <ProductModel>[];
      for (final w in list) {
        if (w.product != null) {
          try {
            final p = ProductModel.fromJson(w.product!);
            products.add(p);
          } catch (_) {}
        }
      }
      emit(WishlistLoaded(wishlist: products));
    } catch (e) {
      emit(WishlistFailed(message: e.toString()));
    }
  }

  Future<void> add(int productId) async {
    await _wishlistService.addToWishlist(productId);
  }

  Future<int?> findWishlistItemId(int productId) async {
    final list = await _wishlistService.getWishlist();
    for (final item in list) {
      if (item.productId == productId) return item.id;
    }
    return null;
  }

  Future<void> toggleWishlist({
    required int productId,
    required bool isCurrentlyInWishlist,
  }) async {
    if (isCurrentlyInWishlist) {
      final itemId = await findWishlistItemId(productId);
      if (itemId != null) {
        await remove(itemId);
      }
    } else {
      await add(productId);
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
