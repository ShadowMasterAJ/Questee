import 'dart:async';

import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'users_record.g.dart';

abstract class UsersRecord implements Built<UsersRecord, UsersRecordBuilder> {
  static Serializer<UsersRecord> get serializer => _$usersRecordSerializer;

  @BuiltValueField(wireName: 'email')
  String? get email;

  @BuiltValueField(wireName: 'display_name')
  String? get displayName;

  @BuiltValueField(wireName: 'first_name')
  String? get firstName;

  @BuiltValueField(wireName: 'last_name')
  String? get lastName;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  @BuiltValueField(wireName: 'uid')
  String? get uid;

  @BuiltValueField(wireName: 'created_time')
  DateTime? get createdTime;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: 'curr_jobs_accepted')
  BuiltList<DocumentReference>? get currJobsAccepted;

  @BuiltValueField(wireName: 'curr_jobs_posted')
  BuiltList<DocumentReference>? get currJobsPosted;

  @BuiltValueField(wireName: 'past_jobs_accepted')
  BuiltList<DocumentReference>? get pastJobsAccepted;

  @BuiltValueField(wireName: 'past_jobs_posted')
  BuiltList<DocumentReference>? get pastJobsPosted;

  @BuiltValueField(wireName: 'gender')
  String? get gender;

  @BuiltValueField(wireName: 'stripeAccountID')
  String? get stripeAccountID;

  @BuiltValueField(wireName: 'stripeVerified')
  bool get stripeVerified;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;

  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(UsersRecordBuilder builder) => builder
    ..email = ''
    ..displayName = ''
    ..firstName = ''
    ..lastName = ''
    ..photoUrl = ''
    ..uid = ''
    ..phoneNumber = ''
    ..gender = ''
    ..stripeAccountID = ''
    ..stripeVerified = false
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
static Future<void> removeFromCurrJobsPosted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'curr_jobs_posted': FieldValue.arrayRemove([jobRef])
    });
  }
  static Future<void> addCurrJobsAccepted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'curr_jobs_accepted': FieldValue.arrayUnion([jobRef])
    });
  }

  static Future<void> addPastJobsAccepted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'past_jobs_accepted': FieldValue.arrayUnion([jobRef])
    });
  }

  static Future<void> addPastJobsPosted(
      String userId, DocumentReference? jobRef) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'past_jobs_posted': FieldValue.arrayUnion([jobRef])
    });
  }
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  displayName,
  photoUrl,
  uid,
  phoneNumber,
  stripeAccountID,
  gender,
  firstName,
  lastName,
  bool stripeVerified = false,
  DateTime? createdTime,
  List<DocumentReference>? currJobsPosted,
  currJobsAccepted,
  pastJobsPosted,
  pastJobsAccepted,
}) {
  final firestoreData =
      serializers.toFirestore(UsersRecord.serializer, UsersRecord((u) {
    u
      ..email = email
      ..displayName = displayName
      ..firstName = firstName
      ..lastName = lastName
      ..photoUrl = photoUrl
      ..uid = uid
      ..createdTime = createdTime
      ..phoneNumber = phoneNumber
      ..stripeAccountID = stripeAccountID
      ..stripeVerified = stripeVerified
      ..gender = gender;

    int lenCJP = currJobsPosted != null ? currJobsPosted.length : 0;
    for (int i = 0; i < lenCJP; i++) u.currJobsPosted.add(currJobsPosted![i]);

    int lenCJA = currJobsAccepted != null ? currJobsAccepted.length : 0;
    for (int i = 0; i < lenCJA; i++)
      u.currJobsAccepted.add(currJobsAccepted![i]);

    int lenPJP = pastJobsPosted != null ? pastJobsPosted.length : 0;
    for (int i = 0; i < lenPJP; i++) u.currJobsAccepted.add(pastJobsPosted![i]);

    int lenPJA = pastJobsAccepted != null ? pastJobsAccepted.length : 0;
    for (int i = 0; i < lenPJA; i++)
      u.currJobsAccepted.add(pastJobsAccepted![i]);
  }));

  return firestoreData;
}
