import 'package:kalivra/model/order/order_model.dart';

abstract class OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;

  OrdersLoaded({required this.orders});
}
final class OneOrderLoaded extends OrdersState {
  final OrderModel order;

  OneOrderLoaded({required this.order});
}

final class OrdersFailed extends OrdersState {
  final String message;

  OrdersFailed({required this.message});
}
