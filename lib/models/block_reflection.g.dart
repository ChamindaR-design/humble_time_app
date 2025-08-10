// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_reflection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlockReflectionAdapter extends TypeAdapter<BlockReflection> {
  @override
  final int typeId = 0;

  @override
  BlockReflection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlockReflection(
      hour: fields[0] as int,
      note: fields[1] as String?,
      mood: fields[2] as String?,
      label: fields[3] as String?,
      timestamp: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BlockReflection obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.mood)
      ..writeByte(3)
      ..write(obj.label)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockReflectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
