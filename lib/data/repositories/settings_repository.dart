import 'package:hive/hive.dart';

import '../../core/constants/constants.dart';
import '../models/invoice_settings.dart';
import '../models/rates.dart';
import '../models/shop_settings.dart';

/// Reads/writes the single-record settings boxes (rates, shop, invoice).
class SettingsRepository {
  SettingsRepository({
    required Box<Rates> rates,
    required Box<ShopSettings> shop,
    required Box<InvoiceSettings> invoice,
  })  : _rates = rates,
        _shop = shop,
        _invoice = invoice;

  final Box<Rates> _rates;
  final Box<ShopSettings> _shop;
  final Box<InvoiceSettings> _invoice;

  // --- Rates ---------------------------------------------------------------

  Rates? getRates() => _rates.get(BoxNames.ratesKey);

  Future<void> setRates(Rates rates) async =>
      _rates.put(BoxNames.ratesKey, rates);

  /// Saves new rates, pushing the *previous* headline values into history.
  Future<void> updateRates({
    required double gold18k,
    required double gold22k,
    required double gold24k,
    required double silver925,
  }) async {
    final Rates? current = getRates();
    final List<RateHistoryEntry> history = <RateHistoryEntry>[
      ...?current?.rateHistory,
    ];
    if (current != null) {
      history.add(RateHistoryEntry(
        date: current.lastUpdated,
        gold22k: current.gold22k,
        silver925: current.silver925,
      ));
    }
    await setRates(
      Rates(
        gold18k: gold18k,
        gold22k: gold22k,
        gold24k: gold24k,
        silver925: silver925,
        lastUpdated: DateTime.now(),
        rateHistory: history,
      ),
    );
  }

  // --- Shop ----------------------------------------------------------------

  ShopSettings? getShop() => _shop.get(BoxNames.shopKey);

  Future<void> setShop(ShopSettings shop) async =>
      _shop.put(BoxNames.shopKey, shop);

  // --- Invoice -------------------------------------------------------------

  InvoiceSettings? getInvoice() => _invoice.get(BoxNames.invoiceKey);

  Future<void> setInvoice(InvoiceSettings invoice) async =>
      _invoice.put(BoxNames.invoiceKey, invoice);
}
