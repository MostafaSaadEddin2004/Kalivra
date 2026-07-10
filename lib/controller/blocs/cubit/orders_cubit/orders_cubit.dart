import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/orders_cubit/orders_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/services/api/order_api_service.dart';

export 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersLoading());

  final OrderApiService _orderService = OrderApiService();

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(OrdersLoginRequired());
      return;
    }

    try {
      final orders = await _orderService.getOrders();
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrdersFailed(message: e.toString()));
    }
  }

  Future<void> loadOrderDetails(int orderId) async {
    emit(OrdersLoading());
    try {
      final order = await _orderService.getOrderDetails(orderId);
      emit(OneOrderLoaded(order: order));
    } catch (e) {
      emit(OrdersFailed(message: e.toString()));
    }
  }
}
