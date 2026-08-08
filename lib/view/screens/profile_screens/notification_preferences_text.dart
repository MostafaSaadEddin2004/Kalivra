import 'package:flutter/widgets.dart';
import 'package:kalivra/model/notifications/notification_preference.dart';

class NotificationPreferencesText {
  const NotificationPreferencesText._({
    required this.sectionTitle,
    required this.switchTitle,
    required this.enabledSubtitle,
    required this.disabledSubtitle,
    required this.channelsTitle,
    required this.channelsSubtitle,
    required this.screenTitle,
    required this.screenDescription,
    required this.inAppTitle,
    required this.inAppDescription,
    required this.whatsappTitle,
    required this.whatsappDescription,
    required this.save,
    required this.saved,
    required this.loadFailed,
  });

  final String sectionTitle;
  final String switchTitle;
  final String enabledSubtitle;
  final String disabledSubtitle;
  final String channelsTitle;
  final String channelsSubtitle;
  final String screenTitle;
  final String screenDescription;
  final String inAppTitle;
  final String inAppDescription;
  final String whatsappTitle;
  final String whatsappDescription;
  final String save;
  final String saved;
  final String loadFailed;

  static NotificationPreferencesText of(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return const NotificationPreferencesText._(
        sectionTitle: 'الإشعارات',
        switchTitle: 'تفعيل الإشعارات',
        enabledSubtitle: 'الإشعارات مفعلة على هذا الجهاز',
        disabledSubtitle: 'الإشعارات متوقفة على هذا الجهاز',
        channelsTitle: 'أماكن وصول الإشعارات',
        channelsSubtitle: 'اختر القنوات التي تريد استقبال الإشعارات منها',
        screenTitle: 'أماكن وصول الإشعارات',
        screenDescription: 'حدد أين تريد استقبال إشعارات الإعلانات.',
        inAppTitle: 'داخل التطبيق',
        inAppDescription: 'تظهر الإشعارات في مركز إشعارات Kalivra.',
        whatsappTitle: 'واتساب',
        whatsappDescription: 'استقبل تنبيهات الإعلانات عبر واتساب.',
        save: 'حفظ',
        saved: 'تم حفظ إعدادات الإشعارات',
        loadFailed: 'تعذر تحميل إعدادات الإشعارات',
      );
    }

    return const NotificationPreferencesText._(
      sectionTitle: 'Notifications',
      switchTitle: 'Enable notifications',
      enabledSubtitle: 'Notifications are enabled on this device',
      disabledSubtitle: 'Notifications are disabled on this device',
      channelsTitle: 'Notification channels',
      channelsSubtitle: 'Choose where you want to receive notifications',
      screenTitle: 'Notification channels',
      screenDescription: 'Choose where announcement notifications arrive.',
      inAppTitle: 'In-app',
      inAppDescription:
          'Show notifications in the Kalivra notification center.',
      whatsappTitle: 'WhatsApp',
      whatsappDescription: 'Receive announcement alerts on WhatsApp.',
      save: 'Save',
      saved: 'Notification settings saved',
      loadFailed: 'Could not load notification settings',
    );
  }

  String channelTitle(String channel) {
    switch (channel) {
      case NotificationPreference.whatsappChannel:
        return whatsappTitle;
      case NotificationPreference.inAppChannel:
      default:
        return inAppTitle;
    }
  }

  String channelDescription(String channel) {
    switch (channel) {
      case NotificationPreference.whatsappChannel:
        return whatsappDescription;
      case NotificationPreference.inAppChannel:
      default:
        return inAppDescription;
    }
  }
}
