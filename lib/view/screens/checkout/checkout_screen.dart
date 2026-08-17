import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/checkout_cubit/checkout_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/checkout/steps/address_step.dart';
import 'package:kalivra/view/screens/checkout/steps/checkout_step.dart';
import 'package:kalivra/view/screens/checkout/steps/payment_step.dart';
import 'package:kalivra/view/screens/checkout/steps/shipping_step.dart';
import 'package:kalivra/view/screens/checkout/widgets/checkout_step_indicator.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentIndex = 0;
  bool _isCompletingOrder = false;

  final GlobalKey<AddressStepState> _addressStepKey =
      GlobalKey<AddressStepState>();
  final GlobalKey<ShippingStepState> _shippingStepKey =
      GlobalKey<ShippingStepState>();
  final GlobalKey<PaymentStepState> _paymentStepKey =
      GlobalKey<PaymentStepState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckoutCubit>().loadSummary();
    });
  }

  Future<void> _goNext() async {
    final l10n = AppLocalizations.of(context)!;
    final checkoutCubit = context.read<CheckoutCubit>();

    if (_currentIndex == 3) {
      await checkoutCubit.placeOrder();
      return;
    }

    if (_currentIndex == 0) {
      final addressState = _addressStepKey.currentState;
      final address = addressState?.selectedAddress;
      if (!(addressState?.validateStep() ?? false) || address == null) {
        _showStepError(l10n.completeStepData);
        return;
      }

      final ok = await checkoutCubit.saveAddresses(
        firstName: address.firstName,
        lasttName: address.lastName,
        email: address.email,
        address: address.address,
        country: address.country.isEmpty ? 'SY' : address.country,
        state: address.state,
        city: address.city,
        postcode: address.postcode.isEmpty ? '0000' : address.postcode,
        phone: address.phone,
      );
      if (!ok || !mounted) return;

      final loadedShippingMethods = await checkoutCubit.loadShippingMethods();
      if (!loadedShippingMethods || !mounted) return;
    } else if (_currentIndex == 1) {
      final method = _shippingStepKey.currentState?.selectedMethodCode;
      if (method == null || method.isEmpty) {
        _showStepError(l10n.completeStepData);
        return;
      }
      final ok = await checkoutCubit.saveShippingMethod(method);
      if (!ok || !mounted) return;
    } else if (_currentIndex == 2) {
      if (!(_paymentStepKey.currentState?.validateStep() ?? false)) {
        _showStepError(l10n.completeStepData);
        return;
      }
      final payment = _paymentStepKey.currentState!.selectedPaymentMethodCode;
      final ok = await checkoutCubit.savePaymentMethod(payment);
      if (!ok || !mounted) return;
      await checkoutCubit.loadSummary();
    }

    if (!mounted) return;
    setState(() => _currentIndex++);
  }

  void _showStepError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleOrderPlaced(CheckoutOrderPlaced state) async {
    if (_isCompletingOrder) return;
    setState(() => _isCompletingOrder = true);

    final checkoutCubit = context.read<CheckoutCubit>();
    final cartCubit = context.read<CartCubit>();
    final message =
        _responseMessage(state.result) ??
        AppLocalizations.of(context)!.requestSentSuccessfully;

    await cartCubit.getCart();
    if (!mounted) return;
    cartCubit.markCartEmptyAfterOrder();

    checkoutCubit.reset();
    CustomSnackBar.show(context, message);
    context.go(AppRoutes.home);
  }

  String? _responseMessage(Map<String, dynamic>? response) {
    if (response == null) return null;

    final keys = ['message', 'success_message', 'successMessage'];
    for (final key in keys) {
      final message = _stringValue(response[key]);
      if (message != null) return message;
    }

    final data = response['data'];
    if (data is Map<String, dynamic>) return _responseMessage(data);
    if (data is Map) return _responseMessage(Map<String, dynamic>.from(data));
    return null;
  }

  String? _stringValue(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutOrderPlaced) {
          _handleOrderPlaced(state);
          return;
        }
        if (state.hasError) {
          if (_isCompletingOrder) {
            setState(() => _isCompletingOrder = false);
          }
          final message = state.error?.toString() ?? l10n.error;
          CustomSnackBar.show(context, message);
          context.read<CheckoutCubit>().reset();
        }
      },
      builder: (context, checkoutState) {
        final isLoading = checkoutState.isLoading || _isCompletingOrder;

        return PopScope(
          canPop: !isLoading,
          child: Scaffold(
            appBar: ScreenAppBar(
              title: l10n.checkOutStepsScreenTitle,
              noBackArrow: !isLoading,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  CheckoutStepIndicator(
                    currentStep: _currentIndex,
                    onStepTap: (index) {
                      if (!isLoading && index <= _currentIndex) {
                        setState(() => _currentIndex = index);
                      }
                    },
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
                        AddressStep(
                          key: _addressStepKey,
                          summary: checkoutState.summary,
                          onContinue: isLoading ? null : _goNext,
                        ),
                        ShippingStep(
                          key: _shippingStepKey,
                          methods: checkoutState.shippingMethods,
                          summary: checkoutState.summary,
                          onContinue: isLoading ? null : _goNext,
                        ),
                        PaymentStep(
                          key: _paymentStepKey,
                          methods: checkoutState.paymentMethods,
                          summary: checkoutState.summary,
                          onContinue: isLoading ? null : _goNext,
                        ),
                        CheckoutStep(
                          isLoading: isLoading,
                          onConfirm: isLoading ? null : _goNext,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
