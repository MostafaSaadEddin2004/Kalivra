/// GET /api/shop/v1/orders/{id}/invoices – order invoice.
class InvoiceApiModel {
  const InvoiceApiModel({
    required this.id,
    this.incrementId,
    this.state,
    this.grandTotal,
    this.formattedGrandTotal,
    this.createdAt,
    this.orderId,
    this.items,
  });

  final int id;
  final String? incrementId;
  final String? state;
  final double? grandTotal;
  final String? formattedGrandTotal;
  final String? createdAt;
  final int? orderId;
  final List<Map<String, dynamic>>? items;

  factory InvoiceApiModel.fromJson(Map<String, dynamic> json) {
    return InvoiceApiModel(
      id: json['id'] as int,
      incrementId: json['increment_id'] as String?,
      state: json['state'] as String?,
      grandTotal: (json['grand_total'] as num?)?.toDouble(),
      formattedGrandTotal: json['formatted_grand_total'] as String?,
      createdAt: json['created_at'] as String?,
      orderId: json['order_id'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
