// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_record_hive_wrapper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobRecordWrapperAdapter extends TypeAdapter<JobRecordWrapper> {
  @override
  final int typeId = 1;

  @override
  JobRecordWrapper read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobRecordWrapper(
      (fields[0] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, JobRecordWrapper obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.jobRecordMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobRecordWrapperAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
