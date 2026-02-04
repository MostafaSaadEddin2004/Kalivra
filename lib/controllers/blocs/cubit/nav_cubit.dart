import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom nav index: 0=Home, 1=Cart, 2=Categories, 3=Notifications, 4=Search.
class NavCubit extends Cubit<int> {
  NavCubit() : super(0);

  void goTo(int index) {
    if (index >= 0 && index <= 4) emit(index);
  }

  static const int home = 0;
  static const int categories = 1;
  static const int cart = 2;
  static const int notifications = 3;
  static const int search = 4;
}
