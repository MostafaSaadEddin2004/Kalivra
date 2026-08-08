import 'package:bloc/bloc.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/chat/chat_api_model.dart';
import 'package:kalivra/model/services/api/chat_api_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatInitial()) {
    getChatHistory();
  }

  final ChatApiService _chatService = ChatApiService();

  Future<void> sendMessage({
    required String message,
    required bool appendUserMessage,
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    final sessionId = state.sessionId ?? await _buildSessionId();
    final messages = appendUserMessage
        ? [
            ...state.messages,
            ChatUiMessage.user(text: trimmed, createdAt: DateTime.now()),
          ]
        : _messagesWithoutRetryError(trimmed);

    emit(
      ChatSending(
        chats: state.chats,
        messages: messages,
        sessionId: sessionId,
        selectedChatId: state.selectedChatId,
      ),
    );

    try {
      final response = await _chatService.sendMessage(
        message: trimmed,
        sessionId: sessionId,
      );
      final responseText = response.message.trim();
      emit(
        ChatSuccessed(
          chats: state.chats,
          sessionId: response.sessionId.isNotEmpty
              ? response.sessionId
              : sessionId,
          selectedChatId: state.selectedChatId,
          messages: [
            ...state.messages,
            ChatUiMessage.response(
              text: responseText,
              createdAt: response.timestamp,
            ),
          ],
        ),
      );
      await getChatHistory(keepCurrentMessages: true);
    } catch (e) {
      emit(
        ChatFailed(
          message: e.toString(),
          chats: state.chats,
          sessionId: state.sessionId,
          selectedChatId: state.selectedChatId,
          messages: [
            ...state.messages,
            ChatUiMessage.error(
              text: e.toString(),
              createdAt: DateTime.now(),
              retryText: trimmed,
            ),
          ],
        ),
      );
    }
  }

  List<ChatUiMessage> _messagesWithoutRetryError(String retryText) {
    final messages = List<ChatUiMessage>.of(state.messages);
    final errorIndex = messages.lastIndexWhere(
      (message) =>
          message.isError && message.retryText?.trim() == retryText.trim(),
    );
    if (errorIndex != -1) {
      messages.removeAt(errorIndex);
    }
    return messages;
  }

  Future<void> getChatHistory({bool keepCurrentMessages = false}) async {
    emit(
      ChatHistoryLoading(
        chats: state.chats,
        messages: state.messages,
        sessionId: state.sessionId,
        selectedChatId: state.selectedChatId,
      ),
    );

    try {
      final chats = await _chatService.getChatHistory();
      final recentChats = List<ChatApiModel>.of(chats)
        ..sort(_compareRecentChats);
      final keepEmptyNewChat =
          !keepCurrentMessages &&
          state.selectedChatId == null &&
          state.messages.isEmpty &&
          state.sessionId != null;
      final selectedChat = keepEmptyNewChat
          ? null
          : keepCurrentMessages
          ? _selectedChatFromHistory(recentChats) ??
                _latestChatForCurrentMessages(recentChats)
          : recentChats.isEmpty
          ? null
          : recentChats.first;
      final selectedMessages = keepCurrentMessages
          ? state.messages
          : selectedChat == null
          ? const <ChatUiMessage>[]
          : _messagesFromInteractions(selectedChat.interactions);

      emit(
        ChatFetchedData(
          chats: recentChats,
          messages: selectedMessages,
          sessionId: selectedChat?.sessionId ?? state.sessionId,
          selectedChatId: selectedChat?.id ?? state.selectedChatId,
        ),
      );
    } catch (e) {
      emit(
        ChatFailed(
          message: e.toString(),
          chats: state.chats,
          messages: state.messages,
          sessionId: state.sessionId,
          selectedChatId: state.selectedChatId,
        ),
      );
    }
  }

  Future<void> getChatById({required int sessionId}) async {
    emit(
      ChatLoading(
        chats: state.chats,
        sessionId: state.sessionId,
        selectedChatId: sessionId,
        messages: const [],
      ),
    );

    try {
      final interactions = await _chatService.getChatById(
        chatSessionId: sessionId,
      );
      emit(
        ChatFetchedData(
          chats: state.chats,
          sessionId: _firstSessionId(interactions) ?? sessionId.toString(),
          selectedChatId: sessionId,
          messages: _messagesFromInteractions(interactions),
        ),
      );
    } catch (e) {
      emit(
        ChatFailed(
          message: e.toString(),
          chats: state.chats,
          messages: state.messages,
          sessionId: state.sessionId,
          selectedChatId: state.selectedChatId,
        ),
      );
    }
  }

  Future<void> startNewChat() async {
    emit(
      ChatInitial(
        chats: state.chats,
        sessionId: await _buildSessionId(),
        selectedChatId: null,
        messages: const [],
      ),
    );
  }

  int _compareRecentChats(ChatApiModel first, ChatApiModel second) {
    final firstDate = first.lastMessageAt ?? first.updatedAt ?? first.createdAt;
    final secondDate =
        second.lastMessageAt ?? second.updatedAt ?? second.createdAt;
    if (firstDate == null && secondDate == null) return 0;
    if (firstDate == null) return 1;
    if (secondDate == null) return -1;
    return secondDate.compareTo(firstDate);
  }

  ChatApiModel? _selectedChatFromHistory(List<ChatApiModel> chats) {
    for (final chat in chats) {
      if (chat.id == state.selectedChatId ||
          chat.sessionId == state.sessionId) {
        return chat;
      }
    }
    return null;
  }

  ChatApiModel? _latestChatForCurrentMessages(List<ChatApiModel> chats) {
    if (state.messages.isEmpty || chats.isEmpty) return null;
    final latestUserMessage = state.messages.reversed
        .where((message) => message.isUser)
        .map((message) => message.text.trim())
        .firstWhere((message) => message.isNotEmpty, orElse: () => '');
    if (latestUserMessage.isNotEmpty) {
      for (final chat in chats) {
        final hasMatchingMessage = chat.interactions.any(
          (interaction) => interaction.userMessage.trim() == latestUserMessage,
        );
        if (hasMatchingMessage) return chat;
      }
    }
    return chats.first;
  }

  List<ChatUiMessage> _messagesFromInteractions(
    List<ChatInteractionModel> interactions,
  ) {
    final messages = <ChatUiMessage>[];
    for (final interaction in interactions) {
      if (interaction.userMessage.trim().isNotEmpty) {
        messages.add(
          ChatUiMessage.user(
            text: interaction.userMessage,
            createdAt: interaction.createdAt,
          ),
        );
      }

      if (interaction.isSuccess &&
          interaction.responseMessage.trim().isNotEmpty) {
        messages.add(
          ChatUiMessage.response(
            text: interaction.responseMessage,
            createdAt: interaction.createdAt,
          ),
        );
      } else if (interaction.errorMessage.trim().isNotEmpty) {
        messages.add(
          ChatUiMessage.error(
            text: interaction.errorMessage,
            createdAt: interaction.createdAt,
            retryText: interaction.userMessage,
          ),
        );
      }
    }
    return messages;
  }

  String? _firstSessionId(List<ChatInteractionModel> interactions) {
    for (final interaction in interactions) {
      if (interaction.sessionId.isNotEmpty) return interaction.sessionId;
    }
    return null;
  }

  Future<String> _buildSessionId() async {
    final userId = await LocalStore.getUserId() ?? '';
    final now = DateTime.now();
    return '$userId${now.microsecondsSinceEpoch}';
  }
}
