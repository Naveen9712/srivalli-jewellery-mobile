import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/models/invoice_settings.dart';
import '../../data/models/product.dart';
import '../../data/models/rates.dart';
import '../../data/models/shop_settings.dart';
import '../../data/repositories/hive_service.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/settings_repository.dart';

/// --- Repositories ---------------------------------------------------------

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    products: HiveService.products,
    deleted: HiveService.deletedProducts,
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    rates: HiveService.rates,
    shop: HiveService.settings,
    invoice: HiveService.invoiceSettings,
  );
});

/// --- Box change ticks (drive reactivity) ---------------------------------

Stream<int> _ticks<T>(Box<T> box) async* {
  yield 0;
  int n = 0;
  await for (final BoxEvent _ in box.watch()) {
    yield ++n;
  }
}

final productsTickProvider = StreamProvider<int>(
    (ref) => _ticks<Product>(HiveService.products));
final deletedTickProvider = StreamProvider<int>(
    (ref) => _ticks<Product>(HiveService.deletedProducts));
final ratesTickProvider =
    StreamProvider<int>((ref) => _ticks<Rates>(HiveService.rates));
final shopTickProvider = StreamProvider<int>(
    (ref) => _ticks<ShopSettings>(HiveService.settings));
final invoiceTickProvider = StreamProvider<int>(
    (ref) => _ticks<InvoiceSettings>(HiveService.invoiceSettings));

/// --- Product lists --------------------------------------------------------

final productsProvider = Provider<List<Product>>((ref) {
  ref.watch(productsTickProvider);
  return ref.watch(productRepositoryProvider).getAll();
});

final deletedProductsProvider = Provider<List<Product>>((ref) {
  ref.watch(deletedTickProvider);
  return ref.watch(productRepositoryProvider).getDeleted();
});

final productsByCategoryProvider =
    Provider.family<List<Product>, String>((ref, category) {
  ref.watch(productsTickProvider);
  return ref.watch(productRepositoryProvider).getByCategory(category);
});

final categoryCountProvider = Provider.family<int, String>((ref, category) {
  ref.watch(productsTickProvider);
  return ref.watch(productRepositoryProvider).countByCategory(category);
});

/// Looks in both boxes; rebuilds on either change.
final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  ref.watch(productsTickProvider);
  ref.watch(deletedTickProvider);
  return ref.watch(productRepositoryProvider).getById(id);
});

/// --- Search ---------------------------------------------------------------

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<Product>>((ref) {
  ref.watch(productsTickProvider);
  final String q = ref.watch(searchQueryProvider);
  return ref.watch(productRepositoryProvider).search(q);
});

/// --- Settings -------------------------------------------------------------

final ratesProvider = Provider<Rates?>((ref) {
  ref.watch(ratesTickProvider);
  return ref.watch(settingsRepositoryProvider).getRates();
});

final shopSettingsProvider = Provider<ShopSettings?>((ref) {
  ref.watch(shopTickProvider);
  return ref.watch(settingsRepositoryProvider).getShop();
});

final invoiceSettingsProvider = Provider<InvoiceSettings?>((ref) {
  ref.watch(invoiceTickProvider);
  return ref.watch(settingsRepositoryProvider).getInvoice();
});

/// Total non-deleted item count (for the dashboard empty-state gate).
final totalItemCountProvider = Provider<int>((ref) {
  return ref.watch(productsProvider).length;
});
