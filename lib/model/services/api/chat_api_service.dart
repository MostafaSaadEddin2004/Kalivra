import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/chat/chat_api_model.dart';

class ChatApiService {
  ChatApiService()
    : _client = DioClient(
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
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
        ? Map<String, dynamic>.from(res.data as Map)
        : <String, dynamic>{};
    return ChatResponseModel.fromJson(data);
  }

  Future<List<ChatApiModel>> getChatHistory() async {
    final userId = await LocalStore.getUserId();
    if (userId == null || userId.trim().isEmpty) return const [];

    try {
      final res = await _client.get(
        'chat/history',
        queryParameters: {'user_id': userId},
      );
      return _parseSessions(res.data);
    } catch (_) {
      final res = await _client.get('chat/history/$userId');
      return _parseSessions(res.data);
    }
  }

  Future<List<ChatInteractionModel>> getChatById({
    required int chatSessionId,
  }) async {
    try {
      final res = await _client.get('chat/$chatSessionId');
      return _parseInteractions(res.data);
    } catch (_) {
      final res = await _client.get('chat/session/$chatSessionId');
      return _parseInteractions(res.data);
    }
  }

  List<ChatApiModel> _parseSessions(dynamic data) {
    final body = data is Map ? data['data'] : data;
    if (body is! List) return const [];
    return body
        .whereType<Map>()
        .map((item) => ChatApiModel.fromJson(item))
        .toList();
  }

  List<ChatInteractionModel> _parseInteractions(dynamic data) {
    final body = data is Map ? data['data'] : data;
    if (body is! List) return const [];
    return body
        .whereType<Map>()
        .map((item) => ChatInteractionModel.fromJson(item))
        .toList();
  }
}
