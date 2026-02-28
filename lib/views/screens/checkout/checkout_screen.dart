import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/checkout_cubit/checkout_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/screens/checkout/widgets/checkout_step_indicator.dart';
import 'package:kalivra/views/screens/checkout/widgets/checkout_bottom_bar.dart';
import 'package:kalivra/views/screens/checkout/steps/address_step.dart';
import 'package:kalivra/views/screens/checkout/steps/shipping_step.dart';
import 'package:kalivra/views/screens/checkout/steps/payment_step.dart';
import 'package:kalivra/views/screens/checkout/steps/checkout_step.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentIndex = 0;

  final GlobalKey<AddressStepState> _addressStepKey = GlobalKey<AddressStepState>();
  final GlobalKey<ShippingStepState> _shippingStepKey = GlobalKey<ShippingStepState>();
  final GlobalKey<PaymentStepState> _paymentStepKey = GlobalKey<PaymentStepState>();

  void _goNext() {
    if (_currentIndex == 3) {
      _placeOrder();
      return;
    }

    bool canProceed = false;
    if (_currentIndex == 0) {
      canProceed = _addressStepKey.currentState?.validateStep() ?? false;
    } else if (_currentIndex == 1) {
      canProceed = _shippingStepKey.currentState?.validateStep() ?? false;
    } else if (_currentIndex == 2) {
      canProceed = _paymentStepKey.currentState?.validateStep() ?? false;
    } else {
      canProceed = true;
    }

    if (!canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.completeStepData)),
      );
      return;
    }
    setState(() => _currentIndex++);
  }

  String _stepTitle(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0: return l10n.checkoutStepAddress;
      case 1: return l10n.checkoutStepShipping;
      case 2: return l10n.checkoutStepPayment;
      case 3: return l10n.checkoutStepComplete;
      default: return l10n.checkoutStepAddress;
    }
  }

  void _goBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    } else {
      context.pop();
    }
  }

  void _placeOrder() {
    final cartCubit = context.read<CartCubit>();
    final total = cartCubit.total;
    final items = cartCubit.state.items;
    final body = <String, dynamic>{
      'grand_total': total,
      'items': items.map((e) => {'product_id': e.product.id, 'quantity': e.quantity}).toList(),
    };
    context.read<CheckoutCubit>().placeOrder(body);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartCubit = context.read<CartCubit>();
    final total = cartCubit.total;

    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.hasError) {
          ApiErrorHandler.showErrorDialog(
            context,
            state.error!,
            fallbackMessage: AppLocalizations.of(context)!.placeOrderFailed,
          );
          context.read<CheckoutCubit>().reset();
        }
        if (state.result != null) {
          context.read<CartCubit>().clear();
          if (context.mounted) context.pop();
          context.read<CheckoutCubit>().reset();
        }
      },
      builder: (context, checkoutState) {
        final isPlacing = checkoutState.isLoading;
        return Stack(
          children: [
            Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: CustomIconButton(
          icon: Icons.arrow_back_rounded,
          color: theme.appBarTheme.foregroundColor ?? AppColors.offWhite,
          iconSize: 28.r,
          onPressed: _goBack,
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
                ShippingStep(key: _shippingStepKey),
                PaymentStep(key: _paymentStepKey),
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
