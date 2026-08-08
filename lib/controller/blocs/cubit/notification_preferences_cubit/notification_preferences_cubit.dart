import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/core/firebase_helper.dart';
import 'package:kalivra/model/notifications/notification_preference.dart';
import 'package:kalivra/model/services/api/notification_preferences_api_service.dart';

import 'notification_preferences_state.dart';

export 'notification_preferences_state.dart';

class NotificationPreferencesCubit extends Cubit<NotificationPreferencesState> {
  NotificationPreferencesCubit({NotificationPreferencesApiService? service})
    : _service = service ?? NotificationPreferencesApiService(),
      super(NotificationPreferencesState.initial()) {
    loadPreferences();
  }

  static const String _announcementTopic =
      NotificationPreference.announcementType;

  final NotificationPreferencesApiService _service;

  Future<void> loadPreferences() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      final preference = await _service.getAnnouncementPreference();
      emit(
        state.copyWith(
          preference: preference,
          isLoading: false,
          errorMessage: '',
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final previousPreference = state.preference;
    final nextPreference = previousPreference.copyWith(enabled: enabled);
    emit(
      state.copyWith(
        preference: nextPreference,
        isSaving: true,
        errorMessage: '',
      ),
    );

    try {
      await _applyFirebasePreference(enabled);
      await _service.updatePreference(nextPreference);
      emit(state.copyWith(isSaving: false, errorMessage: ''));
    } catch (error) {
      emit(
        state.copyWith(
          preference: previousPreference,
          isSaving: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> setChannels(List<String> channels) async {
    final previousPreference = state.preference;
    final nextPreference = previousPreference.copyWith(
      channels: channels.toSet().toList(growable: false),
    );
    emit(
      state.copyWith(
        preference: nextPreference,
        isSaving: true,
        errorMessage: '',
      ),
    );

    try {
      await _service.updatePreference(nextPreference);
      emit(state.copyWith(isSaving: false, errorMessage: ''));
    } catch (error) {
      emit(
        state.copyWith(
          preference: previousPreference,
          isSaving: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _applyFirebasePreference(bool enabled) async {
    if (enabled) {
      await FirebaseHelper.requestNotificationPermission();
      await FirebaseHelper.createFcmToken();
      await FirebaseHelper.subscribeToTopic(_announcementTopic);
    } else {
      await FirebaseHelper.unsubscribeFromTopic(_announcementTopic);
    }
  }
}
