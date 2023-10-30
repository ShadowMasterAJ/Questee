import 'package:hive/hive.dart';
import 'package:u_grabv1/backend/schema/serializers.dart';

import 'job_record.dart';

part 'job_record_hive_wrapper.g.dart';

@HiveType(typeId: 1)
class JobRecordWrapper extends HiveObject {
  @HiveField(0)
  Map<String, dynamic> jobRecordMap;

  JobRecordWrapper(this.jobRecordMap);
  JobRecord get jobRecord {
    return serializers.deserializeWith(JobRecord.serializer, this.jobRecordMap)
        as JobRecord;
  }

  set jobRecord(JobRecord jobRecord) {
    this.jobRecordMap = serializers.serializeWith(
        JobRecord.serializer, jobRecord) as Map<String, dynamic>;
  }
}
