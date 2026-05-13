import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:kalivra/model/ads_model.dart';
import 'package:kalivra/model/services/api/ads_services.dart';
import 'package:meta/meta.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  AdsCubit() : super(AdsLoading());

  Future<void> fetchAds() async {
    emit(AdsLoading());
    try {
      final ads = await AdsServices().getAds();
      emit(AdsFetched(ads: ads));
    } on DioException catch (e) {
      emit(AdsFailed(errorMessage: e.toString()));
    }
  }
}
