import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/order/invoice_api_model.dart';
import 'package:kalivra/model/order/order_model.dart';
import 'package:kalivra/model/order/shipment_api_model.dart';
import 'package:kalivra/model/order/transaction_api_model.dart';

class OrderApiService {
  OrderApiService();
  final DioClient _client = DioClient();

  Future<List<OrderModel>> getOrders() async {
    final res = await _client.get<Map<String, dynamic>>('orders');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<OrderModel> getOrderById(int categoryId) async {
    final res = await _client.get<Map<String, dynamic>>('orders/$categoryId');
    final data = res['data'];
      return OrderModel.fromJson(data);
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
