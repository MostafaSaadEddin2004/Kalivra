import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/customer/address_api_model.dart';

class AddressApiService {
  AddressApiService(this._client);
  final DioClient _client;

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
    final res = await _client.post(
      'customer/addresses',
      data: body,
    );
    final data = res.data['data'];
    if (data is Map<String, dynamic>) {
      return AddressApiModel.fromJson(data);
    }
    return null;
  }
}
