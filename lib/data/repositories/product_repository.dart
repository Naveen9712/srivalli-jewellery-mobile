import 'package:hive/hive.dart';

import '../models/product.dart';

/// CRUD + soft-delete + search over the active and deleted product boxes.
class ProductRepository {
  ProductRepository({
    required Box<Product> products,
    required Box<Product> deleted,
  })  : _products = products,
        _deleted = deleted;

  final Box<Product> _products;
  final Box<Product> _deleted;

  // --- Reads ---------------------------------------------------------------

  List<Product> getAll() {
    final List<Product> items = _products.values.toList();
    items.sort((Product a, Product b) =>
        (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));
    return items;
  }

  List<Product> getDeleted() {
    final List<Product> items = _deleted.values.toList();
    items.sort((Product a, Product b) => (b.deletedAt ?? b.createdAt)
        .compareTo(a.deletedAt ?? a.createdAt));
    return items;
  }

  List<Product> getByCategory(String category) =>
      getAll().where((Product p) => p.category == category).toList();

  int countByCategory(String category) =>
      _products.values.where((Product p) => p.category == category).length;

  /// Searches both active and deleted boxes by id.
  Product? getById(String id) {
    return _products.get(id) ?? _deleted.get(id);
  }

  bool isActive(String id) => _products.containsKey(id);

  // --- Writes --------------------------------------------------------------

  Future<void> add(Product product) async {
    await _products.put(product.id, product);
  }

  Future<void> update(Product product) async {
    product.updatedAt = DateTime.now();
    await _products.put(product.id, product);
  }

  Future<void> softDelete(String id) async {
    final Product? p = _products.get(id);
    if (p == null) return;
    p.deletedAt = DateTime.now();
    await _deleted.put(p.id, p);
    await _products.delete(p.id);
  }

  Future<void> restore(String id) async {
    final Product? p = _deleted.get(id);
    if (p == null) return;
    p
      ..deletedAt = null
      ..updatedAt = DateTime.now();
    await _products.put(p.id, p);
    await _deleted.delete(p.id);
  }

  Future<void> permanentlyDelete(String id) async {
    await _deleted.delete(id);
    await _products.delete(id);
  }

  // --- Search --------------------------------------------------------------

  /// Ranked search across active products:
  ///   1. exact SKU (uniqueId) match
  ///   2. SKU prefix matches
  ///   3. case-insensitive contains across uniqueId/name/category/subCategory/metalType
  List<Product> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return getAll();

    final List<Product> exact = <Product>[];
    final List<Product> prefix = <Product>[];
    final List<Product> contains = <Product>[];

    for (final Product p in getAll()) {
      final String sku = p.uniqueId.toLowerCase();
      if (sku == q) {
        exact.add(p);
      } else if (sku.startsWith(q)) {
        prefix.add(p);
      } else if (_matches(p, q)) {
        contains.add(p);
      }
    }
    return <Product>[...exact, ...prefix, ...contains];
  }

  bool _matches(Product p, String q) {
    return p.uniqueId.toLowerCase().contains(q) ||
        p.name.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q) ||
        (p.subCategory?.toLowerCase().contains(q) ?? false) ||
        p.metalType.toLowerCase().contains(q);
  }
}
