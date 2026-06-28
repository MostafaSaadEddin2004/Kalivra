import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/app_info/contact_api_model.dart';
import 'package:kalivra/model/services/api/app_info_services.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/profile_page/screen_app_bar.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  late final Future<_ContactInfo> _contactInfoFuture;

  @override
  void initState() {
    super.initState();
    _contactInfoFuture = AppInfoServices().getContactInfo().then(
      (contact) => _ContactInfo.fromApiModel(contact),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.contactTitle),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Text(
            l10n.contactWelcome,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.offWhite : AppColors.burgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.contactChannels,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.taupe : AppColors.black,
            ),
          ),
          SizedBox(height: 24.h),
          FutureBuilder<_ContactInfo>(
            future: _contactInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _ContactLoadingCard();
              }

              final contactInfo = snapshot.data;
              if (contactInfo == null || contactInfo.isEmpty) {
                return const SizedBox.shrink();
              }

              return _ContactInfoSection(contactInfo: contactInfo);
            },
          ),
          SizedBox(height: 28.h),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizedText(
                      context,
                      arabic: 'كيف يمكننا مساعدتك؟',
                      english: 'How can we help?',
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.goldLight : AppColors.burgundy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: _subjectController,
                    label: l10n.subjectLabel,
                  ),
                  SizedBox(height: 12.h),
                  AppTextField(
                    controller: _messageController,
                    label: l10n.messageLabel,
                    maxLines: 4,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(l10n.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _ContactInfo {
  const _ContactInfo({
    required this.phones,
    required this.socialLinks,
    required this.workingHours,
    this.whatsapp,
    this.email,
    this.website,
    this.address,
  });

  final List<String> phones;
  final List<_SocialLink> socialLinks;
  final Map<String, String> workingHours;
  final String? whatsapp;
  final String? email;
  final String? website;
  final String? address;

  bool get isEmpty {
    return phones.isEmpty &&
        socialLinks.isEmpty &&
        workingHours.isEmpty &&
        _isBlank(whatsapp) &&
        _isBlank(email) &&
        _isBlank(website) &&
        _isBlank(address);
  }

  factory _ContactInfo.fromApiModel(ContactApiModel model) {
    final json = model.toJson();

    return _ContactInfo(
      phones: _stringList(json['phones']),
      whatsapp: _cleanString(model.whatsapp),
      email: _cleanString(model.email),
      website: _cleanString(json['website']),
      address: _cleanString(model.address),
      socialLinks: _socialLinks(json['social_media'] ?? json['social_links']),
      workingHours: _workingHours(json['working_hours']),
    );
  }
}

class _SocialLink {
  const _SocialLink({required this.label, required this.url});

  final String label;
  final String url;

  _SocialKind get kind => _socialKind('$label $url');
}

enum _SocialKind { facebook, instagram, threads, linkedin, other }

class _ContactInfoSection extends StatelessWidget {
  const _ContactInfoSection({required this.contactInfo});

  final _ContactInfo contactInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final children = <Widget>[];

    void addCard(Widget child) {
      if (children.isNotEmpty) children.add(SizedBox(height: 12.h));
      children.add(child);
    }

    if (contactInfo.phones.isNotEmpty) {
      addCard(
        _AccordionContactCard(
          icon: Icons.phone_rounded,
          title: l10n.contactPhoneTitle,
          collapsedSubtitle: _localizedText(
            context,
            arabic: '${contactInfo.phones.length} أرقام متاحة',
            english: '${contactInfo.phones.length} available numbers',
          ),
          children: [
            for (var i = 0; i < contactInfo.phones.length; i++)
              _ContactValueRow(
                icon: Icons.call_rounded,
                label: '${l10n.contactPhoneTitle} ${i + 1}',
                value: contactInfo.phones[i],
                onTap: () => _launchPhone(context, contactInfo.phones[i]),
              ),
          ],
        ),
      );
    }

    if (!_isBlank(contactInfo.email)) {
      addCard(
        _ContactCard(
          icon: Icons.email_rounded,
          title: l10n.contactEmailTitle,
          value: contactInfo.email!,
          onTap: () => _launchEmail(context, contactInfo.email!),
        ),
      );
    }

    if (!_isBlank(contactInfo.website)) {
      addCard(
        _ContactCard(
          icon: Icons.language_rounded,
          title: _localizedText(
            context,
            arabic: 'الموقع الإلكتروني',
            english: 'Website',
          ),
          value: contactInfo.website!,
          onTap: () => _launchWebLink(context, contactInfo.website!),
        ),
      );
    }

    if (!_isBlank(contactInfo.whatsapp)) {
      addCard(
        _ContactCard(
          icon: Icons.chat_rounded,
          title: _localizedText(context, arabic: 'واتساب', english: 'WhatsApp'),
          value: contactInfo.whatsapp!,
          onTap: () => _launchWhatsApp(context, contactInfo.whatsapp!),
        ),
      );
    }

    if (!_isBlank(contactInfo.address)) {
      addCard(
        _ContactCard(
          icon: Icons.location_on_rounded,
          title: _localizedText(context, arabic: 'العنوان', english: 'Address'),
          value: contactInfo.address!,
        ),
      );
    }

    if (contactInfo.socialLinks.isNotEmpty) {
      addCard(
        _AccordionContactCard(
          icon: Icons.groups_rounded,
          title: _localizedText(
            context,
            arabic: 'وسائل التواصل',
            english: 'Social media',
          ),
          collapsedSubtitle: _localizedText(
            context,
            arabic: '${contactInfo.socialLinks.length} روابط متاحة',
            english: '${contactInfo.socialLinks.length} available links',
          ),
          children: [
            for (final socialLink in contactInfo.socialLinks)
              _SocialValueRow(
                socialLink: socialLink,
                onTap: () => _launchWebLink(context, socialLink.url),
              ),
          ],
        ),
      );
    }

    if (contactInfo.workingHours.isNotEmpty) {
      addCard(
        _AccordionContactCard(
          icon: Icons.schedule_rounded,
          title: l10n.contactHoursTitle,
          collapsedSubtitle: _localizedText(
            context,
            arabic: '${contactInfo.workingHours.length} أيام',
            english: '${contactInfo.workingHours.length} days',
          ),
          children: [
            for (final entry in contactInfo.workingHours.entries)
              _ContactValueRow(
                icon: Icons.access_time_rounded,
                label: _dayLabel(context, entry.key),
                value: entry.value,
              ),
          ],
        ),
      );
    }

    return Column(children: children);
  }
}

class _ContactLoadingCard extends StatelessWidget {
  const _ContactLoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            SizedBox(
              width: 22.r,
              height: 22.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              _localizedText(
                context,
                arabic: 'جاري تحميل معلومات التواصل',
                english: 'Loading contact info',
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccordionContactCard extends StatefulWidget {
  const _AccordionContactCard({
    required this.icon,
    required this.title,
    required this.collapsedSubtitle,
    required this.children,
  });

  final IconData icon;
  final String title;
  final String collapsedSubtitle;
  final List<Widget> children;

  @override
  State<_AccordionContactCard> createState() => _AccordionContactCardState();
}

class _AccordionContactCardState extends State<_AccordionContactCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedCrossFade(
          firstChild: _AccordionCollapsedCard(
            icon: widget.icon,
            title: widget.title,
            subtitle: widget.collapsedSubtitle,
            primary: primary,
            isDark: isDark,
          ),
          secondChild: _AccordionExpandedCard(
            icon: widget.icon,
            title: widget.title,
            primary: primary,
            isDark: isDark,
            children: widget.children,
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
          firstCurve: Curves.decelerate,
          secondCurve: Curves.easeInOut,
          sizeCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}

class _AccordionCollapsedCard extends StatelessWidget {
  const _AccordionCollapsedCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color primary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: primary.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: primary),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.expand_more_rounded, size: 28.r, color: primary),
          ],
        ),
      ),
    );
  }
}

