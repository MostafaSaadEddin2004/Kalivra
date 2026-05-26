import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/ads_model.dart';

class AdsServices {
  final DioClient _client = DioClient();

  Future<List<AdsModel>> getAds() async {
    final res = await _client.get('advertisements');
    final data = (res.data['data'] as List)
        .map((e) => AdsModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return data;
  }
}
