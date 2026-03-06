import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

/// Full-screen list of all brands. Tap a brand to open brand details.
class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.brandsSection),
      // body: brands.isEmpty
      //     ? Center(
      //         child: Text(
      //           l10n.noBrands,
      //           style: theme.textTheme.bodyLarge?.copyWith(
      //             color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      //           ),
      //         ),
      //       )
      //     : SingleChildScrollView(
      //         padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      //         child: Wrap(
      //           spacing: 12.w,
      //           runSpacing: 12.h,
      //           children: [
      //             for (final brand in brands)
      //               SizedBox(
      //                 width: 90.w,
      //                 height: 120.h,
      //                 child: BrandCard(
      //                   brand: brand,
      //                   onTap: () =>
      //                       context.push(AppRoutes.brandDetails, extra: brand),
      //                 ),
      //               ),
      //           ],
      //         ),
      //       ),
    );
  }
}
