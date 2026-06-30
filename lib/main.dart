import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/repositories/hive_service.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/seed/seed_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive, register adapters and open all boxes.
  await HiveService.init();

  // Seed first-run data (gated by a shared_preferences flag) and ensure
  // settings records always exist.
  await SeedData.ensureSeeded(
    products: ProductRepository(
      products: HiveService.products,
      deleted: HiveService.deletedProducts,
    ),
    settings: SettingsRepository(
      rates: HiveService.rates,
      shop: HiveService.settings,
      invoice: HiveService.invoiceSettings,
    ),
  );

  runApp(const ProviderScope(child: SrivalliApp()));
}
