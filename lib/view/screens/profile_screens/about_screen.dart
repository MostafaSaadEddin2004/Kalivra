import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/app_info_cubit/app_info_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/html_utils.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../widgets/profile_page/screen_app_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final AppInfoCubit _appInfoCubit;

  @override
  void initState() {
    super.initState();
    _appInfoCubit = AppInfoCubit()..getAboutInfo();
  }

  @override
  void dispose() {
    _appInfoCubit.close();
    super.dispose();
  }

  Future<void> _refreshAboutInfo() {
    return _appInfoCubit.getAboutInfo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.drawerAboutApp),
      body: AppRefreshIndicator(
        onRefresh: _refreshAboutInfo,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.burgundy.withValues(alpha: 0.25)
                      : AppColors.burgundy.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.store_rounded,
                  size: 64.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Kalivra',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.burgundy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.version,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.black,
                ),
              ),
              SizedBox(height: 24.h),
              BlocBuilder<AppInfoCubit, AppInfoState>(
                bloc: _appInfoCubit,
                builder: (context, state) {
                  switch (state) {
                    case AppAboutFetched():
                      final data = state.aboutData;
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.w,
                          ),
                          child: Column(
                            spacing: 16.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                htmlToPlainText(data.title!),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: isDark
                                      ? AppColors.offWhite
                                      : AppColors.black,
                                ),
                              ),
                              Text(
                                htmlToPlainText(data.content!),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isDark
                                      ? AppColors.offWhite
                                      : AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    case AppInfoFailure():
                      return Center(child: Text(state.errorMessage));
                    case AppInfoLoading():
                      return Skeletonizer(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Text(
                              l10n.privacyPolicyContent,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isDark
                                    ? AppColors.offWhite
                                    : AppColors.black,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      );
                    default:
                      return Center(child: Text(l10n.nothingToShow));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
