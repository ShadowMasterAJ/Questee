import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'job_record.g.dart';

abstract class JobRecord implements Built<JobRecord, JobRecordBuilder> {
  static Serializer<JobRecord> get serializer => _$jobRecordSerializer;

  String? get type;

  String? get note;

  String? get store;

  @BuiltValueField(wireName: 'del_location')
  String? get delLocation;

  double? get price;

  String? get status;

  @BuiltValueField(wireName: 'del_time')
  DateTime? get delTime;

  BuiltList<String>? get items;

  @BuiltValueField(wireName: 'item_quantity')
  int? get itemQuantity;

  DocumentReference? get posterID;

  DocumentReference? get acceptorID;

  @BuiltValueField(wireName: 'temp_item_list')
  BuiltList<String>? get tempItemList;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(JobRecordBuilder builder) => builder
    ..type = ''
    ..note = ''
    ..store = ''
    ..delLocation = ''
    ..price = 0.0
    ..status = ''
    ..items = ListBuilder()
    ..itemQuantity = 0
    ..tempItemList = ListBuilder();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('job');

  static Stream<JobRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<JobRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  JobRecord._();
  factory JobRecord([void Function(JobRecordBuilder) updates]) = _$JobRecord;

  static JobRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createJobRecordData({
  String? type,
  String? note,
  String? store,
  String? delLocation,
  double? price,
  String? status,
  DateTime? delTime,
  int? itemQuantity,
  List<String>? items,
  DocumentReference? posterID,
  DocumentReference? acceptorID,
}) {
  final firestoreData = serializers.toFirestore(
    JobRecord.serializer,
    JobRecord((j) {
      j
        ..type = type
        ..note = note
        ..store = store
        ..delLocation = delLocation
        ..price = price
        ..status = status
        ..delTime = delTime
        ..itemQuantity = itemQuantity
        ..posterID = posterID
        ..acceptorID = acceptorID
        ..tempItemList = null;

      for (int i = 0; i < items!.length; i++) {
        j.items.add(items[i]);
      }
    }),
  );

  return firestoreData;
}
