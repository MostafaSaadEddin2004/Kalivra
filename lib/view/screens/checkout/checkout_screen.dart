import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:skeletonizer/skeletonizer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentIndex = 0;
  bool _isCompletingOrder = false;
  bool _isRestoringCheckoutProgress = true;

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
      _restoreCheckoutProgress();
    });
  }

  Future<void> _restoreCheckoutProgress() async {
    final step = await context.read<CheckoutCubit>().restoreCheckoutProgress();
    if (!mounted) return;
    setState(() {
      _currentIndex = step;
      _isRestoringCheckoutProgress = false;
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

      setState(() => _currentIndex = 1);
      await checkoutCubit.saveCheckoutStep(CheckoutCubit.shippingMethodStep);
      return;
    } else if (_currentIndex == 1) {
      final method = _shippingStepKey.currentState?.selectedMethodCode;
      if (method == null || method.isEmpty) {
        _showStepError(l10n.completeStepData);
        return;
      }
      final ok = await checkoutCubit.saveShippingMethod(method);
      if (!ok || !mounted) return;

      setState(() => _currentIndex = 2);
      await checkoutCubit.saveCheckoutStep(CheckoutCubit.paymentMethodStep);
      return;
    } else if (_currentIndex == 2) {
      if (!(_paymentStepKey.currentState?.validateStep() ?? false)) {
        _showStepError(l10n.completeStepData);
        return;
      }
      final payment = _paymentStepKey.currentState!.selectedPaymentMethodCode;
      final ok = await checkoutCubit.savePaymentMethod(payment);
      if (!ok || !mounted) return;
      await checkoutCubit.loadSummary();

      if (!mounted) return;
      setState(() => _currentIndex = 3);
      await checkoutCubit.saveCheckoutStep(CheckoutCubit.orderConfirmationStep);
      return;
    }
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

    await checkoutCubit.resetCheckoutProgress();
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
        final isLoading =
            checkoutState.isLoading ||
            _isCompletingOrder ||
            _isRestoringCheckoutProgress;

        return PopScope(
          canPop: !isLoading,
          child: Scaffold(
            appBar: ScreenAppBar(
              title: l10n.checkOutStepsScreenTitle,
              noBackArrow: !isLoading,
            ),
            body: SafeArea(
              child: _isRestoringCheckoutProgress
                  ? const _CheckoutLoadingSkeleton()
                  : Column(
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
                                selectedMethodCode:
                                    checkoutState.selectedShippingMethod,
                                onContinue: isLoading ? null : _goNext,
                              ),
                              PaymentStep(
                                key: _paymentStepKey,
                                methods: checkoutState.paymentMethods,
                                summary: checkoutState.summary,
                                selectedMethodCode:
                                    checkoutState.selectedPaymentMethod,
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

class _CheckoutLoadingSkeleton extends StatelessWidget {
  const _CheckoutLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;

    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        Container(
                          width: 34.r,
                          height: 34.r,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 10.h,
                          width: 58.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              children: [
                Container(
                  height: 18.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 14.h),
                _CheckoutSkeletonCard(cardColor: cardColor, height: 96.h),
                SizedBox(height: 12.h),
                _CheckoutSkeletonCard(cardColor: cardColor, height: 96.h),
                SizedBox(height: 12.h),
                _CheckoutSkeletonCard(cardColor: cardColor, height: 96.h),
                SizedBox(height: 22.h),
                _CheckoutSkeletonCard(cardColor: cardColor, height: 52.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutSkeletonCard extends StatelessWidget {
  const _CheckoutSkeletonCard({required this.cardColor, required this.height});

  final Color cardColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 10.h,
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
