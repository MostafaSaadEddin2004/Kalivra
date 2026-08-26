import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/checkout_cubit/checkout_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';
import 'package:kalivra/model/services/api/checkout_api_service.dart';

export 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutInitial());

  static const int addressStep = 0;
  static const int shippingMethodStep = 1;
  static const int paymentMethodStep = 2;
  static const int orderConfirmationStep = 3;

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
    if (current is CheckoutLoading) return current.shippingMethods;
    if (current is CheckoutFailed) return current.shippingMethods;
    return _currentSummary?.shippingMethods ?? const [];
  }

  List<CheckoutPaymentMethodModel> get _currentPaymentMethods {
    final current = state;
    if (current is CheckoutLoaded) return current.paymentMethods;
    if (current is CheckoutLoading) return current.paymentMethods;
    if (current is CheckoutFailed) return current.paymentMethods;
    return _currentSummary?.paymentMethods ?? const [];
  }

  String? get _selectedShippingMethod {
    final current = state;
    if (current is CheckoutLoaded) return current.selectedShippingMethod;
    if (current is CheckoutLoading) return current.selectedShippingMethod;
    if (current is CheckoutFailed) return current.selectedShippingMethod;
    return null;
  }

  String? get _selectedPaymentMethod {
    final current = state;
    if (current is CheckoutLoaded) return current.selectedPaymentMethod;
    if (current is CheckoutLoading) return current.selectedPaymentMethod;
    if (current is CheckoutFailed) return current.selectedPaymentMethod;
    return null;
  }

  int get _currentStep => state.currentStep;

  void reset() => emit(const CheckoutInitial());

  Future<int?> loadCheckoutStep() => LocalStore.getCheckoutStep();

  Future<void> saveCheckoutStep(int step) async {
    final normalizedStep = step.clamp(addressStep, orderConfirmationStep);
    await LocalStore.setCheckoutStep(normalizedStep);
    _emitWithStep(normalizedStep);
  }

  Future<void> resetCheckoutProgress() => LocalStore.resetCheckoutProgress();

  Future<int> restoreCheckoutProgress() async {
    final savedStep = await loadCheckoutStep() ?? addressStep;
    final savedShippingMethod = _cleanText(
      await LocalStore.getCheckoutShippingMethod(),
    );
    final savedPaymentMethod = _cleanText(
      await LocalStore.getCheckoutPaymentMethod(),
    );

    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: _currentShippingMethods,
        paymentMethods: _currentPaymentMethods,
        selectedShippingMethod: savedShippingMethod,
        selectedPaymentMethod: savedPaymentMethod,
        currentStep: savedStep,
      ),
    );

    try {
      final summary = await _checkoutService.getSummary();
      var shippingMethods = summary.shippingMethods;
      final paymentMethods = summary.paymentMethods;

      if (savedStep >= shippingMethodStep && shippingMethods.isEmpty) {
        shippingMethods = await _checkoutService.getShippingMethods();
      }

      final selectedShippingMethod =
          _validShippingMethod(savedShippingMethod, shippingMethods) ??
          _cleanText(summary.cart?.shippingMethod);
      final selectedPaymentMethod =
          _validPaymentMethod(savedPaymentMethod, paymentMethods) ??
          _cleanText(summary.cart?.paymentMethod);
      final resolvedStep = resolveValidCheckoutStep(
        requestedStep: savedStep,
        summary: summary,
        shippingMethods: shippingMethods,
        paymentMethods: paymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
      );

      await LocalStore.setCheckoutStep(resolvedStep);
      emit(
        CheckoutLoaded(
          summary: summary,
          shippingMethods: shippingMethods,
          paymentMethods: paymentMethods,
          selectedShippingMethod: selectedShippingMethod,
          selectedPaymentMethod: selectedPaymentMethod,
          currentStep: resolvedStep,
        ),
      );
      return resolvedStep;
    } catch (e) {
      emit(
        CheckoutFailed(
          e,
          _currentSummary,
          _currentShippingMethods,
          _currentPaymentMethods,
          savedShippingMethod,
          savedPaymentMethod,
          addressStep,
        ),
      );
      return addressStep;
    }
  }

  int resolveValidCheckoutStep({
    required int requestedStep,
    required CheckoutSummaryModel? summary,
    required List<CheckoutShippingMethodModel> shippingMethods,
    required List<CheckoutPaymentMethodModel> paymentMethods,
    required String? selectedShippingMethod,
    required String? selectedPaymentMethod,
  }) {
    final step = requestedStep.clamp(addressStep, orderConfirmationStep);
    if (step <= addressStep) return addressStep;
    if (!_hasValidAddress(summary)) return addressStep;
    if (step == shippingMethodStep) return shippingMethodStep;
    if (!_hasValidShippingMethod(selectedShippingMethod, shippingMethods)) {
      return shippingMethodStep;
    }
    if (step == paymentMethodStep) return paymentMethodStep;
    if (!_hasValidPaymentMethod(selectedPaymentMethod, paymentMethods)) {
      return paymentMethodStep;
    }
    return orderConfirmationStep;
  }

  Future<void> loadSummary() async {
    final currentSummary = _currentSummary;
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final selectedPaymentMethod = _selectedPaymentMethod;
    final currentStep = _currentStep;
    emit(
      CheckoutLoading(
        previous: currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
        currentStep: currentStep,
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
          currentStep: currentStep,
        ),
      );
    } catch (e) {
      emit(
        CheckoutFailed(
          e,
          currentSummary,
          currentShippingMethods,
          currentPaymentMethods,
          selectedShippingMethod,
          selectedPaymentMethod,
          currentStep,
        ),
      );
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
    final currentStep = _currentStep;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
        currentStep: currentStep,
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
          currentStep: currentStep,
        ),
      );
      return true;
    } catch (e) {
      emit(
        CheckoutFailed(
          e,
          _currentSummary,
          currentShippingMethods,
          currentPaymentMethods,
          selectedShippingMethod,
          selectedPaymentMethod,
          currentStep,
        ),
      );
      return false;
    }
  }

  Future<bool> saveShippingMethod(String shippingMethod) async {
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedPaymentMethod = _selectedPaymentMethod;
    final currentStep = _currentStep;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: shippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
        currentStep: currentStep,
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
          currentStep: currentStep,
        ),
      );
      await LocalStore.setCheckoutShippingMethod(shippingMethod);
      return true;
    } catch (e) {
      emit(
        CheckoutFailed(
          e,
          _currentSummary,
          currentShippingMethods,
          currentPaymentMethods,
          _selectedShippingMethod,
          selectedPaymentMethod,
          currentStep,
        ),
      );
      return false;
    }
  }

  Future<bool> loadShippingMethods() async {
    final currentSummary = _currentSummary;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final selectedPaymentMethod = _selectedPaymentMethod;
    final currentStep = _currentStep;
    emit(
      CheckoutLoading(
        previous: currentSummary,
        shippingMethods: _currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
        currentStep: currentStep,
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
          currentStep: currentStep,
        ),
      );
      return true;
    } catch (e) {
      emit(
        CheckoutFailed(
          e,
          _currentSummary,
          _currentShippingMethods,
          currentPaymentMethods,
          selectedShippingMethod,
          selectedPaymentMethod,
          currentStep,
        ),
      );
      return false;
    }
  }

  Future<bool> savePaymentMethod(String paymentMethod) async {
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final currentStep = _currentStep;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: paymentMethod,
        currentStep: currentStep,
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
          currentStep: currentStep,
        ),
      );
      await LocalStore.setCheckoutPaymentMethod(paymentMethod);
      return true;
    } catch (e) {
      emit(
        CheckoutFailed(
          e,
          _currentSummary,
          currentShippingMethods,
          currentPaymentMethods,
          selectedShippingMethod,
          _selectedPaymentMethod,
          currentStep,
        ),
      );
      return false;
    }
  }

  Future<void> placeOrder() async {
    final currentShippingMethods = _currentShippingMethods;
    final currentPaymentMethods = _currentPaymentMethods;
    final selectedShippingMethod = _selectedShippingMethod;
    final selectedPaymentMethod = _selectedPaymentMethod;
    final currentStep = _currentStep;
    emit(
      CheckoutLoading(
        previous: _currentSummary,
        shippingMethods: currentShippingMethods,
        paymentMethods: currentPaymentMethods,
        selectedShippingMethod: selectedShippingMethod,
        selectedPaymentMethod: selectedPaymentMethod,
        currentStep: currentStep,
      ),
    );
    try {
      final result = await _checkoutService.placeOrder();
      await resetCheckoutProgress();
      emit(CheckoutOrderPlaced(result));
    } catch (e) {
      emit(
        CheckoutFailed(
          e,
          _currentSummary,
          currentShippingMethods,
          currentPaymentMethods,
          selectedShippingMethod,
          selectedPaymentMethod,
          currentStep,
        ),
      );
    }
  }

  String? _validShippingMethod(
    String? selectedMethod,
    List<CheckoutShippingMethodModel> methods,
  ) {
    final selected = _cleanText(selectedMethod);
    if (selected == null) return null;
    if (methods.isEmpty) return selected;
    return methods.any((method) => method.method == selected) ? selected : null;
  }

  String? _validPaymentMethod(
    String? selectedMethod,
    List<CheckoutPaymentMethodModel> methods,
  ) {
    final selected = _cleanText(selectedMethod);
    if (selected == null) return null;
    if (methods.isEmpty) return selected;
    return methods.any((method) => method.method == selected) ? selected : null;
  }

  bool _hasValidShippingMethod(
    String? selectedMethod,
    List<CheckoutShippingMethodModel> methods,
  ) {
    return _validShippingMethod(selectedMethod, methods) != null;
  }

  bool _hasValidPaymentMethod(
    String? selectedMethod,
    List<CheckoutPaymentMethodModel> methods,
  ) {
    return _validPaymentMethod(selectedMethod, methods) != null;
  }

  bool _hasValidAddress(CheckoutSummaryModel? summary) {
    if (summary == null) return false;
    final maps = <Map<String, dynamic>>[];
    void addMap(dynamic value) {
      if (value is Map<String, dynamic>) maps.add(value);
      if (value is Map) maps.add(Map<String, dynamic>.from(value));
    }

    addMap(summary.cart?.shippingAddress);
    addMap(summary.cart?.billingAddress);
    addMap(summary.raw['shipping_address']);
    addMap(summary.raw['billing_address']);
    addMap(summary.raw['shippingAddress']);
    addMap(summary.raw['billingAddress']);

    final rawAddresses = summary.raw['addresses'];
    if (rawAddresses is List) {
      for (final address in rawAddresses) {
        addMap(address);
      }
    }

    return maps.any(_isUsableAddressMap);
  }

  bool _isUsableAddressMap(Map<String, dynamic> json) {
    final name = _cleanText(
      json['first_name'] ??
          json['firstName'] ??
          json['name'] ??
          json['full_name'],
    );
    final address = _addressText(json);
    final phone = _cleanText(
      json['phone'] ?? json['telephone'] ?? json['mobile'],
    );
    return name != null && address != null && phone != null;
  }

  String? _addressText(Map<String, dynamic> json) {
    final raw =
        json['address'] ??
        json['street'] ??
        json['street_address'] ??
        json['address1'] ??
        json['formatted'];
    if (raw is List) {
      return _cleanText(
        raw
            .map((line) => line.toString().trim())
            .where((line) {
              return line.isNotEmpty;
            })
            .join('، '),
      );
    }
    return _cleanText(raw);
  }

  String? _cleanText(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  void _emitWithStep(int step) {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(
        CheckoutLoaded(
          summary: current.summary,
          shippingMethods: current.shippingMethods,
          paymentMethods: current.paymentMethods,
          selectedShippingMethod: current.selectedShippingMethod,
          selectedPaymentMethod: current.selectedPaymentMethod,
          currentStep: step,
        ),
      );
    } else if (current is CheckoutFailed) {
      emit(
        CheckoutFailed(
          current.error ?? '',
          current.previous,
          current.shippingMethods,
          current.paymentMethods,
          current.selectedShippingMethod,
          current.selectedPaymentMethod,
          step,
        ),
      );
    }
  }
}
