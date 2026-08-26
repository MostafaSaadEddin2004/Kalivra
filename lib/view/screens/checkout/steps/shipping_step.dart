import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';
import 'package:kalivra/view/screens/checkout/steps/address_step.dart';

class ShippingStep extends StatefulWidget {
  const ShippingStep({
    super.key,
    required this.methods,
    required this.summary,
    required this.onContinue,
    this.selectedMethodCode,
  });

  final List<CheckoutShippingMethodModel> methods;
  final CheckoutSummaryModel? summary;
  final VoidCallback? onContinue;
  final String? selectedMethodCode;

  @override
  State<ShippingStep> createState() => ShippingStepState();
}

class ShippingStepState extends State<ShippingStep> {
  String? _selectedMethodCode;

  @override
  void initState() {
    super.initState();
    _selectDefault();
  }

  @override
  void didUpdateWidget(covariant ShippingStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMethodCode != widget.selectedMethodCode ||
        _selectedMethodCode == null ||
        !widget.methods.any((method) => method.method == _selectedMethodCode)) {
      _selectDefault();
    }
  }

  void _selectDefault() {
    final storedMethod = widget.selectedMethodCode;
    if (storedMethod != null &&
        widget.methods.any((method) => method.method == storedMethod)) {
      _selectedMethodCode = storedMethod;
      return;
    }
    if (widget.methods.isNotEmpty) {
      _selectedMethodCode = widget.methods.first.method;
    }
  }

  String? get selectedMethodCode => _selectedMethodCode;

  CheckoutShippingMethodModel? get selectedMethod {
    for (final method in widget.methods) {
      if (method.method == _selectedMethodCode) return method;
    }
    return widget.methods.isNotEmpty ? widget.methods.first : null;
  }

  bool validateStep() =>
      _selectedMethodCode != null && _selectedMethodCode!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final address = CheckoutAddressData.fromSummary(widget.summary).firstOrNull;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (address != null) ...[
            _AddressSummaryCard(address: address),
            SizedBox(height: 26.h),
          ],
          _CheckoutSectionTitle(title: l10n.checkoutChooseShippingMethod),
          SizedBox(height: 12.h),
          if (widget.methods.isEmpty)
            _EmptyOptionCard(text: l10n.completeStepData)
          else
            ...widget.methods.map((method) {
              final selected = _selectedMethodCode == method.method;
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _ShippingMethodCard(
                  method: method,
                  selected: selected,
                  onTap: () =>
                      setState(() => _selectedMethodCode = method.method),
                ),
              );
            }),
          SizedBox(height: 22.h),
          _CheckoutPrimaryButton(
            label: l10n.checkoutContinueToPayment,
            icon: Icons.payment_rounded,
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

class _ShippingMethodCard extends StatelessWidget {
  const _ShippingMethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final CheckoutShippingMethodModel method;
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
          color: selected
              ? AppColors.burgundy.withValues(alpha: 0.035)
              : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected
                ? AppColors.burgundy
                : colorScheme.primaryFixed.withValues(alpha: 0.08),
            width: selected ? 1.2.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected
                  ? AppColors.burgundy
                  : colorScheme.primaryFixed.withValues(alpha: 0.45),
              size: 23.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primaryFixed,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (method.description?.isNotEmpty == true) ...[
                    SizedBox(height: 4.h),
                    Text(
                      method.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primaryFixed.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                  SizedBox(height: 5.h),
                  Text(
                    method.formattedPrice ??
                        (method.price != null
                            ? method.price!.toStringAsFixed(0)
                            : ''),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primaryFixed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _shippingIcon(method.method),
              color: colorScheme.primaryFixed,
              size: 30.r,
            ),
          ],
        ),
      ),
    );
  }

  IconData _shippingIcon(String code) {
    final value = code.toLowerCase();
    if (value.contains('pickup') || value.contains('store')) {
      return Icons.storefront_outlined;
    }
    if (value.contains('same') || value.contains('fast')) {
      return Icons.delivery_dining_rounded;
    }
    return Icons.local_shipping_outlined;
  }
}

class _EmptyOptionCard extends StatelessWidget {
  const _EmptyOptionCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(text, textAlign: TextAlign.center),
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
