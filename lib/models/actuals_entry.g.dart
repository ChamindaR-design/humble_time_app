// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actuals_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActualsEntryAdapter extends TypeAdapter<ActualsEntry> {
  @override
  final int typeId = 7;

  @override
  ActualsEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActualsEntry(
      text: fields[0] as String,
      createdAt: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ActualsEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActualsEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
