import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/controller/blocs/cubit/notification_preferences_cubit/notification_preferences_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/model/notifications/notification_preference.dart';
import 'package:kalivra/view/screens/profile_screens/notification_preferences_text.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationPreferencesCubit(),
      child: const _NotificationPreferencesView(),
    );
  }
}

class _NotificationPreferencesView extends StatefulWidget {
  const _NotificationPreferencesView();

  @override
  State<_NotificationPreferencesView> createState() =>
      _NotificationPreferencesViewState();
}

class _NotificationPreferencesViewState
    extends State<_NotificationPreferencesView> {
  List<String> _selectedChannels = NotificationPreference.availableChannels;
  bool _syncedInitialChannels = false;

  @override
  Widget build(BuildContext context) {
    final copy = NotificationPreferencesText.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<
      NotificationPreferencesCubit,
      NotificationPreferencesState
    >(
      listener: (context, state) {
        if (!_syncedInitialChannels && !state.isLoading) {
          _selectedChannels = List<String>.of(state.channels);
          _syncedInitialChannels = true;
        }
        if (state.errorMessage.isNotEmpty) {
          CustomSnackBar.show(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ScreenAppBar(title: copy.screenTitle),
          body: state.isLoading
              ? Center(
                  child: SpinKitFadingCircle(
                    size: 42.r,
                    color: theme.colorScheme.primary,
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
                    Text(
                      copy.screenDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primaryFixed.withValues(
                          alpha: 0.72,
                        ),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ...NotificationPreference.availableChannels.map(
                      (channel) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _NotificationChannelTile(
                          title: copy.channelTitle(channel),
                          description: copy.channelDescription(channel),
                          icon: _channelIcon(channel),
                          selected: _selectedChannels.contains(channel),
                          onChanged: state.isSaving
                              ? null
                              : (selected) => _toggleChannel(
                                  channel: channel,
                                  selected: selected,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: FilledButton(
              onPressed: state.isSaving
                  ? null
                  : () => _saveChannels(context, copy),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimaryFixed,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: state.isSaving
                  ? SpinKitFadingCircle(
                      size: 20.r,
                      color: theme.colorScheme.onPrimaryFixed,
                    )
                  : Text(
                      copy.save,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryFixed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _toggleChannel({required String channel, required bool selected}) {
    setState(() {
      if (selected) {
        _selectedChannels = {..._selectedChannels, channel}.toList();
      } else {
        _selectedChannels = _selectedChannels
            .where((item) => item != channel)
            .toList(growable: false);
      }
    });
  }

  Future<void> _saveChannels(
    BuildContext context,
    NotificationPreferencesText copy,
  ) async {
    await context.read<NotificationPreferencesCubit>().setChannels(
      _selectedChannels,
    );
    if (!context.mounted) return;
    final state = context.read<NotificationPreferencesCubit>().state;
    if (state.errorMessage.isEmpty) {
      CustomSnackBar.show(context, copy.saved);
    }
  }

  IconData _channelIcon(String channel) {
    switch (channel) {
      case NotificationPreference.whatsappChannel:
        return Icons.chat_rounded;
      case NotificationPreference.inAppChannel:
      default:
        return Icons.notifications_active_outlined;
    }
  }
}

class _NotificationChannelTile extends StatelessWidget {
  const _NotificationChannelTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(!selected),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryFixed,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 22.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primaryFixed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Checkbox(
                value: selected,
                activeColor: theme.colorScheme.primary,
                checkColor: AppColors.offWhite,
                onChanged: onChanged == null
                    ? null
                    : (value) => onChanged!(value ?? false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