class _AccordionExpandedCard extends StatelessWidget {
  const _AccordionExpandedCard({
    required this.icon,
    required this.title,
    required this.primary,
    required this.isDark,
    required this.children,
  });

  final IconData icon;
  final String title;
  final Color primary;
  final bool isDark;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: primary.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 24.r, color: primary),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(Icons.expand_less_rounded, size: 28.r, color: primary),
              ],
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final child = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.burgundy.withValues(alpha: 0.3)
                    : AppColors.burgundy.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 28.r,
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: child,
    );
  }
}

class _ContactValueRow extends StatelessWidget {
  const _ContactValueRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _ContactValueRowBase(
      leading: Icon(icon, size: 22.r, color: _labelColor(context)),
      label: label,
      value: value,
      onTap: onTap,
    );
  }
}

class _SocialValueRow extends StatelessWidget {
  const _SocialValueRow({required this.socialLink, this.onTap});

  final _SocialLink socialLink;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _ContactValueRowBase(
      leading: _SocialIcon(kind: socialLink.kind),
      label: _socialLabel(context, socialLink),
      value: socialLink.url,
      onTap: onTap,
    );
  }
}

class _ContactValueRowBase extends StatelessWidget {
  const _ContactValueRowBase({
    required this.leading,
    required this.label,
    required this.value,
    this.onTap,
  });

