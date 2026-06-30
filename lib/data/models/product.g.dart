// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      uniqueId: fields[1] as String,
      name: fields[2] as String,
      category: fields[3] as String,
      subCategory: fields[4] as String?,
      metalType: fields[5] as String,
      carat: fields[6] as String,
      grossWeight: (fields[7] as num?)?.toDouble(),
      netWeight: (fields[8] as num).toDouble(),
      stoneWeight: (fields[9] as num?)?.toDouble(),
      wastage: (fields[10] as num?)?.toDouble(),
      makingCharges: (fields[11] as num?)?.toDouble(),
      purchasePrice: (fields[12] as num?)?.toDouble(),
      sellingPrice: (fields[13] as num?)?.toDouble(),
      quantity: fields[14] == null ? 1 : fields[14] as int,
      huid: fields[15] as String?,
      designCode: fields[16] as String?,
      vendor: fields[17] as String?,
      status: fields[18] == null ? 'In Stock' : fields[18] as String,
      imagePath: fields[19] as String?,
      createdAt: fields[20] as DateTime,
      updatedAt: fields[21] as DateTime?,
      deletedAt: fields[22] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uniqueId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.subCategory)
      ..writeByte(5)
      ..write(obj.metalType)
      ..writeByte(6)
      ..write(obj.carat)
      ..writeByte(7)
      ..write(obj.grossWeight)
      ..writeByte(8)
      ..write(obj.netWeight)
      ..writeByte(9)
      ..write(obj.stoneWeight)
      ..writeByte(10)
      ..write(obj.wastage)
      ..writeByte(11)
      ..write(obj.makingCharges)
      ..writeByte(12)
      ..write(obj.purchasePrice)
      ..writeByte(13)
      ..write(obj.sellingPrice)
      ..writeByte(14)
      ..write(obj.quantity)
      ..writeByte(15)
      ..write(obj.huid)
      ..writeByte(16)
      ..write(obj.designCode)
      ..writeByte(17)
      ..write(obj.vendor)
      ..writeByte(18)
      ..write(obj.status)
      ..writeByte(19)
      ..write(obj.imagePath)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt)
      ..writeByte(22)
      ..write(obj.deletedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
