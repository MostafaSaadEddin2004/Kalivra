import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/services/api/wishlist_api_service.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';
import 'package:kalivra/view/widgets/login_dialog.dart';

export 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistLoading());

  final WishlistApiService _wishlistService = WishlistApiService();

  Future<void> loadWishlist() async {
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(WishlistLoginRequired());
      return;
    }
    emit(WishlistLoading());

    try {
      final list = await _wishlistService.getWishlist();

      emit(WishlistLoaded(wishlist: list));
    } catch (e) {
      emit(WishlistFailed(message: e.toString()));
    }
  }

  Future<bool> addToWishlist({
    required int productId,
    required String productName,
    required BuildContext context,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(WishlistLoginRequired());
      showDialog(context: context, builder: (context) => GoToLoginDialog());
      return false;
    }

    try {
      await _wishlistService.addToWishlist(productId: productId);
      emit(
        AddedToWishlistSuccessfully(
          message: l10n.addToWishlistSuccess(productName),
        ),
      );
      return true;
    } catch (e) {
      emit(WishlistFailed(message: e.toString()));
      return false;
    }
  }

  Future<bool> removeFromWishlist({required int itemId}) async {
    try {
      await _wishlistService.removeFromWishlist(itemId: itemId);
      await loadWishlist();
      return true;
    } catch (e) {
      emit(WishlistFailed(message: e.toString()));
      return false;
    }
  }

  Future<bool> removeProductFromWishlist({required int productId}) async {
    try {
      final list = await _wishlistService.getWishlist();
      for (final item in list) {
        if (item.product.id == productId) {
          await _wishlistService.removeFromWishlist(itemId: item.id);
          await loadWishlist();
          return true;
        }
      }
      return false;
    } catch (e) {
      emit(WishlistFailed(message: e.toString()));
      return false;
    }
  }

  void clearWishlist({required BuildContext context}) {
    final l10n = AppLocalizations.of(context);
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: l10n!.warning,
        message: l10n.clearWishlist,
        isLoading: isLoading,
        onConfirm: () async {
          emit(WishlistLoading());
          isLoading = true;
          try {
            await _wishlistService.clearWishlist();
            isLoading = false;
            context.pop();
            loadWishlist();
          } catch (e) {
            emit(WishlistFailed(message: e.toString()));
            isLoading = false;
          }
        },
      ),
    );
  }
}
