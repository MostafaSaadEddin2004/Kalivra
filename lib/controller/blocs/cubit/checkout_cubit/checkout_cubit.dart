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
    final currentSummary = _currentSummary;
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final selectedPaymentMethod = _selectedPaymentMethod;
    emit(
      CheckoutLoading(
        previous: currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
      ),
    );
    try {
      final summary = await _checkoutService.getSummary();
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods.isNotEmpty
              ? summary.shippingMethods
              : currentShippingMethods,
          paymentMethods: summary.paymentMethods.isNotEmpty
              ? summary.paymentMethods
              : currentPaymentMethods,
          selectedShippingMethod: selectedShippingMethod,
          selectedPaymentMethod: selectedPaymentMethod,
        ),
      );
    } catch (e) {
      emit(CheckoutFailed(e, currentSummary));
    }
  }

  Future<bool> saveAddresses({
    required String firstName,
    required String lasttName,
    required String email,
    required String address,
    required String country,
    required String state,
    required String city,
    required String postcode,
    required String phone,
  }) async {
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final selectedPaymentMethod = _selectedPaymentMethod;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
      ),
    );
    try {
      final summary = await _checkoutService.storeAddresses(
        firstName: firstName,
        lasttName: lasttName,
        email: email,
        address: address,
        country: country,
        state: state,
        city: city,
        postcode: postcode,
        phone: phone,
      );
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods.isNotEmpty
              ? summary.shippingMethods
              : currentShippingMethods,
          paymentMethods: summary.paymentMethods.isNotEmpty
              ? summary.paymentMethods
              : currentPaymentMethods,
          selectedShippingMethod: selectedShippingMethod,
          selectedPaymentMethod: selectedPaymentMethod,
        ),
      );
      return true;
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
      return false;
    }
  }

  Future<bool> saveShippingMethod(String shippingMethod) async {
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedPaymentMethod = _selectedPaymentMethod;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: shippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
      ),
    );
    try {
      final summary = await _checkoutService.storeShippingMethod(
        shippingMethod,
      );
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods.isNotEmpty
              ? summary.shippingMethods
              : currentShippingMethods,
          paymentMethods: summary.paymentMethods.isNotEmpty
              ? summary.paymentMethods
              : currentPaymentMethods,
          selectedShippingMethod: shippingMethod,
          selectedPaymentMethod: selectedPaymentMethod,
        ),
      );
      return true;
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
      return false;
    }
  }

  Future<bool> loadShippingMethods() async {
    final currentSummary = _currentSummary;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final selectedPaymentMethod = _selectedPaymentMethod;
    emit(
      CheckoutLoading(
        previous: currentSummary,
        shippingMethods: _currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
      ),
    );
    try {
      final shippingMethods = await _checkoutService.getShippingMethods();
      emit(
        CheckoutLoaded(
          summary: currentSummary ?? const CheckoutSummaryModel(),
          shippingMethods: shippingMethods,
          paymentMethods: currentPaymentMethods,
          selectedShippingMethod: selectedShippingMethod,
          selectedPaymentMethod: selectedPaymentMethod,
        ),
      );
      return true;
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
      return false;
    }
  }

  Future<bool> savePaymentMethod(String paymentMethod) async {
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: paymentMethod,
      ),
    );
    try {
      final summary = await _checkoutService.storePaymentMethod(paymentMethod);
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: summary.shippingMethods.isNotEmpty
              ? summary.shippingMethods
              : currentShippingMethods,
          paymentMethods: summary.paymentMethods.isNotEmpty
              ? summary.paymentMethods
              : currentPaymentMethods,
          selectedShippingMethod: selectedShippingMethod,
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
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final selectedPaymentMethod = _selectedPaymentMethod;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
      ),
    );
    try {
      final result = await _checkoutService.placeOrder();
      emit(CheckoutOrderPlaced(result));
    } catch (e) {
      emit(CheckoutFailed(e, _currentSummary));
    }
  }
}
