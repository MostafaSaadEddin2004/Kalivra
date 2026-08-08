import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/controller/blocs/cubit/chat_cubit/chat_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationChatScreen extends StatefulWidget {
  const AssociationChatScreen({super.key});

  @override
  State<AssociationChatScreen> createState() => _AssociationChatScreenState();
}

class _AssociationChatScreenState extends State<AssociationChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _chatCubit = ChatCubit();

  Timer? _waitingTimer;
  int _waitingMessageCount = 0;

  @override
  void dispose() {
    _waitingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _chatCubit.close();
    super.dispose();
  }

  void _sendMessage({String? retryText}) {
    final text = (retryText ?? _messageController.text).trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    if (retryText == null) {
      _messageController.clear();
    }
    _chatCubit.sendMessage(appendUserMessage: retryText == null, message: text);
  }

  void _startNewChat() {
    Navigator.of(context).pop();
    FocusScope.of(context).unfocus();
    _messageController.clear();
    _stopWaitingMessages();
    _chatCubit.startNewChat();
  }

  void _openChat(int chatSessionId) {
    Navigator.of(context).pop();
    FocusScope.of(context).unfocus();
    _messageController.clear();
    _stopWaitingMessages();
    _chatCubit.getChatById(sessionId: chatSessionId);
  }

  void _startWaitingMessages() {
    _waitingTimer?.cancel();
    setState(() => _waitingMessageCount = 1);
    _waitingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted) return;
      if (_waitingMessageCount >= _waitingMessageIcons.length) {
        timer.cancel();
        return;
      }
      setState(() => _waitingMessageCount += 1);
      _scrollToBottom();
    });
  }

  void _stopWaitingMessages() {
    _waitingTimer?.cancel();
    _waitingTimer = null;
    if (mounted && _waitingMessageCount != 0) {
      setState(() => _waitingMessageCount = 0);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _chatCubit,
      child: BlocConsumer<ChatCubit, ChatState>(
        listenWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType ||
            previous.messages.length != current.messages.length,
        listener: (context, state) {
          if (state.isSending && _waitingMessageCount == 0) {
            _startWaitingMessages();
          }
          if (!state.isSending) {
            _stopWaitingMessages();
          }
          _scrollToBottom();
        },
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: ScreenAppBar(
              title: l10n.associationContactUs,
              actions: [
                IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: l10n.associationChatsTooltip,
                ),
              ],
            ),
            drawer: _buildDrawer(context),
            body: Column(
              children: [
                Expanded(
                  child: MessageList(
                    scrollController: _scrollController,
                    waitingMessageCount: _waitingMessageCount,
                  ),
                ),
                _buildMessageInput(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: theme.colorScheme.secondaryFixed,
      child: SafeArea(
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 14.h, 8.w, 6.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.chatHistory,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.r,
                        color: theme.colorScheme.onTertiary,
                      ),
                      IconButton(
                        onPressed: _startNewChat,
                        icon: const Icon(Icons.add_comment_rounded),
                        tooltip: l10n.newChat,
                        color: theme.colorScheme.onTertiary,
                      ),
                    ],
                  ),
                ),
                if (state.isLoadingHistory)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: SpinKitFadingCircle(
                        size: 24.r,
                        color: theme.colorScheme.onTertiary,
                      ),
                    ),
                  ),
                Expanded(
                  child: state.chats.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Text(
                              l10n.noChatsYet,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          itemCount: state.chats.length,
                          separatorBuilder: (_, _) => SizedBox(height: 2.h),
                          itemBuilder: (context, index) {
                            final chat = state.chats[index];
                            final selected =
                                chat.id == state.selectedChatId ||
                                chat.sessionId == state.sessionId;
                            final title = chat.name.trim().isNotEmpty
                                ? chat.name
                                : l10n.chatTitle(chat.id);

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: ListTile(
                                dense: true,
                                selected: selected,
                                selectedTileColor: theme.colorScheme.primary
                                    .withValues(alpha: 0.14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                title: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onTertiary,
                                    fontWeight: selected
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                  ),
                                ),
                                trailing: selected
                                    ? Icon(
                                        Icons.check_rounded,
                                        size: 18.r,
                                        color: theme.colorScheme.onTertiary,
                                      )
                                    : null,
                                onTap: () => _openChat(chat.id),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatState state) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      maintainBottomViewPadding: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled:
                    !state.isSending &&
                    !state.isLoadingChat &&
                    !state.isLoadingHistory,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                cursorColor: theme.colorScheme.onPrimaryFixed,
                cursorHeight: 16.h,
                cursorWidth: 0.5.w,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                decoration: InputDecoration(
                  hint: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      l10n.associationChatMessageHint,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.secondaryFixed,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.onTertiaryFixed,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.r),
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
              onPressed:
                  state.isSending ||
                      state.isLoadingChat ||
                      state.isLoadingHistory
                  ? null
                  : _sendMessage,
              icon: const Icon(Icons.send_rounded),
              tooltip: l10n.send,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.onTertiaryFixed,
                foregroundColor: theme.colorScheme.secondaryFixed,
                disabledBackgroundColor: AppColors.burgundy.withValues(
                  alpha: 0.45,
                ),
                disabledForegroundColor: AppColors.offWhite.withValues(
                  alpha: 0.7,
                ),
                minimumSize: Size(48.w, 48.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildWaitingPanel(
  BuildContext context,
  ThemeData theme,
  int waitingMessageCount,
) {
  final l10n = AppLocalizations.of(context)!;
  final waitingMessages = [
    _WaitingMessage(
      icon: _waitingMessageIcons[0],
      text: l10n.chatWaitingPreparing,
    ),
    _WaitingMessage(
      icon: _waitingMessageIcons[1],
      text: l10n.chatWaitingLongTime,
    ),
    _WaitingMessage(
      icon: _waitingMessageIcons[2],
      text: l10n.chatWaitingChecking,
    ),
    _WaitingMessage(
      icon: _waitingMessageIcons[3],
      text: l10n.chatWaitingAlmostDone,
    ),
  ];
  final visibleMessages = waitingMessages.take(waitingMessageCount);
  final isRtl = Directionality.of(context) == TextDirection.rtl;

  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      width: 0.78.sw,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryFixed,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isRtl ? 18.r : 6.r),
          topRight: Radius.circular(isRtl ? 6.r : 18.r),
          bottomLeft: Radius.circular(18.r),
          bottomRight: Radius.circular(18.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...visibleMessages.map(
            (message) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Icon(
                    message.icon,
                    size: 18.r,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      message.text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpinKitThreeBounce(color: theme.colorScheme.primary, size: 22.r),
        ],
      ),
    ),
  );
}

String _formatMessageTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

const _waitingMessageIcons = [
  Icons.auto_awesome_rounded,
  Icons.hourglass_top_rounded,
  Icons.manage_search_rounded,
  Icons.support_agent_rounded,
];

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.scrollController,
    required this.waitingMessageCount,
  });
  final ScrollController scrollController;
  final int waitingMessageCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isLoadingChat ||
            (state.isLoadingHistory && state.messages.isEmpty)) {
          return Center(
            child: SpinKitFadingCircle(
              size: 40.r,
              color: theme.colorScheme.onTertiary,
              itemCount: 14,
            ),
          );
        }

        if (state.messages.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(28.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 34.r,
                    backgroundColor: theme.colorScheme.tertiaryFixed,
                    child: Icon(
                      Icons.support_agent_rounded,
                      size: 34.r,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    l10n.askAssociation,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    l10n.chooseChatOrAskQuestion,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
          itemCount: state.messages.length + (state.isSending ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.messages.length && state.isSending) {
              return _buildWaitingPanel(
                context,
                theme,
                waitingMessageCount == 0
                    ? _waitingMessageIcons.length
                    : waitingMessageCount,
              );
            }

            final message = state.messages[index];
            return _MessageBubble(
              message: message,
              timeText: _formatMessageTime(message.createdAt),
              onRetry: message.retryText == null
                  ? null
                  : () => context.read<ChatCubit>().sendMessage(
                      appendUserMessage: false,
                      message: message.retryText!.trim(),
                    ),
            );
          },
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.timeText,
    required this.onRetry,
  });

  final ChatUiMessage message;
  final String timeText;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment = message.isUser
        ? AlignmentDirectional.centerEnd
        : AlignmentDirectional.centerStart;
    final color = message.isError
        ? theme.colorScheme.errorContainer
        : message.isUser
        ? theme.colorScheme.onTertiaryFixed
        : theme.colorScheme.tertiaryFixed;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final smallTopLeft = message.isUser ? isRtl : !isRtl;
    final radius = BorderRadius.only(
      topLeft: Radius.circular(smallTopLeft ? 6.r : 18.r),
      topRight: Radius.circular(smallTopLeft ? 18.r : 6.r),
      bottomLeft: Radius.circular(18.r),
      bottomRight: Radius.circular(18.r),
    );

    return Align(
      alignment: alignment,
      child: Container(
        width: 0.78.sw,
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
        decoration: BoxDecoration(color: color, borderRadius: radius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isUser)
              Text(
                message.text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: message.isUser? theme.colorScheme.secondaryFixed: theme.colorScheme.primaryFixed,
                  height: 1.45,
                ),
              )
            else
              MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: theme.textTheme.bodyMedium?.copyWith(
                    color: message.isUser? theme.colorScheme.secondaryFixed: theme.colorScheme.primaryFixed,
                    height: 1.45,
                  ),
                  strong: theme.textTheme.bodyMedium?.copyWith(
                    color: message.isUser? theme.colorScheme.secondaryFixed: theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                  listBullet: theme.textTheme.bodyMedium?.copyWith(
                    color: message.isUser? theme.colorScheme.secondaryFixed: theme.colorScheme.primaryFixed,
                  ),
                ),
              ),
            if (message.isError && onRetry != null) ...[
              SizedBox(height: 10.h),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(AppLocalizations.of(context)!.retry),
                style: OutlinedButton.styleFrom(
                  foregroundColor: message.isUser? theme.colorScheme.secondaryFixed: theme.colorScheme.primaryFixed,
                  side: BorderSide(color: message.isUser? theme.colorScheme.secondaryFixed: theme.colorScheme.primaryFixed.withValues(alpha: 0.55)),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
            SizedBox(height: 6.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                timeText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: message.isUser? theme.colorScheme.secondaryFixed: theme.colorScheme.primaryFixed.withValues(alpha: 0.75),
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaitingMessage {
  const _WaitingMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;
}
