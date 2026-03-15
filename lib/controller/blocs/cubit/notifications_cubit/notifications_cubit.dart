import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';

export 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState()) {
    _updateLoginRequired();
  }

  Future<void> _updateLoginRequired() async{
    final token = await LocalStore.getToken();
    final loginRequired = token == null || token.isEmpty;
    emit(NotificationsState(loginRequired: loginRequired));
  }

  Future<void> refresh() => _updateLoginRequired();
}
