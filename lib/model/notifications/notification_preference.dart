class NotificationPreference {
  const NotificationPreference({
    required this.notificationType,
    required this.enabled,
    required this.channels,
  });

  static const String announcementType = 'announcement';
  static const String inAppChannel = 'in_app';
  static const String pushChannel = 'push';
  static const String emailChannel = 'email';
  static const String whatsappChannel = 'whatsapp';
  static const List<String> availableChannels = [
    inAppChannel,
    pushChannel,
    emailChannel,
    whatsappChannel,
  ];

  final String notificationType;
  final bool enabled;
  final List<String> channels;

  factory NotificationPreference.announcementDefault() {
    return const NotificationPreference(
      notificationType: announcementType,
      enabled: true,
      channels: [inAppChannel],
    );
  }

  factory NotificationPreference.fromJson(Map<dynamic, dynamic> json) {
    final notificationType =
        json['notification_type']?.toString().trim().isNotEmpty == true
        ? json['notification_type'].toString().trim()
        : announcementType;

    return NotificationPreference(
      notificationType: notificationType,
      enabled: _parseBool(json['enabled'], fallback: true),
      channels: _parseChannels(json['channels'] ?? json['channel']),
    );
  }

  NotificationPreference copyWith({bool? enabled, List<String>? channels}) {
    return NotificationPreference(
      notificationType: notificationType,
      enabled: enabled ?? this.enabled,
      channels: channels ?? this.channels,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_type': notificationType,
      'enabled': enabled,
      'channels': channels,
    };
  }

  static List<String> _parseChannels(Object? value) {
    final channels = <String>{};
    if (value is Iterable) {
      for (final item in value) {
        _addChannel(channels, item);
      }
    } else if (value is String) {
      for (final item in value.split(',')) {
        _addChannel(channels, item);
      }
    } else {
      _addChannel(channels, value);
    }

    return channels.isEmpty ? [inAppChannel] : channels.toList(growable: false);
  }

  static void _addChannel(Set<String> channels, Object? value) {
    final normalized = value
        ?.toString()
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    if (availableChannels.contains(normalized)) {
      channels.add(normalized!);
    }
  }

  static bool _parseBool(Object? value, {required bool fallback}) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    switch (value?.toString().trim().toLowerCase()) {
      case 'true':
      case 'yes':
      case '1':
      case 'enabled':
        return true;
      case 'false':
      case 'no':
      case '0':
      case 'disabled':
        return false;
      default:
        return fallback;
    }
  }
}
