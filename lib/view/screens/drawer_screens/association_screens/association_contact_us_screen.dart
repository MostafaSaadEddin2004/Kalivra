import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationContactUsScreen extends StatefulWidget {
  const AssociationContactUsScreen({super.key});

  @override
  State<AssociationContactUsScreen> createState() =>
      _AssociationContactUsScreenState();
}

class _AssociationContactUsScreenState
    extends State<AssociationContactUsScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    _messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.associationContactUs),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 108.h),
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.burgundy,
                      isDark ? AppColors.burgundy : AppColors.goldDark,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.burgundy.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26.r,
                      backgroundColor: Colors.white.withValues(alpha: 0.16),
                      child: Icon(
                        Icons.support_agent_rounded,
                        color: AppColors.offWhite,
                        size: 28.r,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        l10n.associationContactUs,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.offWhite,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: l10n.associationChatMessageHint,
                          filled: true,
                          fillColor: isDark
                              ? AppColors.burgundy.withValues(alpha: 0.1)
                              : AppColors.offWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    IconButton.filled(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send_rounded),
                      tooltip: l10n.send,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.burgundy,
                        foregroundColor: AppColors.offWhite,
                        minimumSize: Size(48.w, 48.h),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
