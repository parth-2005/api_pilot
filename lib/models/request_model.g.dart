// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedRequestAdapter extends TypeAdapter<SavedRequest> {
  @override
  final int typeId = 0;

  @override
  SavedRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedRequest.fromJson(
      id: fields[0] as String,
      method: fields[1] as String,
      url: fields[2] as String,
      headersJson: fields[3] as String,
      queryParamsJson: fields[4] as String,
      body: fields[5] as String?,
      timestamp: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedRequest obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.method)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.headersJson)
      ..writeByte(4)
      ..write(obj.queryParamsJson)
      ..writeByte(5)
      ..write(obj.body)
      ..writeByte(6)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}