// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockAdapter extends TypeAdapter<Stock> {
  @override
  final int typeId = 1;

  @override
  Stock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stock(
      id: fields[0] as String,
      warehouse: fields[1] as String,
      gtin: fields[2] as String,
      quantity: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Stock obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.warehouse)
      ..writeByte(2)
      ..write(obj.gtin)
      ..writeByte(3)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