  final Widget leading;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final child = Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24.r,
            child: Center(child: leading),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _labelColor(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: child,
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.kind});

  final _SocialKind kind;

  @override
  Widget build(BuildContext context) {
    final color = _labelColor(context);

    switch (kind) {
      case _SocialKind.facebook:
        return Icon(Icons.facebook_rounded, size: 22.r, color: color);
      case _SocialKind.instagram:
        return Icon(Icons.camera_alt_outlined, size: 22.r, color: color);
      case _SocialKind.threads:
        return Icon(Icons.alternate_email_rounded, size: 22.r, color: color);
      case _SocialKind.linkedin:
        return Text(
          'in',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        );
      case _SocialKind.other:
        return Icon(Icons.link_rounded, size: 22.r, color: color);
    }
  }
}

List<String> _stringList(dynamic value) {
  if (value is! List) return const [];

  return value
      .map((item) {
        if (item is Map) {
          return _cleanString(
            item['phone'] ?? item['number'] ?? item['value'] ?? item['title'],
          );
        }
        return _cleanString(item);
      })
      .whereType<String>()
      .where((item) => item.isNotEmpty)
      .toList();
}

List<_SocialLink> _socialLinks(dynamic value) {
  if (value is! List) return const [];

  return value
      .map((item) {
        if (item is Map) {
          final url = _cleanString(
            item['url'] ?? item['link'] ?? item['value'] ?? item['href'],
          );
          if (_isBlank(url)) return null;

          final label =
              _cleanString(
                item['type'] ??
                    item['platform'] ??
                    item['name'] ??
                    item['title'],
              ) ??
              _socialKind(url!).name;
          return _SocialLink(label: label, url: url!);
        }

        final url = _cleanString(item);
        if (_isBlank(url)) return null;
        return _SocialLink(label: _socialKind(url!).name, url: url);
      })
      .whereType<_SocialLink>()
      .toList();
}

Map<String, String> _workingHours(dynamic value) {
  if (value is Map) {
    return Map<String, String>.fromEntries(
      value.entries.map((entry) {
        final key = _cleanString(entry.key);
        final itemValue = _cleanString(entry.value);
        if (_isBlank(key) || _isBlank(itemValue)) return null;
        return MapEntry(key!, itemValue!);
      }).whereType<MapEntry<String, String>>(),
    );
  }

  final rawValue = _cleanString(value);
  if (_isBlank(rawValue)) return const {};

  final raw = rawValue!;
  if (!raw.startsWith('{') || !raw.endsWith('}')) {
    return <String, String>{'hours': raw};
  }

  final content = raw.substring(1, raw.length - 1).trim();
  if (content.isEmpty) return const {};

  return Map<String, String>.fromEntries(
    content.split(',').map((entry) {
      final separatorIndex = entry.indexOf(':');
      if (separatorIndex == -1) return null;

      final key = entry.substring(0, separatorIndex).trim();
      final itemValue = entry.substring(separatorIndex + 1).trim();
      if (key.isEmpty || itemValue.isEmpty) return null;

      return MapEntry(key, itemValue);
    }).whereType<MapEntry<String, String>>(),
  );
}

