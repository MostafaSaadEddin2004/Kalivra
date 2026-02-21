import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/models/language_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/selectable_card.dart';

/// Language selection (e.g. Arabic, English).
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const List<LanguageModel> _languages = [
    LanguageModel(
      title: 'العربية',
      subtitle: 'Arabic',
      languageCode: PrefKeys.arLocaleKey,
      index: 0,
    ),
    LanguageModel(
      title: 'English',
      subtitle: 'الإنجليزية',
      languageCode: PrefKeys.enLocaleKey,
      index: 1,
    ),
  ];

  static void _applyLanguageByCode(BuildContext context, String languageCode) {
    if (languageCode == PrefKeys.arLocaleKey) {
      context.read<LocaleBloc>().add(SetArabicLocale());
    } else {
      context.read<LocaleBloc>().add(SetEnglishLocale());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'اللغة'),
      body: BlocBuilder<LocaleBloc, LocaleBlocState>(
        builder: (context, state) {
          final currentLocale =
              state is LocaleFetched ? state.locale.languageCode : PrefKeys.arLocaleKey;
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: List.generate(_languages.length, (index) {
              final model = _languages[index];
              final isSelected = currentLocale == model.languageCode;
              return SelectableCard(
                label: model.title,
                subtitle: model.subtitle,
                icon: Icons.language_rounded,
                isSelected: isSelected,
                onTap: () => _applyLanguageByCode(context, model.languageCode),
              );
            }),
          );
        },
      ),
    );
  }
}
