// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rates.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RateHistoryEntryAdapter extends TypeAdapter<RateHistoryEntry> {
  @override
  final int typeId = 2;

  @override
  RateHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RateHistoryEntry(
      date: fields[0] as DateTime,
      gold22k: (fields[1] as num).toDouble(),
      silver925: (fields[2] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, RateHistoryEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.gold22k)
      ..writeByte(2)
      ..write(obj.silver925);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RatesAdapter extends TypeAdapter<Rates> {
  @override
  final int typeId = 1;

  @override
  Rates read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rates(
      gold18k: (fields[0] as num).toDouble(),
      gold22k: (fields[1] as num).toDouble(),
      gold24k: (fields[2] as num).toDouble(),
      silver925: (fields[3] as num).toDouble(),
      lastUpdated: fields[4] as DateTime,
      rateHistory: (fields[5] as List?)?.cast<RateHistoryEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, Rates obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.gold18k)
      ..writeByte(1)
      ..write(obj.gold22k)
      ..writeByte(2)
      ..write(obj.gold24k)
      ..writeByte(3)
      ..write(obj.silver925)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.rateHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
