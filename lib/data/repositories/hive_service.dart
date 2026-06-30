import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';
import '../models/invoice_settings.dart';
import '../models/product.dart';
import '../models/rates.dart';
import '../models/shop_settings.dart';

/// Initialises Hive, registers adapters and opens all boxes.
class HiveService {
  HiveService._();

  static Box<Product> get products => Hive.box<Product>(BoxNames.products);
  static Box<Product> get deletedProducts =>
      Hive.box<Product>(BoxNames.deletedProducts);
  static Box<Rates> get rates => Hive.box<Rates>(BoxNames.rates);
  static Box<ShopSettings> get settings =>
      Hive.box<ShopSettings>(BoxNames.settings);
  static Box<InvoiceSettings> get invoiceSettings =>
      Hive.box<InvoiceSettings>(BoxNames.invoiceSettings);

  static Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await Future.wait<void>(<Future<void>>[
      Hive.openBox<Product>(BoxNames.products),
      Hive.openBox<Product>(BoxNames.deletedProducts),
      Hive.openBox<Rates>(BoxNames.rates),
      Hive.openBox<ShopSettings>(BoxNames.settings),
      Hive.openBox<InvoiceSettings>(BoxNames.invoiceSettings),
    ]);
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(TypeIds.product)) {
      Hive.registerAdapter(ProductAdapter());
    }
    if (!Hive.isAdapterRegistered(TypeIds.rates)) {
      Hive.registerAdapter(RatesAdapter());
    }
    if (!Hive.isAdapterRegistered(TypeIds.rateHistoryEntry)) {
      Hive.registerAdapter(RateHistoryEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(TypeIds.shopSettings)) {
      Hive.registerAdapter(ShopSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(TypeIds.invoiceSettings)) {
      Hive.registerAdapter(InvoiceSettingsAdapter());
    }
  }
}
