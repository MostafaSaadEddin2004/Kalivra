import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class ShowAllButton extends StatelessWidget {
  const ShowAllButton({
    super.key,
    required this.onShowAllTap,
    required this.l10n,
    required this.textTheme,
    required this.colorScheme,
  });

  final VoidCallback? onShowAllTap;
  final AppLocalizations l10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onShowAllTap,
      child: Text(
        l10n.showAll,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onTertiaryFixed,
          decoration: TextDecoration.underline,decorationColor: colorScheme.onTertiaryFixed
        ),
      ),
    );
  }
}
