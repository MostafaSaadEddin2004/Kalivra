import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/checkout_cubit/checkout_state.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';
import 'package:kalivra/model/services/api/checkout_api_service.dart';

export 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutInitial());

  final CheckoutApiService _checkoutService = CheckoutApiService();

  CheckoutSummaryModel? get _currentSummary {
    final current = state;
    if (current is CheckoutLoaded) return current.summary;
    if (current is CheckoutLoading) return current.previous;
    if (current is CheckoutFailed) return current.previous;
    return null;
  }

  List<CheckoutShippingMethodModel> get _currentShippingMethods {
    final current = state;
    if (current is CheckoutLoaded) return current.shippingMethods;
    return _currentSummary?.shippingMethods ?? const [];
  }

  List<CheckoutPaymentMethodModel> get _currentPaymentMethods {
    final current = state;
    if (current is CheckoutLoaded) return current.paymentMethods;
    return _currentSummary?.paymentMethods ?? const [];
  }

  String? get _selectedShippingMethod {
    final current = state;
    if (current is CheckoutLoaded) return current.selectedShippingMethod;
    return null;
  }

  String? get _selectedPaymentMethod {
    final current = state;
    if (current is CheckoutLoaded) return current.selectedPaymentMethod;
    return null;
  }

  void reset() => emit(const CheckoutInitial());

  Future<void> loadSummary() async {
    emit(CheckoutLoading(previous: _currentSummary));
    try {
      final summary = await _checkoutService.getSummary();
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods,
          paymentMethods: summary.paymentMethods,
          selectedShippingMethod: _selectedShippingMethod,
          selectedPaymentMethod: _selectedPaymentMethod,
        ),
      );
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
    }
  }

  Future<bool> saveAddresses({
    required Map<String, dynamic> billing,
    required Map<String, dynamic> shipping,
  }) async {
    emit(CheckoutLoading(previous: _currentSummary));
    try {
      final summary = await _checkoutService.saveAddresses(
        billing: billing,
        shipping: shipping,
      );
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods.isNotEmpty
              ? summary.shippingMethods
              : _currentShippingMethods,
          paymentMethods: summary.paymentMethods.isNotEmpty
              ? summary.paymentMethods
              : _currentPaymentMethods,
          selectedShippingMethod: _selectedShippingMethod,
          selectedPaymentMethod: _selectedPaymentMethod,
        ),
      );
      return true;
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
      return false;
    }
  }

  Future<bool> saveShippingMethod(String shippingMethod) async {
    emit(CheckoutLoading(previous: _currentSummary));
    try {
      final summary = await _checkoutService.saveShippingMethod(shippingMethod);
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods.isNotEmpty
              ? summary.shippingMethods
              : _currentShippingMethods,
          paymentMethods: summary.paymentMethods.isNotEmpty
              ? summary.paymentMethods
              : _currentPaymentMethods,
          selectedShippingMethod: shippingMethod,
          selectedPaymentMethod: _selectedPaymentMethod,
        ),
      );
      return true;
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
      return false;
    }
  }

  Future<bool> savePaymentMethod(String paymentMethod) async {
    emit(CheckoutLoading(previous: _currentSummary));
    try {
      final summary = await _checkoutService.savePaymentMethod(paymentMethod);
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods.isNotEmpty
              ? summary.shippingMethods
              : _currentShippingMethods,
          paymentMethods: summary.paymentMethods.isNotEmpty
              ? summary.paymentMethods
              : _currentPaymentMethods,
          selectedShippingMethod: _selectedShippingMethod,
          selectedPaymentMethod: paymentMethod,
        ),
      );
      return true;
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
      return false;
    }
  }

  Future<void> placeOrder() async {
    emit(CheckoutLoading(previous: _currentSummary));
    try {
      final result = await _checkoutService.placeOrder();
      emit(CheckoutOrderPlaced(result));
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
    }
  }
}
