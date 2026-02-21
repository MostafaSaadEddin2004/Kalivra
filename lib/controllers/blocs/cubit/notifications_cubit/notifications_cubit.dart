import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/notifications_cubit/notifications_state.dart';

export 'notifications_state.dart';

/// Holds whether notifications view requires login. Check is in cubit.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._authCubit) : super(const NotificationsState()) {
    _updateLoginRequired();
  }

  final AuthCubit _authCubit;

  void _updateLoginRequired() {
    final token = _authCubit.state.token;
    final loginRequired = token == null || token.isEmpty;
    emit(NotificationsState(loginRequired: loginRequired));
  }

  /// Call when the tab is shown or when auth may have changed.
  void refresh() => _updateLoginRequired();
}