_SocialKind _socialKind(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('facebook') || normalized.contains('fb.')) {
    return _SocialKind.facebook;
  }
  if (normalized.contains('instagram')) return _SocialKind.instagram;
  if (normalized.contains('threads') || normalized.contains('thread')) {
    return _SocialKind.threads;
  }
  if (normalized.contains('linkedin') || normalized.contains('linked.in')) {
    return _SocialKind.linkedin;
  }
  return _SocialKind.other;
}

String _socialLabel(BuildContext context, _SocialLink socialLink) {
  switch (socialLink.kind) {
    case _SocialKind.facebook:
      return 'Facebook';
    case _SocialKind.instagram:
      return 'Instagram';
    case _SocialKind.threads:
      return 'Threads';
    case _SocialKind.linkedin:
      return 'LinkedIn';
    case _SocialKind.other:
      return socialLink.label;
  }
}

String _dayLabel(BuildContext context, String day) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final normalized = day.toLowerCase();

  if (!isArabic) return normalized.isEmpty ? day : _capitalize(normalized);

  return switch (normalized) {
    'sunday' => 'الأحد',
    'monday' => 'الإثنين',
    'tuesday' => 'الثلاثاء',
    'wednesday' => 'الأربعاء',
    'thursday' => 'الخميس',
    'friday' => 'الجمعة',
    'saturday' => 'السبت',
    _ => day,
  };
}

String _localizedText(
  BuildContext context, {
  required String arabic,
  required String english,
}) {
  return Localizations.localeOf(context).languageCode == 'ar'
      ? arabic
      : english;
}

String _capitalize(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

String? _cleanString(dynamic value) {
  final stringValue = value?.toString().trim();
  if (stringValue == null || stringValue.isEmpty || stringValue == 'null') {
    return null;
  }
  return stringValue;
}

bool _isBlank(dynamic value) => _cleanString(value) == null;

Color _labelColor(BuildContext context) {
  final theme = Theme.of(context);
  return theme.brightness == Brightness.dark
      ? AppColors.taupe
      : AppColors.burgundy;
}

Future<void> _launchPhone(BuildContext context, String phone) async {
  final normalizedPhone = phone.replaceAll(RegExp(r'\s+'), '');
  await _launchUri(context, Uri(scheme: 'tel', path: normalizedPhone));
}

Future<void> _launchEmail(BuildContext context, String email) async {
  await _launchUri(context, Uri(scheme: 'mailto', path: email));
}

Future<void> _launchWhatsApp(BuildContext context, String value) async {
  final trimmedValue = value.trim();
  final parsedValue = Uri.tryParse(trimmedValue);
  if (parsedValue != null && parsedValue.hasScheme) {
    await _launchUri(context, parsedValue);
    return;
  }

  if (trimmedValue.contains('wa.me') || trimmedValue.contains('whatsapp.com')) {
    final uri = _webUriOrNull(trimmedValue);
    if (uri == null) {
      _showLaunchError(context);
      return;
    }

    await _launchUri(context, uri);
    return;
  }

  final phone = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (phone.isEmpty) {
    _showLaunchError(context);
    return;
  }

  await _launchUri(context, Uri.parse('https://wa.me/$phone'));
}

Future<void> _launchWebLink(BuildContext context, String value) async {
  final uri = _webUriOrNull(value);
  if (uri == null) {
    _showLaunchError(context);
    return;
  }

  await _launchUri(context, uri);
}

Uri? _webUriOrNull(String value) {
  final trimmedValue = value.trim();
  if (trimmedValue.isEmpty) return null;

  final uri = Uri.tryParse(trimmedValue);
  if (uri != null && uri.hasScheme) return uri;

  return Uri.tryParse('https://$trimmedValue');
}

Future<void> _launchUri(BuildContext context, Uri uri) async {
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    _showLaunchError(context);
  }
}

void _showLaunchError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        _localizedText(
          context,
          arabic: 'تعذر فتح الرابط',
          english: 'Could not open this link',
        ),
      ),
    ),
  );
}
