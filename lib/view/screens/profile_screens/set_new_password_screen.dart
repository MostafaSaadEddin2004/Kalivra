import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key, required this.whatsappNumber});

  final String whatsappNumber;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);
    try {
      await context.read<AuthCubit>().changePasswordByWhatsapp(
        context: context,
        whatsappNumber: widget.whatsappNumber,
        password: _newController.text,
        passwordConfirmation: _confirmController.text,
      );
      if (!mounted) return;
      CustomSnackBar.show(context, l10n.passwordUpdatedSuccess);
      context.go(AppRoutes.login);
    } catch (_) {
      // Error snackbar is shown by AuthCubit.
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    final l10n = AppLocalizations.of(context)!;
    return PopScopeExitApp(
      child: Scaffold(
        appBar: ScreenAppBar(title: l10n.setNewPasswordTitle),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
            children: [
              _StepIndicator(step: 3, total: 3),
              SizedBox(height: 24.h),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.setNewPasswordBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.taupe : AppColors.burgundy,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        controller: _newController,
                        label: l10n.newPassword,
                        hint: '********',
                        obscureText: _obscureNew,
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          size: 22.r,
                          color: labelColor,
                        ),
                        suffixIcon: CustomIconButton(
                          icon: _obscureNew
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          iconSize: 22.r,
                          color: labelColor,
                          onPressed: () =>
                              setState(() => _obscureNew = !_obscureNew),
                        ),
                        borderRadius: 12.r,
                        validator: (v) {
                          if (v == null || v.length < 6) {
                            return l10n.passwordMinLength;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        controller: _confirmController,
                        label: l10n.newPasswordConfirm,
                        hint: '********',
                        obscureText: _obscureConfirm,
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          size: 22.r,
                          color: labelColor,
                        ),
                        suffixIcon: CustomIconButton(
                          icon: _obscureConfirm
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          iconSize: 22.r,
                          color: labelColor,
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                        borderRadius: 12.r,
                        validator: (v) {
                          if (v != _newController.text) {
                            return l10n.confirmPasswordMismatch;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              FilledButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.offWhite,
                        ),
                      )
                    : Icon(Icons.check_rounded, size: 22.r),
                label: Text(
                  l10n.updatePasswordButton,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Row(
      children: List.generate(total * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: i ~/ 2 < step
                  ? activeColor
                  : activeColor.withValues(alpha: 0.3),
            ),
          );
        }
        final s = i ~/ 2 + 1;
        final isActive = s <= step;
        return Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : activeColor.withValues(alpha: 0.3),
          ),
          child: Center(
            child: isActive
                ? Icon(
                    Icons.check_rounded,
                    size: 16.r,
                    color: AppColors.offWhite,
                  )
                : Text(
                    '$s',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
