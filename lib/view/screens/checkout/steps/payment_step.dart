import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';
import 'package:kalivra/view/screens/checkout/steps/address_step.dart';

class PaymentStep extends StatefulWidget {
  const PaymentStep({
    super.key,
    required this.methods,
    required this.summary,
    required this.onContinue,
  });

  final List<CheckoutPaymentMethodModel> methods;
  final CheckoutSummaryModel? summary;
  final VoidCallback? onContinue;

  @override
  State<PaymentStep> createState() => PaymentStepState();
}

class PaymentStepState extends State<PaymentStep> {
  String? _selectedMethodCode;

  @override
  void initState() {
    super.initState();
    _selectedMethodCode = _visibleMethod.method;
  }

  @override
  void didUpdateWidget(covariant PaymentStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedMethodCode ??= _visibleMethod.method;
  }

  CheckoutPaymentMethodModel get _visibleMethod {
    if (widget.methods.isEmpty) {
      return const CheckoutPaymentMethodModel(
        method: 'cashondelivery',
        title: '',
      );
    }
    return widget.methods.firstWhere(
      (method) => _isCashOnDelivery(method.method),
      orElse: () => widget.methods.first,
    );
  }

  String get selectedPaymentMethodCode =>
      _selectedMethodCode ?? _visibleMethod.method;

  bool validateStep() => selectedPaymentMethodCode.isNotEmpty;

  bool _isCashOnDelivery(String code) {
    final value = code.toLowerCase();
    return value == 'cashondelivery' ||
        value == 'cash_on_delivery' ||
        value == 'cod';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final address = CheckoutAddressData.fromSummary(widget.summary).firstOrNull;
    final method = _visibleMethod;
    final title = method.title.trim().isNotEmpty
        ? method.title
        : l10n.cashOnDelivery;
    final description = method.description?.trim().isNotEmpty == true
        ? method.description!
        : l10n.cashOnDeliverySubtitle;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (address != null) ...[
            _AddressSummaryCard(address: address),
            SizedBox(height: 26.h),
          ],
          _CheckoutSectionTitle(title: l10n.checkoutChoosePaymentMethod),
          SizedBox(height: 12.h),
          _PaymentMethodCard(
            title: title,
            description: description,
            selected: true,
            onTap: () => setState(() => _selectedMethodCode = method.method),
          ),
          SizedBox(height: 28.h),
          _CheckoutPrimaryButton(
            label: l10n.checkoutContinueToSummary,
            icon: Icons.receipt_long_outlined,
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _AddressSummaryCard extends StatelessWidget {
  const _AddressSummaryCard({required this.address});

  final CheckoutAddressData address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.primaryFixed.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: AppColors.burgundy,
            size: 25.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.fullName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  [
                    address.address,
                    address.cityLine,
                  ].where((part) => part.trim().isNotEmpty).join('، '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primaryFixed.withValues(alpha: 0.55),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.burgundy,
            size: 24.r,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.burgundy.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.burgundy, width: 1.2.w),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: AppColors.burgundy,
              size: 23.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primaryFixed,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primaryFixed.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.payments_outlined,
              color: colorScheme.primaryFixed,
              size: 32.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutSectionTitle extends StatelessWidget {
  const _CheckoutSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).colorScheme.primaryFixed,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.start,
    );
  }
}

class _CheckoutPrimaryButton extends StatelessWidget {
  const _CheckoutPrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 21.r),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.burgundy,
        foregroundColor: AppColors.offWhite,
        padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 18.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}
