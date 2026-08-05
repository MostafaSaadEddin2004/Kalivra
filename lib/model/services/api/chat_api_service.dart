import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/chat/chat_api_model.dart';

class ChatApiService {
  ChatApiService()
    : _client = DioClient(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 30),
      );

  final DioClient _client;

  Future<ChatResponseModel> sendMessage({
    required String message,
    required String sessionId,
  }) async {
    final res = await _client.post(
      'chat',
      queryParameters: {'question': message, 'sessionId': sessionId},
    );
    final data = res.data is Map
        ? Map<dynamic, dynamic>.from(res.data as Map)
        : <dynamic, dynamic>{};
    return ChatResponseModel.fromJson(data);
  }

  Future<List<ChatApiModel>> getChatHistory() async {
    final res = await _client.post('chat-history');
    final data = res.data is Map ? res.data['data'] : res.data;
    if (data is! List) return const [];
    return data.whereType<Map>().map(ChatApiModel.fromJson).toList();
  }

  Future<List<ChatInteractionModel>> getChatById({
    required int chatSessionId,
  }) async {
    final res = await _client.get(
      'chat-session-id',
      queryParameters: {'sessionId': chatSessionId},
    );
    final data = res.data is Map ? res.data['data'] : res.data;
    if (data is! List) return const [];
    return data.whereType<Map>().map(ChatInteractionModel.fromJson).toList();
  }
}
