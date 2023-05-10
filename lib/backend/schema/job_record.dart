import 'dart:async';

import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'job_record.g.dart';

abstract class JobRecord implements Built<JobRecord, JobRecordBuilder> {
  static Serializer<JobRecord> get serializer => _$jobRecordSerializer;
  @BuiltValueField(wireName: 'type')
  String? get type;

  @BuiltValueField(wireName: 'note')
  String? get note;

  @BuiltValueField(wireName: 'store')
  String? get store;

  @BuiltValueField(wireName: 'del_location')
  String? get delLocation;

  @BuiltValueField(wireName: 'price')
  double? get price;

  @BuiltValueField(wireName: 'status')
  String? get status;

  @BuiltValueField(wireName: 'del_time')
  DateTime? get delTime;

  @BuiltValueField(wireName: 'items')
  BuiltList<String>? get items;

  @BuiltValueField(wireName: 'verificationImages')
  BuiltList<String>? get verificationImages;

  @BuiltValueField(wireName: 'item_quantity')
  int? get itemQuantity;

  @BuiltValueField(wireName: 'posterID')
  DocumentReference? get posterID;
  @BuiltValueField(wireName: 'acceptorID')
  DocumentReference? get acceptorID;

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
    ..verificationImages = ListBuilder();

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
  List<String>? verificationImages,
}) {
  final firestoreData =
      serializers.toFirestore(JobRecord.serializer, JobRecord((j) {
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
      ..acceptorID = acceptorID;

    var s = items;
    int len = s != null ? s.length : 0; // Safe
    for (int i = 0; i < len; i++) j.items.add(items![i]);

    var s2 = verificationImages;
    int len2 = s2 != null ? s2.length : 0; // Safe
    for (int i = 0; i < len2; i++)
      j.verificationImages.add(verificationImages![i]);
  }));

  return firestoreData;
}
