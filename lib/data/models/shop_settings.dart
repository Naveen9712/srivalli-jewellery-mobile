import 'package:hive/hive.dart';

import '../../core/constants/constants.dart';

part 'shop_settings.g.dart';

/// Shop identity details shown on invoices and the dashboard.
@HiveType(typeId: TypeIds.shopSettings)
class ShopSettings {
  ShopSettings({
    required this.shopName,
    required this.gstNumber,
    required this.address,
    required this.phone,
  });

  @HiveField(0)
  String shopName;

  @HiveField(1)
  String gstNumber;

  @HiveField(2)
  String address;

  @HiveField(3)
  String phone;

  ShopSettings copyWith({
    String? shopName,
    String? gstNumber,
    String? address,
    String? phone,
  }) {
    return ShopSettings(
      shopName: shopName ?? this.shopName,
      gstNumber: gstNumber ?? this.gstNumber,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }
}
