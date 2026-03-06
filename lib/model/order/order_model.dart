/// Single line item in an order.
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
}

/// Order summary + line items for order details.
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
}
