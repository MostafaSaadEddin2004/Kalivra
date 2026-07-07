import 'package:bloc/bloc.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/services/api/brand_service.dart';
import 'package:meta/meta.dart';

part 'brand_state.dart';

class BrandCubit extends Cubit<BrandState> {
  BrandCubit() : super(BrandLoading());

  Future<void> fetchAllBrands() async {
    try {
      emit(BrandLoading());
      final brands = await BrandApiService().getAllBrands();
      emit(BrandsFetched(brands));
    } catch (e) {
      emit(BrandFailure(e.toString()));
    }
  }

  Future<void> fetchBrandById(int brandId) async {
    try {
      emit(BrandLoading());
      final brand = await BrandApiService().getBrandById(brandId);
      emit(OneBrandFetched(brand));
    } catch (e) {
      emit(BrandFailure(e.toString()));
    }
  }

  Future<void> fetchProductsByBrandId(int brandId) async {
    try {
      emit(BrandProductsLoading());
      final products = await BrandApiService().getProductsByBrandId(brandId);
      emit(BrandProductFetched(products));
    } catch (e) {
      emit(BrandProductsFailure(e.toString()));
    }
  }
}
