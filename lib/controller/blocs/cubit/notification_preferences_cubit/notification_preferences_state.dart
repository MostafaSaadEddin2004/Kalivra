import 'package:kalivra/model/notifications/notification_preference.dart';

class NotificationPreferencesState {
  const NotificationPreferencesState({
    required this.preference,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage = '',
  });

  factory NotificationPreferencesState.initial() {
    return NotificationPreferencesState(
      preference: NotificationPreference.announcementDefault(),
    );
  }

  final NotificationPreference preference;
  final bool isLoading;
  final bool isSaving;
  final String errorMessage;

  bool get isEnabled => preference.enabled;
  List<String> get channels => preference.channels;

  NotificationPreferencesState copyWith({
    NotificationPreference? preference,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
  }) {
    return NotificationPreferencesState(
      preference: preference ?? this.preference,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
