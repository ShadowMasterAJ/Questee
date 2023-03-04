import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'users_record.g.dart';

// TODO: implement attributes jobsAccepted and jobsPosted, pastJobsAccepted and pastJobsPosted

abstract class UsersRecord implements Built<UsersRecord, UsersRecordBuilder> {
  static Serializer<UsersRecord> get serializer => _$usersRecordSerializer;

  String? get email;

  @BuiltValueField(wireName: 'display_name')
  String? get displayName;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  String? get uid;

  @BuiltValueField(wireName: 'created_time')
  DateTime? get createdTime;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  // @BuiltValueField(wireName: 'past_jobs')
  // BuiltList<DocumentReference>? get pastJobs;

  @BuiltValueField(wireName: 'curr_jobs_accepted')
  BuiltList<DocumentReference>? get currJobsAccepted;

  @BuiltValueField(wireName: 'curr_jobs_posted')
  BuiltList<DocumentReference>? get currJobsPosted;

  @BuiltValueField(wireName: 'past_jobs_accepted')
  BuiltList<DocumentReference>? get pastJobsAccepted;

  @BuiltValueField(wireName: 'past_jobs_posted')
  BuiltList<DocumentReference>? get pastJobsPosted;

  String? get gender;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(UsersRecordBuilder builder) => builder
    ..email = ''
    ..displayName = ''
    ..photoUrl = ''
    ..uid = ''
    ..phoneNumber = ''
    ..gender = ''
    ..pastJobsAccepted = ListBuilder()
    ..pastJobsPosted = ListBuilder()
    ..currJobsAccepted = ListBuilder()
    ..currJobsPosted = ListBuilder();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  UsersRecord._();
  factory UsersRecord([void Function(UsersRecordBuilder) updates]) =
      _$UsersRecord;

  static UsersRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  static Future<void> addCurrJobsPosted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'curr_jobs_posted': FieldValue.arrayUnion([jobRef])
    });
  }

  static Future<void> addCurrJobsAccepted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'curr_jobs_accepted': FieldValue.arrayUnion([jobRef])
    });
  }

  static Future<void> sendToPastJobsPosted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'curr_jobs_posted': FieldValue.arrayRemove([jobRef])
    });

    await userRef.update({
      'past_jobs_posted': FieldValue.arrayUnion([jobRef])
    });
  }

  static Future<void> sendToPastJobsAccepted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'curr_jobs_accepted': FieldValue.arrayRemove([jobRef])
    });

    await userRef.update({
      'past_jobs_accpted': FieldValue.arrayUnion([jobRef])
    });
  }

  // factory UsersRecord.fromSnapshot(DocumentSnapshot snapshot) {
  //   return UsersRecord(
  //     uid: snapshot.uid,
  //     currJobsPosted: List<String>.from(snapshot.data()?['currJobsPosted'] ?? []),
  //   );
  // }
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  List<DocumentReference>? currJobsPosted,
  List<DocumentReference>? currJobsAccepted,
  List<DocumentReference>? pastJobsPosted,
  List<DocumentReference>? pastJobsAccepted,
  String? gender,
}) {
  final firestoreData =
      serializers.toFirestore(UsersRecord.serializer, UsersRecord((u) {
    u
      ..email = email
      ..displayName = displayName
      ..photoUrl = photoUrl
      ..uid = uid
      ..createdTime = createdTime
      ..phoneNumber = phoneNumber
      ..gender = gender;

    var s = currJobsPosted;
    var t = currJobsAccepted;
    var w = pastJobsPosted;
    var v = pastJobsAccepted;

    int len;
    if (s != null) {
      len = s.length; // Safe
    } else {
      len = 0;
    }
    for (int i = 0; i < len; i++) {
      u.currJobsPosted.add(currJobsPosted![i] as DocumentReference<Object?>);
    }

    int len1;
    if (t != null) {
      len1 = t.length; // Safe
    } else {
      len1 = 0;
    }
    for (int i = 0; i < len1; i++) {
      u.currJobsPosted.add(currJobsAccepted![i] as DocumentReference<Object?>);
    }

    int len2;
    if (w != null) {
      len2 = w.length; // Safe
    } else {
      len2 = 0;
    }
    for (int i = 0; i < len2; i++) {
      u.currJobsPosted.add(pastJobsPosted![i]) as DocumentReference<Object?>;
    }

    int len3;
    if (v != null) {
      len3 = v.length; // Safe
    } else {
      len3 = 0;
    }
    for (int i = 0; i < len3; i++) {
      u.currJobsPosted.add(pastJobsAccepted![i] as DocumentReference<Object?>);
    }
  }));

  return firestoreData;
}
