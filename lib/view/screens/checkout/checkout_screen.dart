import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/checkout_cubit/checkout_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/screens/checkout/widgets/checkout_step_indicator.dart';
import 'package:kalivra/view/screens/checkout/widgets/checkout_bottom_bar.dart';
import 'package:kalivra/view/screens/checkout/steps/address_step.dart';
import 'package:kalivra/view/screens/checkout/steps/shipping_step.dart';
import 'package:kalivra/view/screens/checkout/steps/payment_step.dart';
import 'package:kalivra/view/screens/checkout/steps/checkout_step.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentIndex = 0;

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
      checkoutCubit.placeOrder();
      return;
    }

    if (_currentIndex == 0) {
      if (!(_addressStepKey.currentState?.validateStep() ?? false)) {
        _showStepError(l10n.completeStepData);
        return;
      }
      final payload = _addressStepKey.currentState!.buildAddressesBody();
      final ok = await checkoutCubit.saveAddresses(
        billing: payload['billing'] as Map<String, dynamic>,
        shipping: payload['shipping'] as Map<String, dynamic>,
      );
      if (!ok || !mounted) return;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _stepTitle(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return l10n.checkoutStepAddress;
      case 1:
        return l10n.checkoutStepShipping;
      case 2:
        return l10n.checkoutStepPayment;
      case 3:
        return l10n.checkoutStepComplete;
      default:
        return l10n.checkoutStepAddress;
    }
  }

  void _goBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartCubit = context.read<CartCubit>();
    final total = cartCubit.total;

    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.hasError) {
         
          context.read<CheckoutCubit>().reset();
        }
        if (state is CheckoutOrderPlaced) {
          context.read<CartCubit>().clearCart();
          if (context.mounted) context.pop();
          context.read<CheckoutCubit>().reset();
        }
      },
      builder: (context, checkoutState) {
        final isPlacing = checkoutState.isLoading;
        final shippingMethods = checkoutState.shippingMethods;
        final paymentMethods = checkoutState.paymentMethods;

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: CustomIconButton(
                  icon: Icons.arrow_back_rounded,
                  color: theme.appBarTheme.foregroundColor ?? AppColors.offWhite,
                  iconSize: 28.r,
                  onPressed: isPlacing ? null : _goBack,
                  tooltip: AppLocalizations.of(context)!.back,
                ),
                title: Text(
                  _stepTitle(context, _currentIndex),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Column(
                children: [
                  CheckoutStepIndicator(
                    currentStep: _currentIndex,
                    onStepTap: null,
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
                        AddressStep(key: _addressStepKey),
                        ShippingStep(
                          key: _shippingStepKey,
                          methods: shippingMethods,
                        ),
                        PaymentStep(
                          key: _paymentStepKey,
                          methods: paymentMethods,
                        ),
                        const CheckoutStep(),
                      ],
                    ),
                  ),
                  CheckoutBottomBar(
                    amount: total,
                    isLastStep: _currentIndex == 3,
                    onProceed: isPlacing ? () {} : _goNext,
                  ),
                ],
              ),
            ),
            if (isPlacing)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.offWhite,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
