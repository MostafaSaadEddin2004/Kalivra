/// Generic wrapper for Bagisto API responses (e.g. { "data": T }).
class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    this.message,
    this.meta,
  });

  final T data;
  final String? message;
  final ApiResponseMeta? meta;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      data: fromJsonT(json['data']),
      message: json['message'] as String?,
      meta: json['meta'] != null
          ? ApiResponseMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Pagination meta (Laravel-style).
class ApiResponseMeta {
  const ApiResponseMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;

  factory ApiResponseMeta.fromJson(Map<String, dynamic> json) {
    return ApiResponseMeta(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
    );
  }
}
