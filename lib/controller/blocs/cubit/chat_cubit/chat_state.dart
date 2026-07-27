part of 'chat_cubit.dart';

enum ChatStatus { idle, loadingHistory, loadingChat, sending, success, failure }

class ChatState {
  const ChatState({
    this.status = ChatStatus.idle,
    this.chats = const [],
    this.messages = const [],
    this.sessionId,
    this.errorMessage = '',
  });

  final ChatStatus status;
  final List<ChatApiModel> chats;
  final List<ChatUiMessage> messages;
  final String? sessionId;
  final String errorMessage;

  bool get isLoadingHistory => status == ChatStatus.loadingHistory;

  bool get isLoadingChat => status == ChatStatus.loadingChat;

  bool get isSending => status == ChatStatus.sending;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatApiModel>? chats,
    List<ChatUiMessage>? messages,
    String? sessionId,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChatUiMessage {
  const ChatUiMessage({
    required this.text,
    required this.createdAt,
    required this.isUser,
    this.isError = false,
    this.retryText,
  });

  final String text;
  final DateTime createdAt;
  final bool isUser;
  final bool isError;
  final String? retryText;

  factory ChatUiMessage.user({
    required String text,
    required DateTime createdAt,
  }) {
    return ChatUiMessage(text: text, createdAt: createdAt, isUser: true);
  }

  factory ChatUiMessage.response({
    required String text,
    required DateTime createdAt,
  }) {
    return ChatUiMessage(text: text, createdAt: createdAt, isUser: false);
  }

  factory ChatUiMessage.error({
    required String text,
    required DateTime createdAt,
    required String retryText,
  }) {
    return ChatUiMessage(
      text: text,
      createdAt: createdAt,
      isUser: false,
      isError: true,
      retryText: retryText,
    );
  }
}
