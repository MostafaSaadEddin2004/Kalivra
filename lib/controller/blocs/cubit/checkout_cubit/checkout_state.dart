abstract class CheckoutState {
  const CheckoutState();
  bool get isLoading => false;
  bool get hasError => false;
  Object? get error => null;
  Map<String, dynamic>? get result => null;

  static const CheckoutState initial = _CheckoutInitial();
  static const CheckoutState loading = _CheckoutLoading();
  static CheckoutState success(Map<String, dynamic>? r) => _CheckoutSuccess(r);
  static CheckoutState failed(Object e, [StackTrace? st]) => _CheckoutFailed(e, st);
}

final class _CheckoutInitial extends CheckoutState {
  const _CheckoutInitial();
}

final class _CheckoutLoading extends CheckoutState {
  const _CheckoutLoading();
  @override
  bool get isLoading => true;
}

final class _CheckoutSuccess extends CheckoutState {
  _CheckoutSuccess(this.result);
  @override
  final Map<String, dynamic>? result;
}

final class _CheckoutFailed extends CheckoutState {
  _CheckoutFailed(this._error, [this.stackTrace]);
  final Object _error;
  final StackTrace? stackTrace;
  @override
  bool get hasError => true;
  @override
  Object? get error => _error;
}
