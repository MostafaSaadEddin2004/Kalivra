import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/address/capiltal_model.dart';
import 'package:kalivra/model/address/city_model.dart';
import 'package:kalivra/model/address/town_model.dart';
import 'package:kalivra/model/customer/address_api_model.dart';

class AddressInfoServices {
  final DioClient _client = DioClient();

  Future<List<CapitalModel>> getCapitals() async {
    final res = await _client.get('address/capitals');
    final data = res.data['data'];
    return _parseList(data, CapitalModel.fromJson);
  }

  Future<List<CityModel>> getCities({required String capitalId}) async {
    final res = await _client.get('address/capitals');
    final data = res.data['data'];
    return _parseList(data, CityModel.fromJson);
  }

  Future<List<TownModel>> getTowns({required String cityId}) async {
    final res = await _client.get('address/capitals');
    final data = res.data['data'];
    return _parseList(data, TownModel.fromJson);
  }

  Future<List<AddressApiModel>> getAddresses() async {
    final res = await _client.get('customer/addresses');
    final data = res.data['data'];
    if (data is List) {
      return data
          .map((e) => AddressApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<AddressApiModel?> createAddress(Map<String, dynamic> body) async {
    final res = await _client.post('customer/addresses', data: body);
    final data = res.data['data'];
    if (data is Map<String, dynamic>) {
      return AddressApiModel.fromJson(data);
    }
    return null;
  }

  List<T> _parseList<T>(
    Object? data,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(fromJson).toList();
    }

    if (data is Map<String, dynamic>) {
      return [fromJson(data)];
    }

    return [];
  }
}
