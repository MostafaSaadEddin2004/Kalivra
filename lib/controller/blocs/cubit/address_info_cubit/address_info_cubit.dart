import 'package:bloc/bloc.dart';
import 'package:kalivra/model/address/capiltal_model.dart';
import 'package:kalivra/model/address/city_model.dart';
import 'package:kalivra/model/address/town_model.dart';
import 'package:kalivra/model/services/api/address_info_services.dart';
import 'package:meta/meta.dart';

part 'address_info_state.dart';

class AddressInfoCubit extends Cubit<AddressInfoState> {
  AddressInfoCubit() : super(const AddressInfoState());

  final AddressInfoServices _services = AddressInfoServices();

  Future<void> fetchCapitals() async {
    emit(
      state.copyWith(
        loadingRequest: AddressInfoRequest.capitals,
        clearFailure: true,
      ),
    );
    try {
      final capitals = await _services.getCapitals();
      emit(
        state.copyWith(
          capitals: capitals,
          clearLoadingRequest: true,
          clearFailure: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          failureRequest: AddressInfoRequest.capitals,
          errorMessage: e.toString(),
          clearLoadingRequest: true,
        ),
      );
    }
  }

  Future<void> fetchCities({required String capitalId}) async {
    emit(
      state.copyWith(
        cities: const [],
        towns: const [],
        loadingRequest: AddressInfoRequest.cities,
        clearFailure: true,
      ),
    );
    try {
      final cities = await _services.getCities(capitalId: capitalId);
      emit(
        state.copyWith(
          cities: cities,
          clearLoadingRequest: true,
          clearFailure: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          failureRequest: AddressInfoRequest.cities,
          errorMessage: e.toString(),
          clearLoadingRequest: true,
        ),
      );
    }
  }

  Future<void> fetchTowns({required String cityId}) async {
    emit(
      state.copyWith(
        towns: const [],
        loadingRequest: AddressInfoRequest.towns,
        clearFailure: true,
      ),
    );
    try {
      final towns = await _services.getTowns(cityId: cityId);
      emit(
        state.copyWith(
          towns: towns,
          clearLoadingRequest: true,
          clearFailure: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          failureRequest: AddressInfoRequest.towns,
          errorMessage: e.toString(),
          clearLoadingRequest: true,
        ),
      );
    }
  }
}
