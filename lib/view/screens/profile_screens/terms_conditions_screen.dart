import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/app_info_cubit/app_info_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/html_utils.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../widgets/profile_page/screen_app_bar.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  late final AppInfoCubit _appInfoCubit;

  @override
  void initState() {
    super.initState();
    _appInfoCubit = AppInfoCubit()..getTermsConditionsInfo();
  }

  @override
  void dispose() {
    _appInfoCubit.close();
    super.dispose();
  }

  Future<void> _refreshTermsConditions() {
    return _appInfoCubit.getTermsConditionsInfo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.drawerTermsConditions),
      body: AppRefreshIndicator(
        onRefresh: _refreshTermsConditions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20.w),
          child: BlocBuilder<AppInfoCubit, AppInfoState>(
            bloc: _appInfoCubit,
            builder: (context, state) {
              switch (state) {
                case AppTermsConditionsFetched():
                  final data = state.termaConditionsData;
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
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.62,
                    child: EmptyStateView(
                      icon: Icons.quiz_outlined,
                      title: l10n.unexpectedError,
                      description: state.errorMessage,
                      actionLabel: l10n.retry,
                      onAction: _refreshTermsConditions,
                    ),
                  );
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
        ),
      ),
    );
  }
}
