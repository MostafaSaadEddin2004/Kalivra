import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/checkout_cubit/checkout_state.dart';
import 'package:kalivra/services/api/checkout_api_service.dart';

export 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._checkoutService) : super(CheckoutState.initial);

  final CheckoutApiService _checkoutService;

  Future<void> placeOrder(Map<String, dynamic> body) async {
    emit(CheckoutState.loading);
    try {
      final result = await _checkoutService.checkout(body);
      emit(CheckoutState.success(result));
    } catch (e, st) {
      emit(CheckoutState.failed(e, st));
    }
  }

  void reset() => emit(CheckoutState.initial);
}
