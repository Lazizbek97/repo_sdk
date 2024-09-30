import 'package:repository_package/src/catalog/catalog_repository.dart';
import 'package:repository_package/src/core/models/catalog/catalog_products_model.dart';
import 'package:repository_package/src/dio_rest_client.dart';

class CatalogRepositoryImpl extends CatalogRepository {
  final DioRestClient _client;
  CatalogRepositoryImpl({required DioRestClient client}) : _client = client;

  @override
  Future<List<CatalogProductMd>> getCatalog() async {
    final response = await _client.get<List<dynamic>>('/products');
    return response.map((json) => CatalogProductMd.fromJson(json)).toList();
  }
}
