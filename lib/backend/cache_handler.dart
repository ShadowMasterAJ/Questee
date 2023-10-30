import 'package:hive_flutter/adapters.dart';

import 'schema/docref_hive_adapter.dart';
import 'schema/job_record_hive_wrapper.dart';
import 'schema/serializers.dart';
import 'schema/job_record.dart';

class CacheHandler {
  static const String _boxName = 'jobsCache';

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(JobRecordWrapperAdapter());
    Hive.registerAdapter(DocumentReferenceAdapter());
  }

  static Future<void> cacheJobs(List<JobRecord> jobs) async {
    final box = await Hive.openBox(_boxName); // Corrected the generic type

    // Get the current list of cached jobs
    List? currentJobWrappers = box.get('cachedJobs');

    if (currentJobWrappers == null) currentJobWrappers = [];

    final newJobWrappers = jobs
        .map((job) => JobRecordWrapper(serializers.serializeWith(
            JobRecord.serializer, job) as Map<String, dynamic>))
        .toList();

    // Append the new jobs to the current list of cached jobs
    currentJobWrappers.addAll(newJobWrappers);

    await box.put('cachedJobs',
        currentJobWrappers); // Store the updated list of JobRecordWrapper objects with the key 'cachedJobs'
    await box.close();
  }

  static Future<List<JobRecord>?> getCachedJobs() async {
    final box = await Hive.openBox(_boxName);
    final cachedData = box.get('cachedJobs');
    await box.close();
    if (cachedData is List) {
      final cachedJobWrappers = cachedData.cast<JobRecordWrapper>();
      return cachedJobWrappers.map((wrapper) => wrapper.jobRecord).toList();
    }
    return null;
  }

  static Future<void> clearJobsCache() async {
    final box = await Hive.openBox(_boxName);
    await box.clear(); // This will clear all entries in the box
  }
}
