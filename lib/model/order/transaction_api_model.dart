/// GET /api/shop/v1/orders/{id}/transactions – order payment transaction.
class TransactionApiModel {
  const TransactionApiModel({
    required this.id,
    this.orderId,
    this.transactionId,
    this.type,
    this.method,
    this.amount,
    this.formattedAmount,
    this.status,
    this.createdAt,
  });

  final int id;
  final int? orderId;
  final String? transactionId;
  final String? type;
  final String? method;
  final double? amount;
  final String? formattedAmount;
  final String? status;
  final String? createdAt;

  factory TransactionApiModel.fromJson(Map<String, dynamic> json) {
    return TransactionApiModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int?,
      transactionId: json['transaction_id'] as String?,
      type: json['type'] as String?,
      method: json['method'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      formattedAmount: json['formatted_amount'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
