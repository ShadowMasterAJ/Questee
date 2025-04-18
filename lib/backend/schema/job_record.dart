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

  @BuiltValueField(wireName: 'verifiedByPoster')
  bool? get verifiedByPoster;

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
    ..verifiedByPoster = false
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
      Map<String, dynamic> data, DocumentReference reference) {
    if (data['del_time'] is Timestamp) {
      final Timestamp timestamp = data['del_time'] as Timestamp;
      data['del_time'] = timestamp.toDate();
    }
    return serializers.deserializeWith(serializer,
        {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
  }
}

Map<String, dynamic> createJobRecordData(
    {String? type,
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
    // ignore: non_constant_identifier_names
    bool? verifiedByPoster}) {
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
      ..verifiedByPoster = verifiedByPoster
      ..acceptorID = acceptorID;

    if (items != null) j.items.addAll(items);

    if (verificationImages != null)
      j.verificationImages.addAll(verificationImages);
  }));

  return firestoreData;
}
