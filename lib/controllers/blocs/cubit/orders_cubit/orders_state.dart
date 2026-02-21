import 'package:kalivra/models/order_model.dart';

abstract class OrdersState {
  const OrdersState();
  List<OrderModel> get orders => [];
  dynamic get error => null;
  bool get isLoading => false;
  bool get hasError => error != null;

  static const OrdersState initial = _OrdersInitial();
  static const OrdersState loading = _OrdersLoading();
  static OrdersState loaded(List<OrderModel> o) => _OrdersLoaded(o);
  static OrdersState failed(dynamic e, [StackTrace? st]) => _OrdersFailed(e, st);
}

final class _OrdersInitial extends OrdersState {
  const _OrdersInitial();
}

final class _OrdersLoading extends OrdersState {
  const _OrdersLoading();
  @override
  bool get isLoading => true;
}

final class _OrdersLoaded extends OrdersState {
  _OrdersLoaded(this.orders);
  @override
  final List<OrderModel> orders;
}

final class _OrdersFailed extends OrdersState {
  _OrdersFailed(this.error, [this.stackTrace]);
  @override
  final dynamic error;
  final StackTrace? stackTrace;
}
