import 'package:flutter_bloc/flutter_bloc.dart';

class NavCubit extends Cubit<int> {
  NavCubit() : super(0);

  void goTo(int index) {
    if (index >= 0 && index <= 3) emit(index);
  }

  static const int home = 0;
  static const int categories = 1;
  static const int cart = 2;
  static const int profile = 3;
}
