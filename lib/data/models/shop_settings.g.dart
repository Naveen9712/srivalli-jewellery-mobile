// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopSettingsAdapter extends TypeAdapter<ShopSettings> {
  @override
  final int typeId = 3;

  @override
  ShopSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopSettings(
      shopName: fields[0] as String,
      gstNumber: fields[1] as String,
      address: fields[2] as String,
      phone: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.shopName)
      ..writeByte(1)
      ..write(obj.gstNumber)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
