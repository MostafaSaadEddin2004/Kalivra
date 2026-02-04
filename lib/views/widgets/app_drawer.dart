import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  /// Whether user is logged in; toggles "تسجيل دخول" / "تسجيل خروج".
  static bool get isLoggedIn => false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(onClose: () => Navigator.pop(context)),
            const Divider(height: 1, color: AppColors.lightGray),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: 'حسابي',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'طلباتي',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'المفضلة',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'الإعدادات',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.phone_outlined,
                    label: 'تواصل معنا',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'حول التطبيق',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'سياسة الخصوصية',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.star_rounded,
                    label: 'تقييم',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
                    label: isLoggedIn ? 'تسجيل خروج' : 'تسجيل دخول',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.lightGray),
            const _DrawerFooter(),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'القائمة :',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.black),
            onPressed: onClose,
            tooltip: 'إغلاق',
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(icon, color: AppColors.burgundy, size: 24),
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_left_rounded,
                  size: 22,
                  color: AppColors.black.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.lightGray),
      ],
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: Container(
              width: 40,
              height: 40,
              color: AppColors.offWhite,
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                'assets/images/logo_small.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.store_rounded, size: 24, color: AppColors.burgundy),
              ),
            ),
          ),
          Text(
            'الإصدار 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.burgundy,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
