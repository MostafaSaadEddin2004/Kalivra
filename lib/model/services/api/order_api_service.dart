import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/order/invoice_api_model.dart';
import 'package:kalivra/model/order/order_api_model.dart';
import 'package:kalivra/model/order/shipment_api_model.dart';
import 'package:kalivra/model/order/transaction_api_model.dart';

class OrderApiService {
  OrderApiService(this._client);
  final DioClient _client;

  Future<List<OrderApiModel>> getOrders() async {
    final res = await _client.get<Map<String, dynamic>>('orders');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<OrderApiModel?> getOrderById(int id) async {
    final res = await _client.get<Map<String, dynamic>>('orders/$id');
    final data = res['data'];
    if (data is Map<String, dynamic>) {
      return OrderApiModel.fromJson(data);
    }
    return null;
  }

  Future<List<InvoiceApiModel>> getInvoices(int orderId) async {
    final res = await _client.get<Map<String, dynamic>>('orders/$orderId/invoices');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => InvoiceApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<ShipmentApiModel>> getShipments(int orderId) async {
    final res = await _client.get<Map<String, dynamic>>('orders/$orderId/shipments');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => ShipmentApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<TransactionApiModel>> getTransactions(int orderId) async {
    final res = await _client.get<Map<String, dynamic>>('orders/$orderId/transactions');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => TransactionApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
