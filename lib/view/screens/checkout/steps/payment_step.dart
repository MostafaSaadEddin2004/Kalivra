import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';

class PaymentStep extends StatefulWidget {
  const PaymentStep({
    super.key,
    required this.methods,
  });

  final List<CheckoutPaymentMethodModel> methods;

  @override
  State<PaymentStep> createState() => PaymentStepState();
}

class PaymentStepState extends State<PaymentStep> {
  String? _selectedMethodCode;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMethodCode = _initialMethodCode();
  }

  String? _initialMethodCode() {
    if (widget.methods.isEmpty) return 'cashondelivery';
    final cod = widget.methods.firstWhere(
      (m) => m.method == 'cashondelivery',
      orElse: () => widget.methods.first,
    );
    return cod.method;
  }

  String get selectedPaymentMethodCode =>
      _selectedMethodCode ?? 'cashondelivery';

  bool get _requiresWalletDetails {
    final code = selectedPaymentMethodCode.toLowerCase();
    return code != 'cashondelivery' && code != 'cash_on_delivery' && code != 'cod';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool validateStep() {
    if (!_requiresWalletDetails) return _selectedMethodCode != null;
    return (_formKey.currentState?.validate() ?? false) &&
        _selectedMethodCode != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.offWhite : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;
    final methods = widget.methods.isNotEmpty
        ? widget.methods
        : [
            const CheckoutPaymentMethodModel(
              method: 'cashondelivery',
              title: 'Cash On Delivery',
            ),
          ];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paymentMethod,
            style: theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          ...methods.map(
            (method) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildMethodOption(
                context: context,
                method: method,
                textColor: textColor,
                isDark: isDark,
              ),
            ),
          ),
          if (_requiresWalletDetails) ...[
            SizedBox(height: 24.h),
            Text(
              l10n.walletDetails,
              style: theme.textTheme.titleMedium?.copyWith(color: textColor),
            ),
            SizedBox(height: 12.h),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _phoneController,
                    label: l10n.walletPhoneLabel,
                    hint: '09XXXXXXXX',
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return l10n.required;
                      if (v.trim().length < 8) return l10n.invalidPhone;
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _nameController,
                    label: l10n.walletNameLabel,
                    hint: l10n.walletNameHint,
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodOption({
    required BuildContext context,
    required CheckoutPaymentMethodModel method,
    required Color textColor,
    required bool isDark,
  }) {
    final selected = _selectedMethodCode == method.method;
    return InkWell(
      onTap: () => setState(() => _selectedMethodCode = method.method),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1A1918)
              : AppColors.offWhite.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected
                ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                : AppColors.taupe.withValues(alpha: 0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected
                  ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                  : AppColors.taupe,
              size: 24.r,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (method.description?.isNotEmpty == true) ...[
                    SizedBox(height: 4.h),
                    Text(
                      method.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.taupe,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
