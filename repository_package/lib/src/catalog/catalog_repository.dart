import 'package:repository_package/src/core/models/catalog/catalog_products_model.dart';

abstract class CatalogRepository {
  Future<List<CatalogProductMd>> getCatalog();
}