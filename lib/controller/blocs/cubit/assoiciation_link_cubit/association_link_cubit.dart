import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'association_link_state.dart';

class AssociationLinkCubit extends Cubit<AssociationLinkState> {
  AssociationLinkCubit() : super(AssociationLinkInitial());
}
