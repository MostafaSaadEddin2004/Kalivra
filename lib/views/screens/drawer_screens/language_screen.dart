import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/models/language_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/selectable_card.dart';

/// Language selection (e.g. Arabic, English).
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static List<LanguageModel> _languages(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      LanguageModel(
        title: l10n.languageFollowSystem,
        subtitle: l10n.languageFollowSystemSubtitle,
        languageCode: PrefKeys.systemLocaleKey,
        index: 0,
        icon: Icons.settings_suggest_rounded,
      ),
      LanguageModel(
        title: l10n.languageArabic,
        subtitle: l10n.languageArabicSubtitle,
        languageCode: PrefKeys.arLocaleKey,
        index: 1,
        icon: Icons.menu_book_rounded,
      ),
      LanguageModel(
        title: l10n.languageEnglish,
        subtitle: l10n.languageEnglishSubtitle,
        languageCode: PrefKeys.enLocaleKey,
        index: 2,
        icon: Icons.language_rounded,
      ),
    ];
  }

  static void _applyLanguageByCode(BuildContext context, String languageCode) {
    if (languageCode == PrefKeys.systemLocaleKey) {
      context.read<LocaleBloc>().add(SetSystemLocale());
    } else if (languageCode == PrefKeys.arLocaleKey) {
      context.read<LocaleBloc>().add(SetArabicLocale());
    } else {
      context.read<LocaleBloc>().add(SetEnglishLocale());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DrawerScreenAppBar(title: AppLocalizations.of(context)!.languageTitle),
      body: BlocBuilder<LocaleBloc, LocaleBlocState>(
        builder: (context, state) {
          final useSystem = state is LocaleFetched && state.useSystemLocale;
          final currentLocale =
              state is LocaleFetched ? state.locale.languageCode : PrefKeys.arLocaleKey;
          final languages = _languages(context);
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: List.generate(languages.length, (index) {
              final model = languages[index];
              final isSelected = model.languageCode == PrefKeys.systemLocaleKey
                  ? useSystem
                  : !useSystem && currentLocale == model.languageCode;
              return SelectableCard(
                label: model.title,
                subtitle: model.subtitle,
                icon: model.icon,
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
