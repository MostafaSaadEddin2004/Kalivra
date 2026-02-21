import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/orders_cubit/orders_state.dart';
import 'package:kalivra/models/order_model.dart';
import 'package:kalivra/services/api/mappers/order_mapper.dart';
import 'package:kalivra/services/api/order_api_service.dart';

export 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._orderService) : super(OrdersState.initial);

  final OrderApiService _orderService;

  Future<void> loadOrders() async {
    emit(OrdersState.loading);
    try {
      final list = await _orderService.getOrders();
      final orders = list.map(OrderMapper.fromApi).toList();
      emit(OrdersState.loaded(orders));
    } catch (e, st) {
      emit(OrdersState.failed(e, st));
    }
  }

  Future<OrderModel?> loadOrderById(int id) async {
    try {
      final api = await _orderService.getOrderById(id);
      return api != null ? OrderMapper.fromApi(api) : null;
    } catch (_) {
      return null;
    }
  }
}
