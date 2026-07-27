import 'package:bloc/bloc.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/chat/chat_api_model.dart';
import 'package:kalivra/model/services/api/chat_api_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState()) {
    getChatHistory();
  }

  final ChatApiService _chatService = ChatApiService();

  Future<void> sendMessage({required String message}) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final sessionId = state.sessionId ?? await _buildSessionId();
    final userMessage = ChatUiMessage.user(
      text: trimmed,
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        status: ChatStatus.sending,
        sessionId: sessionId,
        messages: [...state.messages, userMessage],
        errorMessage: '',
      ),
    );

    try {
      final response = await _chatService.sendMessage(
        message: trimmed,
        sessionId: sessionId,
      );
      final responseText = response.message.trim();
      if (responseText.isEmpty) {
        throw 'The association response was empty. Please try again.';
      }

      emit(
        state.copyWith(
          status: ChatStatus.success,
          messages: [
            ...state.messages,
            ChatUiMessage.response(
              text: responseText,
              createdAt: response.timestamp,
            ),
          ],
          errorMessage: '',
        ),
      );
      await getChatHistory(keepCurrentMessages: true);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.failure,
          messages: [
            ...state.messages,
            ChatUiMessage.error(
              text: e.toString(),
              createdAt: DateTime.now(),
              retryText: trimmed,
            ),
          ],
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getChatHistory({bool keepCurrentMessages = false}) async {
    emit(
      state.copyWith(
        status: ChatStatus.loadingHistory,
        errorMessage: '',
        messages: keepCurrentMessages ? state.messages : state.messages,
      ),
    );

    try {
      final chats = await _chatService.getChatHistory();
      emit(
        state.copyWith(status: ChatStatus.idle, chats: chats, errorMessage: ''),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> getChatById({required int sessionId}) async {
    emit(
      state.copyWith(
        status: ChatStatus.loadingChat,
        messages: const [],
        errorMessage: '',
      ),
    );

    try {
      final interactions = await _chatService.getChatById(
        chatSessionId: sessionId,
      );
      emit(
        state.copyWith(
          status: ChatStatus.idle,
          sessionId: _firstSessionId(interactions) ?? sessionId.toString(),
          messages: _messagesFromInteractions(interactions),
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> startNewChat() async {
    emit(
      state.copyWith(
        status: ChatStatus.idle,
        sessionId: await _buildSessionId(),
        messages: const [],
        errorMessage: '',
      ),
    );
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
    final dateNumbers =
        '${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}';
    return '$userId$dateNumbers';
  }
}
