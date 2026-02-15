import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

/// Payment type: cash on delivery or e-payment (Shamcash, Syriatel Cash, MTN Cash).
enum PaymentType { cashOnDelivery, ePayment }

/// e-Payment method options in Syria.
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

  /// Called by parent to validate before allowing proceed to next step.
  bool validateStep() {
    if (_paymentType == PaymentType.cashOnDelivery) return true;
    return _formKey.currentState?.validate() ?? false;
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String label,
    required String hint,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = AppColors.offWhite.withValues(alpha: isDark ? 0.6 : 0.8);
    final fillColor = isDark
        ? const Color(0xFF1A1918)
        : AppColors.offWhite.withValues(alpha: 0.5);
    final labelColor = isDark ? AppColors.offWhite : AppColors.burgundy;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.offWhite, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      labelStyle: TextStyle(color: labelColor),
      hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.6)),
    );
  }

  static const _methodNames = {
    EPaymentMethod.shamcash: 'شام كاش',
    EPaymentMethod.syriatelCash: 'سيرياتيل كاش',
    EPaymentMethod.mtnCash: 'إم تي إن كاش',
  };

  static const _methodDescriptions = {
    EPaymentMethod.shamcash: 'محفظة إلكترونية سورية للتحويل والدفع عبر التطبيق',
    EPaymentMethod.syriatelCash: 'منصة الدفع الإلكتروني من سيرياتيل للتحويل والدفع',
    EPaymentMethod.mtnCash: 'خدمة المحفظة المالية من إم تي إن سوريا',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.offWhite : AppColors.burgundy;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'طريقة الدفع',
            style: theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          _buildPaymentTypeOption(
            context: context,
            type: PaymentType.cashOnDelivery,
            title: 'الدفع عند الاستلام',
            subtitle: 'ادفع نقداً عند استلام الطلب',
            icon: Icons.money_off_csred_rounded,
            textColor: textColor,
            isDark: isDark,
          ),
          SizedBox(height: 12.h),
          _buildPaymentTypeOption(
            context: context,
            type: PaymentType.ePayment,
            title: 'الدفع الإلكتروني',
            subtitle: 'شام كاش، سيرياتيل كاش، إم تي إن كاش',
            icon: Icons.phone_android_rounded,
            textColor: textColor,
            isDark: isDark,
          ),
          if (_paymentType == PaymentType.ePayment) ...[
            SizedBox(height: 24.h),
            Text(
              'اختر طريقة الدفع الإلكتروني',
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
              'بيانات المحفظة',
              style: theme.textTheme.titleMedium?.copyWith(color: textColor),
            ),
            SizedBox(height: 12.h),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'مطلوب';
                      if (v.trim().length < 8) return 'رقم هاتف غير صالح';
                      return null;
                    },
                    decoration: _inputDecoration(
                      context,
                      label: 'رقم الهاتف المرتبط بالمحفظة*',
                      hint: '09XXXXXXXX',
                    ),
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration(
                      context,
                      label: 'الاسم كما في المحفظة (اختياري)',
                      hint: 'للتحقق من صحة الدفع',
                    ),
                    style: TextStyle(color: textColor),
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
                      _methodNames[method]!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: textColor,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _methodDescriptions[method]!,
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
