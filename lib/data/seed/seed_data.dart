import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/id_generator.dart';
import '../models/invoice_settings.dart';
import '../models/product.dart';
import '../models/rates.dart';
import '../models/shop_settings.dart';
import '../repositories/product_repository.dart';
import '../repositories/settings_repository.dart';

/// Seeds first-run demo data, gated by a shared_preferences flag.
class SeedData {
  SeedData._();

  static Future<void> ensureSeeded({
    required ProductRepository products,
    required SettingsRepository settings,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool seeded = prefs.getBool(BoxNames.prefSeeded) ?? false;

    // Always make sure settings records exist (safe fallback).
    if (settings.getRates() == null) {
      await settings.setRates(_defaultRates());
    }
    if (settings.getShop() == null) {
      await settings.setShop(_defaultShop());
    }
    if (settings.getInvoice() == null) {
      await settings.setInvoice(_defaultInvoice());
    }

    if (seeded) return;

    for (final Product p in _demoProducts()) {
      await products.add(p);
    }
    await prefs.setBool(BoxNames.prefSeeded, true);
  }

  static Rates _defaultRates() => Rates(
        gold18k: 4850,
        gold22k: 5920,
        gold24k: 6480,
        silver925: 82,
        lastUpdated: DateTime.now(),
      );

  static ShopSettings _defaultShop() => ShopSettings(
        shopName: 'Srivalli jewellers',
        gstNumber: '37AABCS1234F1Z5',
        address: 'Main Road, Vijayawada, Andhra Pradesh',
        phone: '+91 98765 43210',
      );

  static InvoiceSettings _defaultInvoice() => InvoiceSettings(
        prefix: 'SJ',
        footerText:
            'Thank you for shopping with Srivalli Jewellers. Goods once sold are subject to store policy.',
        showHuid: true,
        showGst: true,
      );

  static List<Product> _demoProducts() {
    final DateTime now = DateTime.now();
    int seq = 0;
    Product make({
      required String name,
      required String category,
      String? subCategory,
      required String metalType,
      required String carat,
      required double netWeight,
      double? grossWeight,
      double? sellingPrice,
      String status = AppData.statusInStock,
      String? huid,
      int daysAgo = 0,
    }) {
      final String sku = generateSku(
        category: category,
        carat: carat,
        currentProductCount: seq++,
      );
      return Product(
        id: generateUuid(),
        uniqueId: sku,
        name: name,
        category: category,
        subCategory: subCategory,
        metalType: metalType,
        carat: carat,
        grossWeight: grossWeight,
        netWeight: netWeight,
        sellingPrice: sellingPrice,
        huid: huid,
        status: status,
        createdAt: now.subtract(Duration(days: daysAgo)),
      );
    }

    return <Product>[
      make(
        name: 'Classic Wedding Band',
        category: 'Ring',
        subCategory: 'Wedding Ring',
        metalType: 'Gold',
        carat: '22K',
        grossWeight: 5.450,
        netWeight: 5.250,
        sellingPrice: 38000,
        huid: 'HUA1B2C3',
        daysAgo: 12,
      ),
      make(
        name: 'Solitaire Engagement Ring',
        category: 'Ring',
        subCategory: 'Engagement Ring',
        metalType: 'Gold',
        carat: '18K',
        grossWeight: 3.420,
        netWeight: 3.100,
        sellingPrice: 52000,
        status: AppData.statusLowStock,
        daysAgo: 8,
      ),
      make(
        name: 'Lakshmi Long Necklace',
        category: 'Necklace',
        subCategory: 'Long Necklace',
        metalType: 'Gold',
        carat: '22K',
        grossWeight: 39.200,
        netWeight: 38.500,
        sellingPrice: 245000,
        huid: 'HUX9Y8Z7',
        daysAgo: 20,
      ),
      make(
        name: 'Daily Wear Gold Chain',
        category: 'Chain',
        subCategory: 'Gold Chain',
        metalType: 'Gold',
        carat: '22K',
        netWeight: 12.800,
        sellingPrice: 82000,
        daysAgo: 5,
      ),
      make(
        name: 'Ghungroo Silver Anklet',
        category: 'Anklet',
        subCategory: 'Designer',
        metalType: 'Silver',
        carat: 'Silver 925',
        netWeight: 52.300,
        sellingPrice: 5200,
        daysAgo: 3,
      ),
      make(
        name: 'Pure Silver Coin 10g',
        category: 'Coin',
        subCategory: 'Silver Coin',
        metalType: 'Silver',
        carat: 'Silver 925',
        netWeight: 10.000,
        sellingPrice: 950,
        daysAgo: 1,
      ),
    ];
  }
}
