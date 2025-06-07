// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingsAdapter extends TypeAdapter<NotificationSettings> {
  @override
  final int typeId = 1;

  @override
  NotificationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSettings(
      isEnabled: fields[0] as bool,
      hour: fields[1] as int,
      minute: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isEnabled)
      ..writeByte(1)
      ..write(obj.hour)
      ..writeByte(2)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
