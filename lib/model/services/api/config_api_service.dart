import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/config/configuration_api_model.dart';

class ConfigApiService {
  ConfigApiService(this._client);
  final DioClient _client;

  Future<ConfigurationApiModel?> getConfigurations() async {
    final res = await _client.get('configurations');
    if (res.data['data'] != null) {
      return ConfigurationApiModel.fromJson(res.data['data'] as Map<String, dynamic>);
    }
    return ConfigurationApiModel.fromJson(res.data);
  }
}
