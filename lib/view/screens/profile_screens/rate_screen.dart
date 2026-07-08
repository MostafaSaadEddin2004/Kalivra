import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/app_info_cubit/app_info_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/login_required_placeholder.dart';
import '../../widgets/profile_page/screen_app_bar.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final _commentController = TextEditingController();
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    context.read<AppInfoCubit>().checkRatingLoginStatus();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedRating == 0) {
      CustomSnackBar.show(context, l10n.selectRating);
      return;
    }

    context.read<AppInfoCubit>().postAppRating(
      rating: _selectedRating,
      comment: _commentController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.rateTitle),
      body: BlocConsumer<AppInfoCubit, AppInfoState>(
        listener: (context, state) {
          if (state is AppRatingSubmitted) {
            CustomSnackBar.show(context, l10n.thanksForRating);
          } else if (state is AppInfoFailure) {
            CustomSnackBar.show(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is AppRatingLoginRequired) {
            return LoginRequiredPlaceholder(
              icon: Icons.star_border_rounded,
              title: l10n.loginRequiredForRating,
              description: l10n.ratingLoginPrompt,
              onLoginTap: () => context.push(AppRoutes.login),
            );
          }

          if (state is AppRatingAuthChecking) {
            return Center(
              child: SpinKitFadingCircle(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                size: 32.r,
              ),
            );
          }

          final isSubmitting = state is AppRatingSubmitting;

          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 80.r,
                      color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      l10n.rateQuestion,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.burgundy,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final rating = i + 1;
                        final isSelected = rating <= _selectedRating;

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: CustomIconButton(
                            icon: isSelected
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            iconSize: 40.r,
                            color: isSelected
                                ? (isDark
                                      ? AppColors.goldLight
                                      : AppColors.burgundy)
                                : (isDark
                                      ? AppColors.taupe
                                      : AppColors.burgundy.withValues(
                                          alpha: 0.4,
                                        )),
                            onPressed: isSubmitting
                                ? null
                                : () =>
                                      setState(() => _selectedRating = rating),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24.h),
                    AppTextField(
                      controller: _commentController,
                      label: l10n.ratingComment,
                      hint: l10n.ratingCommentHint,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                    ),
                    SizedBox(height: 32.h),
                    FilledButton(
                      onPressed: isSubmitting
                          ? null
                          : () => _submitRating(context),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 16.h,
                        ),
                        minimumSize: Size(double.infinity, 52.h),
                      ),
                      child: isSubmitting
                          ? SpinKitFadingCircle(
                              color: AppColors.offWhite,
                              size: 20.r,
                            )
                          : Text(l10n.submitRating),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
