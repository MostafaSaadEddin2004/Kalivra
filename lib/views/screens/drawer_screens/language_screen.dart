import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Language selection with radio list (Arabic / English).
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'اللغة'),
      body: BlocBuilder<LocaleBloc, LocaleBlocState>(
        builder: (context, state) {
          final currentLocale = state is LocaleFetched ? state.locale.languageCode : PrefKeys.arLocaleKey;
          return ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              _LanguageRadioTile(
                value: PrefKeys.arLocaleKey,
                label: 'العربية',
                subtitle: 'Arabic',
                groupValue: currentLocale,
                onChanged: () => context.read<LocaleBloc>().add(SetArabicLocale()),
              ),
              SizedBox(height: 12.h),
              _LanguageRadioTile(
                value: PrefKeys.enLocaleKey,
                label: 'English',
                subtitle: 'الإنجليزية',
                groupValue: currentLocale,
                onChanged: () => context.read<LocaleBloc>().add(SetEnglishLocale()),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LanguageRadioTile extends StatelessWidget {
  const _LanguageRadioTile({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.groupValue,
    required this.onChanged,
  });

  final String value;
  final String label;
  final String subtitle;
  final String groupValue;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = groupValue == value;
    final accentColor = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: isSelected
            ? BorderSide(color: accentColor, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onChanged,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                activeColor: accentColor,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return accentColor;
                  return isDark ? AppColors.taupe : AppColors.burgundy.withValues(alpha: 0.5);
                }),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: accentColor,
                  size: 24.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
