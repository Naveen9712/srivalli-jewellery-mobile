/// Domain constants for Srivalli Jewellers (categories, metals, carats, SKU map).
class AppData {
  AppData._();

  /// Ordered list of product categories.
  static const List<String> categories = <String>[
    'Ring',
    'Necklace',
    'Bangle',
    'Chain',
    'Earring',
    'Pendant',
    'Bracelet',
    'Anklet',
    'Coin',
    'Other',
  ];

  /// Sub-categories per category (exact spec).
  static const Map<String, List<String>> subCategories = <String, List<String>>{
    'Ring': <String>['Wedding Ring', 'Engagement Ring', 'Casual Ring'],
    'Necklace': <String>['Short Necklace', 'Long Necklace', 'Choker'],
    'Bangle': <String>['Plain Bangle', 'Stone Bangle', 'Kada'],
    'Chain': <String>['Gold Chain', 'Mangalsutra Chain'],
    'Earring': <String>['Stud', 'Jhumka', 'Drop'],
    'Pendant': <String>['Religious', 'Designer'],
    'Bracelet': <String>['Kids', 'Adult'],
    'Anklet': <String>['Plain', 'Designer'],
    'Coin': <String>['Gold Coin', 'Silver Coin'],
    'Other': <String>['Miscellaneous'],
  };

  /// Metals.
  static const List<String> metals = <String>['Gold', 'Silver'];

  /// Carat options per metal.
  static const Map<String, List<String>> caratsByMetal = <String, List<String>>{
    'Gold': <String>['18K', '22K', '24K'],
    'Silver': <String>['Silver 925'],
  };

  /// Flattened carat list (handy for some dropdowns).
  static const List<String> goldCarats = <String>['18K', '22K', '24K'];
  static const List<String> silverCarats = <String>['Silver 925'];

  /// SKU prefix per category.
  static const Map<String, String> skuPrefix = <String, String>{
    'Ring': 'RNG',
    'Necklace': 'NCK',
    'Bangle': 'BNG',
    'Chain': 'CHN',
    'Earring': 'ERG',
    'Pendant': 'PND',
    'Bracelet': 'BRC',
    'Anklet': 'ANK',
    'Coin': 'CON',
    'Other': 'OTH',
  };

  /// Product status values.
  static const String statusInStock = 'In Stock';
  static const String statusLowStock = 'Low Stock';
  static const List<String> statuses = <String>[statusInStock, statusLowStock];

  /// Returns carats valid for a given metal, defaulting to gold.
  static List<String> caratsFor(String metal) =>
      caratsByMetal[metal] ?? goldCarats;

  /// Lowercased category -> asset path (used with a graceful fallback).
  static String categoryAsset(String category) =>
      'assets/categories/${category.toLowerCase()}.png';
}

/// Hive box names + single-record keys + prefs flags.
class BoxNames {
  BoxNames._();

  static const String products = 'products';
  static const String deletedProducts = 'deletedProducts';
  static const String rates = 'rates';
  static const String settings = 'settings';
  static const String invoiceSettings = 'invoiceSettings';

  // Single-record keys
  static const String ratesKey = 'rates';
  static const String shopKey = 'shop';
  static const String invoiceKey = 'invoice';

  // shared_preferences flags
  static const String prefSeeded = 'seeded_v1';
}

/// Hive type ids (stable across versions).
class TypeIds {
  TypeIds._();
  static const int product = 0;
  static const int rates = 1;
  static const int rateHistoryEntry = 2;
  static const int shopSettings = 3;
  static const int invoiceSettings = 4;
}
