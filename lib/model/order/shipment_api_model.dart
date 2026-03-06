/// GET /api/shop/v1/orders/{id}/shipments – order shipment/tracking.
class ShipmentApiModel {
  const ShipmentApiModel({
    required this.id,
    this.orderId,
    this.carrierTitle,
    this.trackNumber,
    this.title,
    this.shippedAt,
    this.createdAt,
    this.items,
  });

  final int id;
  final int? orderId;
  final String? carrierTitle;
  final String? trackNumber;
  final String? title;
  final String? shippedAt;
  final String? createdAt;
  final List<Map<String, dynamic>>? items;

  factory ShipmentApiModel.fromJson(Map<String, dynamic> json) {
    return ShipmentApiModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int?,
      carrierTitle: json['carrier_title'] as String?,
      trackNumber: json['track_number'] as String?,
      title: json['title'] as String?,
      shippedAt: json['shipped_at'] as String?,
      createdAt: json['created_at'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
