import 'package:hive/hive.dart';

import '../../core/constants/constants.dart';

part 'product.g.dart';

/// A single inventory item (one SKU/tag).
@HiveType(typeId: TypeIds.product)
class Product {
  Product({
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.category,
    this.subCategory,
    required this.metalType,
    required this.carat,
    this.grossWeight,
    required this.netWeight,
    this.stoneWeight,
    this.wastage,
    this.makingCharges,
    this.purchasePrice,
    this.sellingPrice,
    this.quantity = 1,
    this.huid,
    this.designCode,
    this.vendor,
    this.status = AppData.statusInStock,
    this.imagePath,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  String uniqueId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String category;

  @HiveField(4)
  String? subCategory;

  @HiveField(5)
  String metalType;

  @HiveField(6)
  String carat;

  @HiveField(7)
  double? grossWeight;

  @HiveField(8)
  double netWeight;

  @HiveField(9)
  double? stoneWeight;

  @HiveField(10)
  double? wastage;

  @HiveField(11)
  double? makingCharges;

  @HiveField(12)
  double? purchasePrice;

  @HiveField(13)
  double? sellingPrice;

  @HiveField(14)
  int quantity;

  @HiveField(15)
  String? huid;

  @HiveField(16)
  String? designCode;

  @HiveField(17)
  String? vendor;

  @HiveField(18)
  String status;

  @HiveField(19)
  String? imagePath;

  @HiveField(20)
  DateTime createdAt;

  @HiveField(21)
  DateTime? updatedAt;

  @HiveField(22)
  DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
  bool get isLowStock => status == AppData.statusLowStock;

  Product copyWith({
    String? uniqueId,
    String? name,
    String? category,
    String? subCategory,
    bool clearSubCategory = false,
    String? metalType,
    String? carat,
    double? grossWeight,
    double? netWeight,
    double? stoneWeight,
    double? wastage,
    double? makingCharges,
    double? purchasePrice,
    double? sellingPrice,
    int? quantity,
    String? huid,
    String? designCode,
    String? vendor,
    String? status,
    String? imagePath,
    bool clearImagePath = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Product(
      id: id,
      uniqueId: uniqueId ?? this.uniqueId,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory:
          clearSubCategory ? null : (subCategory ?? this.subCategory),
      metalType: metalType ?? this.metalType,
      carat: carat ?? this.carat,
      grossWeight: grossWeight ?? this.grossWeight,
      netWeight: netWeight ?? this.netWeight,
      stoneWeight: stoneWeight ?? this.stoneWeight,
      wastage: wastage ?? this.wastage,
      makingCharges: makingCharges ?? this.makingCharges,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      huid: huid ?? this.huid,
      designCode: designCode ?? this.designCode,
      vendor: vendor ?? this.vendor,
      status: status ?? this.status,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
