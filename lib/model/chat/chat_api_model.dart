class ChatApiModel {
  const ChatApiModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.lastMessageAt,
    required this.interactions,
  });

  final int id;
  final int? userId;
  final String name;
  final String status;
  final DateTime? createdAt;
  final DateTime? lastMessageAt;
  final List<ChatInteractionModel> interactions;

  String get sessionId {
    for (final interaction in interactions) {
      if (interaction.sessionId.isNotEmpty) return interaction.sessionId;
    }
    return id.toString();
  }

  factory ChatApiModel.fromJson(Map<dynamic, dynamic> json) {
    final interactionsRaw = json['interactions'];
    final interactions = interactionsRaw is List
        ? interactionsRaw
              .whereType<Map>()
              .map(ChatInteractionModel.fromJson)
              .toList()
        : <ChatInteractionModel>[];

    return ChatApiModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      lastMessageAt: DateTime.tryParse(
        json['last_message_at']?.toString() ?? '',
      ),
      interactions: interactions,
    );
  }
}

class ChatInteractionModel {
  const ChatInteractionModel({
    required this.id,
    required this.sessionId,
    required this.chatSessionId,
    required this.userId,
    required this.userMessage,
    required this.responseMessage,
    required this.status,
    required this.errorMessage,
    required this.createdAt,
  });

  final int id;
  final String sessionId;
  final int? chatSessionId;
  final int? userId;
  final String userMessage;
  final String responseMessage;
  final String status;
  final String errorMessage;
  final DateTime createdAt;

  bool get isSuccess => status == 'success';

  factory ChatInteractionModel.fromJson(Map<dynamic, dynamic> json) {
    return ChatInteractionModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      sessionId: json['session_id']?.toString() ?? '',
      chatSessionId: int.tryParse(json['chat_session_id']?.toString() ?? ''),
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      userMessage: json['user_message']?.toString() ?? '',
      responseMessage: json['ai_response']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      errorMessage: json['error_message']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class ChatResponseModel {
  const ChatResponseModel({
    required this.message,
    required this.sessionId,
    required this.timestamp,
  });

  final String message;
  final String sessionId;
  final DateTime timestamp;

  factory ChatResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return ChatResponseModel(
      message: json['message']?.toString() ?? '',
      sessionId: json['sessionId']?.toString() ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
