import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom nav index: 0=Home, 1=Categories, 2=Notifications, 3=Search. Cart is in app bar.
class NavCubit extends Cubit<int> {
  NavCubit() : super(0);

  void goTo(int index) {
    if (index >= 0 && index <= 3) emit(index);
  }

  static const int home = 0;
  static const int categories = 1;
  static const int notifications = 2;
  static const int search = 3;
}
