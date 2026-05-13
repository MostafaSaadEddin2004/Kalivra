class OrderLineItem {
  const OrderLineItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.imageUrl,
  });

  final String productName;
  final int quantity;
  final double unitPrice;
  final String? imageUrl;

  double get total => quantity * unitPrice;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      imageUrl: json['imageUrl'],
    );
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.subtotal,
    required this.deliveryCost,
    required this.total,
    required this.items,
    this.shippingAddress,
    this.paymentMethod,
  });

  final String id;
  final String date;
  final String status;
  final double subtotal;
  final double deliveryCost;
  final double total;
  final List<OrderLineItem> items;
  final String? shippingAddress;
  final String? paymentMethod;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      date: json['date'],
      status: json['status'],
      subtotal: json['subtotal'],
      deliveryCost: json['deliveryCost'],
      total: json['total'],
      items: json['items'].map((e) => OrderLineItem.fromJson(e)).toList(),
    );
  }
}
