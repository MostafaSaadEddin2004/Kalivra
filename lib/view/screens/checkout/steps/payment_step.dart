import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';

enum PaymentType { cashOnDelivery, ePayment }

enum EPaymentMethod { shamcash, syriatelCash, mtnCash }

class PaymentStep extends StatefulWidget {
  const PaymentStep({super.key});

  @override
  State<PaymentStep> createState() => PaymentStepState();
}

class PaymentStepState extends State<PaymentStep> {
  PaymentType _paymentType = PaymentType.cashOnDelivery;
  EPaymentMethod _ePaymentMethod = EPaymentMethod.shamcash;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool validateStep() {
    if (_paymentType == PaymentType.cashOnDelivery) return true;
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.offWhite : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;

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
          _buildPaymentTypeOption(
            context: context,
            type: PaymentType.cashOnDelivery,
            title: l10n.cashOnDelivery,
            subtitle: l10n.cashOnDeliverySubtitle,
            icon: Icons.money_off_csred_rounded,
            textColor: textColor,
            isDark: isDark,
          ),
          SizedBox(height: 12.h),
          _buildPaymentTypeOption(
            context: context,
            type: PaymentType.ePayment,
            title: l10n.onlinePayment,
            subtitle: l10n.onlinePaymentSubtitle,
            icon: Icons.phone_android_rounded,
            textColor: textColor,
            isDark: isDark,
          ),
          if (_paymentType == PaymentType.ePayment) ...[
            SizedBox(height: 24.h),
            Text(
              l10n.selectPaymentMethod,
              style: theme.textTheme.titleMedium?.copyWith(color: textColor),
            ),
            SizedBox(height: 12.h),
            ...EPaymentMethod.values.map((method) => _buildEMethodOption(
                  context: context,
                  method: method,
                  textColor: textColor,
                  isDark: isDark,
                )),
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

  Widget _buildPaymentTypeOption({
    required BuildContext context,
    required PaymentType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color textColor,
    required bool isDark,
  }) {
    final selected = _paymentType == type;
    return InkWell(
      onTap: () => setState(() => _paymentType = type),
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
              icon,
              size: 28.r,
              color: selected
                  ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                  : AppColors.taupe,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.taupe,
                        ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                size: 24.r,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEMethodOption({
    required BuildContext context,
    required EPaymentMethod method,
    required Color textColor,
    required bool isDark,
  }) {
    final selected = _ePaymentMethod == method;
    final l10n = AppLocalizations.of(context)!;
    final name = switch (method) {
      EPaymentMethod.shamcash => l10n.paymentShamcash,
      EPaymentMethod.syriatelCash => l10n.paymentSyriatel,
      EPaymentMethod.mtnCash => l10n.paymentMtn,
    };
    final desc = switch (method) {
      EPaymentMethod.shamcash => l10n.paymentShamcashDesc,
      EPaymentMethod.syriatelCash => l10n.paymentSyriatelDesc,
      EPaymentMethod.mtnCash => l10n.paymentMtnDesc,
    };
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: () => setState(() => _ePaymentMethod = method),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF252423)
                : AppColors.offWhite.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected
                  ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                  : AppColors.taupe.withValues(alpha: 0.25),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected
                    ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                    : AppColors.taupe,
                size: 24.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: textColor,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      desc,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.taupe,
                            fontSize: 11.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}