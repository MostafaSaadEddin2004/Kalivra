import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_state.dart';
import 'package:kalivra/model/services/api/product_api_service.dart';

export 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsLoading());

  final ProductApiService  _productService = ProductApiService();

  

Future<void> loadProducts({int? categoryId}) async {
    emit(ProductsLoading());
    try {
      final products = await _productService.getProducts(categoryId: categoryId);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsFailed(message: e.toString()));
    }
  }

Future<void> loadAll() async {
     emit(ProductsLoading());
    try {
      final products = await _productService.getProducts();
    emit(ProductsLoaded(products: products));
    } catch (e) {
       emit(ProductsFailed(message: e.toString()));
    }
  }

  Future<void> loadProductById(int productId) async {
   emit(ProductsLoading());
    try {
      final product = await _productService.getProductById(productId);
    emit(OneProductLoaded(product: product));
    } catch (e) {
       emit(ProductsFailed(message: e.toString()));
    }
  }
}
