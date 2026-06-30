// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceSettingsAdapter extends TypeAdapter<InvoiceSettings> {
  @override
  final int typeId = 4;

  @override
  InvoiceSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceSettings(
      prefix: fields[0] as String,
      footerText: fields[1] as String,
      showHuid: fields[2] == null ? true : fields[2] as bool,
      showGst: fields[3] == null ? true : fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.prefix)
      ..writeByte(1)
      ..write(obj.footerText)
      ..writeByte(2)
      ..write(obj.showHuid)
      ..writeByte(3)
      ..write(obj.showGst);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
