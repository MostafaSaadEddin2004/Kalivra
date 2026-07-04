part of 'address_info_cubit.dart';

enum AddressInfoRequest { capitals, cities, towns }

@immutable
final class AddressInfoState {
  const AddressInfoState({
    this.capitals = const [],
    this.cities = const [],
    this.towns = const [],
    this.loadingRequest,
    this.failureRequest,
    this.errorMessage,
  });

  final List<CapitalModel> capitals;
  final List<CityModel> cities;
  final List<TownModel> towns;
  final AddressInfoRequest? loadingRequest;
  final AddressInfoRequest? failureRequest;
  final String? errorMessage;

  bool get isLoadingCapitals => loadingRequest == AddressInfoRequest.capitals;

  bool get isLoadingCities => loadingRequest == AddressInfoRequest.cities;

  bool get isLoadingTowns => loadingRequest == AddressInfoRequest.towns;

  bool get capitalsFailed => failureRequest == AddressInfoRequest.capitals;

  bool get citiesFailed => failureRequest == AddressInfoRequest.cities;

  bool get townsFailed => failureRequest == AddressInfoRequest.towns;

  AddressInfoState copyWith({
    List<CapitalModel>? capitals,
    List<CityModel>? cities,
    List<TownModel>? towns,
    AddressInfoRequest? loadingRequest,
    AddressInfoRequest? failureRequest,
    String? errorMessage,
    bool clearLoadingRequest = false,
    bool clearFailure = false,
  }) {
    return AddressInfoState(
      capitals: capitals ?? this.capitals,
      cities: cities ?? this.cities,
      towns: towns ?? this.towns,
      loadingRequest: clearLoadingRequest
          ? null
          : loadingRequest ?? this.loadingRequest,
      failureRequest: clearFailure
          ? null
          : failureRequest ?? this.failureRequest,
      errorMessage: clearFailure ? null : errorMessage ?? this.errorMessage,
    );
  }
}
