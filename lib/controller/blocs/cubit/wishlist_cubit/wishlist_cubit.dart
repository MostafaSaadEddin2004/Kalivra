import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_state.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/services/api/wishlist_api_service.dart';

export 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistLoading());

  final WishlistApiService _wishlistService =WishlistApiService();

Future<void> loadWishlist() async {
    emit(WishlistLoading());
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


Future<void> remove(int itemId) async {
    try {
      await _wishlistService.removeFromWishlist(itemId);
      loadWishlist();
    } catch (_) {
      rethrow;
    }
  }
}
