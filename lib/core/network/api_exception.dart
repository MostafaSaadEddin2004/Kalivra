class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.code,
    this.type,
    this.httpStatus,
    this.nextAction,
    this.data,
  });

  final String message;
  final String? code;
  final String? type;
  final int? httpStatus;
  final String? nextAction;
  final Map<String, dynamic>? data;

  static ApiException fromResponseData(
    dynamic data, {
    int? fallbackStatus,
    String fallbackMessage = 'Something wrong',
  }) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final error = map['error'] is Map
          ? Map<String, dynamic>.from(map['error'] as Map)
          : map;
      final message =
          error['message']?.toString() ?? map['message']?.toString();

      return ApiException(
        message: message?.isNotEmpty == true ? message! : fallbackMessage,
        code: error['code']?.toString() ?? map['code']?.toString(),
        type: error['type']?.toString() ?? map['type']?.toString(),
        httpStatus:
            int.tryParse(error['http_status']?.toString() ?? '') ??
            fallbackStatus,
        nextAction:
            error['next_action']?.toString() ?? map['next_action']?.toString(),
        data: map,
      );
    }

    final text = data?.toString();
    return ApiException(
      message: text?.isNotEmpty == true ? text! : fallbackMessage,
      httpStatus: fallbackStatus,
    );
  }

  bool get requiresForcedLogin {
    return code == 'SESSION_EXPIRED' ||
        code == 'ALREADY_LOGGED_OUT' ||
        code == 'ALREADY_LOGGED_IN' ||
        code == 'ACCOUNT_INACTIVE' ||
        code == 'ACCOUNT_SUSPENDED';
  }

  @override
  String toString() => message;
}
