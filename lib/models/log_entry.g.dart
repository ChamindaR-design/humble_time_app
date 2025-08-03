// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogEntryAdapter extends TypeAdapter<LogEntry> {
  @override
  final int typeId = 1;

  @override
  LogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogEntry(
      startTime: fields[0] as DateTime,
      endTime: fields[1] as DateTime,
      blockType: fields[2] as LogBlockType,
      usedVoicePrompts: fields[3] as bool,
      note: fields[4] as String?,
      tags: (fields[5] as List?)?.cast<String>(),
      mood: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LogEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.blockType)
      ..writeByte(3)
      ..write(obj.usedVoicePrompts)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.mood);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LogBlockTypeAdapter extends TypeAdapter<LogBlockType> {
  @override
  final int typeId = 0;

  @override
  LogBlockType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LogBlockType.focusBlock;
      case 1:
        return LogBlockType.breakBlock;
      case 2:
        return LogBlockType.defaultBlock;
      case 3:
        return LogBlockType.meditation;
      case 4:
        return LogBlockType.other;
      default:
        return LogBlockType.focusBlock;
    }
  }

  @override
  void write(BinaryWriter writer, LogBlockType obj) {
    switch (obj) {
      case LogBlockType.focusBlock:
        writer.writeByte(0);
        break;
      case LogBlockType.breakBlock:
        writer.writeByte(1);
        break;
      case LogBlockType.defaultBlock:
        writer.writeByte(2);
        break;
      case LogBlockType.meditation:
        writer.writeByte(3);
        break;
      case LogBlockType.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogBlockTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
