import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

/// Search tab: body only (app bar is the search bar from MainShell).
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'اقتراحات سريعة',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.burgundy,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildListDelegate([
              _SearchChip(label: 'دهانات'),
              _SearchChip(label: 'سيراميك'),
              _SearchChip(label: 'أدوات صحية'),
              _SearchChip(label: 'حديد'),
              _SearchChip(label: 'كهربائيات'),
              _SearchChip(label: 'ديكور'),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'آخر البحث',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.burgundy,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Text(
              'لم تبحث عن شيء بعد. اكتب في شريط البحث أعلاه.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.black.withValues(alpha: 0.6),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchChip extends StatelessWidget {
  const _SearchChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.burgundy,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
