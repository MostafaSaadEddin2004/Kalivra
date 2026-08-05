part of 'chat_cubit.dart';

abstract class ChatState {
  const ChatState({
    this.chats = const [],
    this.messages = const [],
    this.sessionId,
    this.selectedChatId,
    this.errorMessage = '',
  });

  final List<ChatApiModel> chats;
  final List<ChatUiMessage> messages;
  final String? sessionId;
  final int? selectedChatId;
  final String errorMessage;

  bool get isLoadingHistory => this is ChatHistoryLoading;

  bool get isLoadingChat => this is ChatLoading;

  bool get isSending => this is ChatSending;
}

final class ChatInitial extends ChatState {
  const ChatInitial({
    super.chats,
    super.messages,
    super.sessionId,
    super.selectedChatId,
    super.errorMessage,
  });
}

final class ChatHistoryLoading extends ChatState {
  const ChatHistoryLoading({
    super.chats,
    super.messages,
    super.sessionId,
    super.selectedChatId,
  });
}

final class ChatLoading extends ChatState {
  const ChatLoading({
    super.chats,
    super.messages,
    super.sessionId,
    super.selectedChatId,
  });
}

final class ChatSending extends ChatState {
  const ChatSending({
    required super.messages,
    required super.sessionId,
    super.chats,
    super.selectedChatId,
  });
}

final class ChatSuccessed extends ChatState {
  const ChatSuccessed({
    required super.messages,
    super.chats,
    super.sessionId,
    super.selectedChatId,
  });
}

final class ChatFetchedData extends ChatState {
  const ChatFetchedData({
    required super.chats,
    required super.messages,
    super.sessionId,
    super.selectedChatId,
  });
}

final class ChatFailed extends ChatState {
  const ChatFailed({
    required this.message,
    super.chats,
    super.messages,
    super.sessionId,
    super.selectedChatId,
  }) : super(errorMessage: message);

  final String message;
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
