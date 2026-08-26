import 'package:kalivra/model/checkout/checkout_summary_model.dart';

abstract class CheckoutState {
  const CheckoutState();

  bool get isLoading => false;
  bool get hasError => false;
  Object? get error => null;
  Map<String, dynamic>? get result => null;
  CheckoutSummaryModel? get summary => null;
  List<CheckoutShippingMethodModel> get shippingMethods => const [];
  List<CheckoutPaymentMethodModel> get paymentMethods => const [];
  String? get selectedShippingMethod => null;
  String? get selectedPaymentMethod => null;
  int get currentStep => 0;
}

final class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

final class CheckoutLoading extends CheckoutState {
  const CheckoutLoading({
    this.previous,
    this.shippingMethods = const [],
    this.paymentMethods = const [],
    this.selectedShippingMethod,
    this.selectedPaymentMethod,
    this.currentStep = 0,
  });

  final CheckoutSummaryModel? previous;

  @override
  final List<CheckoutShippingMethodModel> shippingMethods;

  @override
  final List<CheckoutPaymentMethodModel> paymentMethods;

  @override
  final String? selectedShippingMethod;

  @override
  final String? selectedPaymentMethod;

  @override
  final int currentStep;

  @override
  bool get isLoading => true;

  @override
  CheckoutSummaryModel? get summary => previous;
}

final class CheckoutLoaded extends CheckoutState {
  const CheckoutLoaded({
    required this.summary,
    this.shippingMethods = const [],
    this.paymentMethods = const [],
    this.selectedShippingMethod,
    this.selectedPaymentMethod,
    this.currentStep = 0,
  });

  @override
  final CheckoutSummaryModel summary;

  @override
  final List<CheckoutShippingMethodModel> shippingMethods;

  @override
  final List<CheckoutPaymentMethodModel> paymentMethods;

  @override
  final String? selectedShippingMethod;

  @override
  final String? selectedPaymentMethod;

  @override
  final int currentStep;
}

final class CheckoutOrderPlaced extends CheckoutState {
  CheckoutOrderPlaced(this.result);

  @override
  final Map<String, dynamic>? result;
}

final class CheckoutFailed extends CheckoutState {
  CheckoutFailed(
    this._error, [
    this.previous,
    this.shippingMethods = const [],
    this.paymentMethods = const [],
    this.selectedShippingMethod,
    this.selectedPaymentMethod,
    this.currentStep = 0,
  ]);

  final Object _error;
  final CheckoutSummaryModel? previous;

  @override
  final List<CheckoutShippingMethodModel> shippingMethods;

  @override
  final List<CheckoutPaymentMethodModel> paymentMethods;

  @override
  final String? selectedShippingMethod;

  @override
  final String? selectedPaymentMethod;

  @override
  final int currentStep;

  @override
  bool get hasError => true;

  @override
  Object? get error => _error;

  @override
  CheckoutSummaryModel? get summary => previous;
}
