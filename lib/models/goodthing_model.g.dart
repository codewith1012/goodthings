// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goodthing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoodthingModelAdapter extends TypeAdapter<GoodthingModel> {
  @override
  final typeId = 0;

  @override
  GoodthingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoodthingModel(
      title: fields[1] as String,
      dateTime: fields[2] as DateTime,
      content: fields[3] as String,
      serialNo: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GoodthingModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.serialNo)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoodthingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
