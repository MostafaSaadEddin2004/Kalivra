import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
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
  static const _stepTitles = ['العنوان', 'الشحن', 'الدفع', 'إتمام الطلب'];

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
        const SnackBar(content: Text('أكمل البيانات المطلوبة في هذه الخطوة')),
      );
      return;
    }
    setState(() => _currentIndex++);
  }

  void _goBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    } else {
      context.pop();
    }
  }

  void _placeOrder() {
    context.read<CartCubit>().clear();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartCubit = context.read<CartCubit>();
    final total = cartCubit.total;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: CustomIconButton(
          icon: Icons.arrow_back_rounded,
          color: theme.appBarTheme.foregroundColor ?? AppColors.offWhite,
          iconSize: 28.r,
          onPressed: _goBack,
          tooltip: 'رجوع',
        ),
        title: Text(
          _stepTitles[_currentIndex],
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
            onProceed: _goNext,
          ),
        ],
      ),
    );
  }
}
