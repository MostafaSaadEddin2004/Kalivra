class ChatApiModel {
  const ChatApiModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
    required this.rating,
    required this.feedback,
    required this.createdAt,
    required this.lastMessageAt,
    required this.updatedAt,
    required this.interactions,
  });

  final int id;
  final int? userId;
  final String name;
  final String status;
  final dynamic rating;
  final String? feedback;
  final DateTime? createdAt;
  final DateTime? lastMessageAt;
  final DateTime? updatedAt;
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
      rating: json['rating'],
      feedback: json['feedback']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      lastMessageAt: DateTime.tryParse(
        json['last_message_at']?.toString() ?? '',
      ),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
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
    required this.messageType,
    required this.responseTime,
    required this.tokensUsed,
    required this.model,
    required this.status,
    required this.errorMessage,
    required this.userAgent,
    required this.ipAddress,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String sessionId;
  final int? chatSessionId;
  final int? userId;
  final String userMessage;
  final String responseMessage;
  final String messageType;
  final int? responseTime;
  final int? tokensUsed;
  final String model;
  final String status;
  final String errorMessage;
  final String userAgent;
  final String ipAddress;
  final ChatInteractionMetadata metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get isSuccess => status == 'success';

  factory ChatInteractionModel.fromJson(Map<dynamic, dynamic> json) {
    return ChatInteractionModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      sessionId: json['session_id']?.toString() ?? '',
      chatSessionId: int.tryParse(json['chat_session_id']?.toString() ?? ''),
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      userMessage: json['user_message']?.toString() ?? '',
      responseMessage: json['ai_response']?.toString() ?? '',
      messageType: json['message_type']?.toString() ?? '',
      responseTime: int.tryParse(json['response_time']?.toString() ?? ''),
      tokensUsed: int.tryParse(json['tokens_used']?.toString() ?? ''),
      model: json['model']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      errorMessage: json['error_message']?.toString() ?? '',
      userAgent: json['user_agent']?.toString() ?? '',
      ipAddress: json['ip_address']?.toString() ?? '',
      metadata: ChatInteractionMetadata.fromJson(json['metadata']),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }
}

class ChatInteractionMetadata {
  const ChatInteractionMetadata({
    required this.timestamp,
    required this.requestId,
    required this.raw,
  });

  final DateTime? timestamp;
  final String requestId;
  final Map<String, dynamic> raw;

  factory ChatInteractionMetadata.fromJson(dynamic json) {
    final data = json is Map
        ? Map<String, dynamic>.from(json)
        : <String, dynamic>{};
    return ChatInteractionMetadata(
      timestamp: DateTime.tryParse(data['timestamp']?.toString() ?? ''),
      requestId: data['request_id']?.toString() ?? '',
      raw: data,
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
    final rawData = json['data'];
    final data = rawData is Map ? Map<dynamic, dynamic>.from(rawData) : json;
    final metadata = ChatInteractionMetadata.fromJson(data['metadata']);

    return ChatResponseModel(
      message:
          (rawData is String ? rawData : null) ??
          data['message']?.toString() ??
          data['ai_response']?.toString() ??
          json['message']?.toString() ??
          '',
      sessionId:
          data['sessionId']?.toString() ??
          data['session_id']?.toString() ??
          json['sessionId']?.toString() ??
          '',
      timestamp:
          DateTime.tryParse(data['timestamp']?.toString() ?? '') ??
          metadata.timestamp ??
          DateTime.tryParse(data['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
