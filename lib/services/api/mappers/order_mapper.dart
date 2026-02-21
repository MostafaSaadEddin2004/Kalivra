import 'package:kalivra/models/order_model.dart';
import 'package:kalivra/models/api/order_api_model.dart';

class OrderMapper {
  OrderMapper._();

  static OrderModel fromApi(OrderApiModel api) {
    final items = api.items
            ?.map((i) => OrderLineItem(
                  productName: i.name ?? '',
                  quantity: i.quantity ?? 0,
                  unitPrice: i.price ?? 0,
                  imageUrl: i.imageUrl,
                ))
            .toList() ??
        [];
    String? shippingStr;
    if (api.shippingAddress is Map) {
      final m = api.shippingAddress as Map<String, dynamic>;
      final parts = <String>[];
      if (m['address1'] != null) parts.add(m['address1'].toString());
      if (m['city'] != null) parts.add(m['city'].toString());
      if (m['state'] != null) parts.add(m['state'].toString());
      if (m['country'] != null) parts.add(m['country'].toString());
      shippingStr = parts.join(', ');
    }
    return OrderModel(
      id: api.id.toString(),
      date: api.createdAt ?? '',
      status: api.statusLabel ?? api.status ?? '',
      subtotal: api.subTotal ?? 0,
      deliveryCost: api.shippingAmount ?? 0,
      total: api.grandTotal ?? 0,
      items: items,
      shippingAddress: shippingStr,
      paymentMethod: api.paymentTitle,
    );
  }
}
