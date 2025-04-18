// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UsersRecord> _$usersRecordSerializer = new _$UsersRecordSerializer();

class _$UsersRecordSerializer implements StructuredSerializer<UsersRecord> {
  @override
  final Iterable<Type> types = const [UsersRecord, _$UsersRecord];
  @override
  final String wireName = 'UsersRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, UsersRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'stripeVerified',
      serializers.serialize(object.stripeVerified,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.displayName;
    if (value != null) {
      result
        ..add('display_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.firstName;
    if (value != null) {
      result
        ..add('first_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.lastName;
    if (value != null) {
      result
        ..add('last_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.photoUrl;
    if (value != null) {
      result
        ..add('photo_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.uid;
    if (value != null) {
      result
        ..add('uid')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.createdTime;
    if (value != null) {
      result
        ..add('created_time')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.phoneNumber;
    if (value != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.currJobsAccepted;
    if (value != null) {
      result
        ..add('curr_jobs_accepted')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(
                  DocumentReference, const [const FullType.nullable(Object)])
            ])));
    }
    value = object.currJobsPosted;
    if (value != null) {
      result
        ..add('curr_jobs_posted')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(
                  DocumentReference, const [const FullType.nullable(Object)])
            ])));
    }
    value = object.pastJobsAccepted;
    if (value != null) {
      result
        ..add('past_jobs_accepted')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(
                  DocumentReference, const [const FullType.nullable(Object)])
            ])));
    }
    value = object.pastJobsPosted;
    if (value != null) {
      result
        ..add('past_jobs_posted')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(
                  DocumentReference, const [const FullType.nullable(Object)])
            ])));
    }
    value = object.gender;
    if (value != null) {
      result
        ..add('gender')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.stripeAccountID;
    if (value != null) {
      result
        ..add('stripeAccountID')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  UsersRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UsersRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'display_name':
          result.displayName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'first_name':
          result.firstName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'last_name':
          result.lastName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'photo_url':
          result.photoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created_time':
          result.createdTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'phone_number':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'curr_jobs_accepted':
          result.currJobsAccepted.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(
                    DocumentReference, const [const FullType.nullable(Object)])
              ]))! as BuiltList<Object?>);
          break;
        case 'curr_jobs_posted':
          result.currJobsPosted.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(
                    DocumentReference, const [const FullType.nullable(Object)])
              ]))! as BuiltList<Object?>);
          break;
        case 'past_jobs_accepted':
          result.pastJobsAccepted.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(
                    DocumentReference, const [const FullType.nullable(Object)])
              ]))! as BuiltList<Object?>);
          break;
        case 'past_jobs_posted':
          result.pastJobsPosted.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(
                    DocumentReference, const [const FullType.nullable(Object)])
              ]))! as BuiltList<Object?>);
          break;
        case 'gender':
          result.gender = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'stripeAccountID':
          result.stripeAccountID = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'stripeVerified':
          result.stripeVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$UsersRecord extends UsersRecord {
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? photoUrl;
  @override
  final String? uid;
  @override
  final DateTime? createdTime;
  @override
  final String? phoneNumber;
  @override
  final BuiltList<DocumentReference<Object?>>? currJobsAccepted;
  @override
  final BuiltList<DocumentReference<Object?>>? currJobsPosted;
  @override
  final BuiltList<DocumentReference<Object?>>? pastJobsAccepted;
  @override
  final BuiltList<DocumentReference<Object?>>? pastJobsPosted;
  @override
  final String? gender;
  @override
  final String? stripeAccountID;
  @override
  final bool stripeVerified;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$UsersRecord([void Function(UsersRecordBuilder)? updates]) =>
      (new UsersRecordBuilder()..update(updates))._build();

  _$UsersRecord._(
      {this.email,
      this.displayName,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.uid,
      this.createdTime,
      this.phoneNumber,
      this.currJobsAccepted,
      this.currJobsPosted,
      this.pastJobsAccepted,
      this.pastJobsPosted,
      this.gender,
      this.stripeAccountID,
      required this.stripeVerified,
      this.ffRef})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        stripeVerified, r'UsersRecord', 'stripeVerified');
  }

  @override
  UsersRecord rebuild(void Function(UsersRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UsersRecordBuilder toBuilder() => new UsersRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsersRecord &&
        email == other.email &&
        displayName == other.displayName &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        photoUrl == other.photoUrl &&
        uid == other.uid &&
        createdTime == other.createdTime &&
        phoneNumber == other.phoneNumber &&
        currJobsAccepted == other.currJobsAccepted &&
        currJobsPosted == other.currJobsPosted &&
        pastJobsAccepted == other.pastJobsAccepted &&
        pastJobsPosted == other.pastJobsPosted &&
        gender == other.gender &&
        stripeAccountID == other.stripeAccountID &&
        stripeVerified == other.stripeVerified &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jc(_$hash, createdTime.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, currJobsAccepted.hashCode);
    _$hash = $jc(_$hash, currJobsPosted.hashCode);
    _$hash = $jc(_$hash, pastJobsAccepted.hashCode);
    _$hash = $jc(_$hash, pastJobsPosted.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, stripeAccountID.hashCode);
    _$hash = $jc(_$hash, stripeVerified.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UsersRecord')
          ..add('email', email)
          ..add('displayName', displayName)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('photoUrl', photoUrl)
          ..add('uid', uid)
          ..add('createdTime', createdTime)
          ..add('phoneNumber', phoneNumber)
          ..add('currJobsAccepted', currJobsAccepted)
          ..add('currJobsPosted', currJobsPosted)
          ..add('pastJobsAccepted', pastJobsAccepted)
          ..add('pastJobsPosted', pastJobsPosted)
          ..add('gender', gender)
          ..add('stripeAccountID', stripeAccountID)
          ..add('stripeVerified', stripeVerified)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class UsersRecordBuilder implements Builder<UsersRecord, UsersRecordBuilder> {
  _$UsersRecord? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  DateTime? _createdTime;
  DateTime? get createdTime => _$this._createdTime;
  set createdTime(DateTime? createdTime) => _$this._createdTime = createdTime;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  ListBuilder<DocumentReference<Object?>>? _currJobsAccepted;
  ListBuilder<DocumentReference<Object?>> get currJobsAccepted =>
      _$this._currJobsAccepted ??=
          new ListBuilder<DocumentReference<Object?>>();
  set currJobsAccepted(
          ListBuilder<DocumentReference<Object?>>? currJobsAccepted) =>
      _$this._currJobsAccepted = currJobsAccepted;

  ListBuilder<DocumentReference<Object?>>? _currJobsPosted;
  ListBuilder<DocumentReference<Object?>> get currJobsPosted =>
      _$this._currJobsPosted ??= new ListBuilder<DocumentReference<Object?>>();
  set currJobsPosted(ListBuilder<DocumentReference<Object?>>? currJobsPosted) =>
      _$this._currJobsPosted = currJobsPosted;

  ListBuilder<DocumentReference<Object?>>? _pastJobsAccepted;
  ListBuilder<DocumentReference<Object?>> get pastJobsAccepted =>
      _$this._pastJobsAccepted ??=
          new ListBuilder<DocumentReference<Object?>>();
  set pastJobsAccepted(
          ListBuilder<DocumentReference<Object?>>? pastJobsAccepted) =>
      _$this._pastJobsAccepted = pastJobsAccepted;

  ListBuilder<DocumentReference<Object?>>? _pastJobsPosted;
  ListBuilder<DocumentReference<Object?>> get pastJobsPosted =>
      _$this._pastJobsPosted ??= new ListBuilder<DocumentReference<Object?>>();
  set pastJobsPosted(ListBuilder<DocumentReference<Object?>>? pastJobsPosted) =>
      _$this._pastJobsPosted = pastJobsPosted;

  String? _gender;
  String? get gender => _$this._gender;
  set gender(String? gender) => _$this._gender = gender;

  String? _stripeAccountID;
  String? get stripeAccountID => _$this._stripeAccountID;
  set stripeAccountID(String? stripeAccountID) =>
      _$this._stripeAccountID = stripeAccountID;

  bool? _stripeVerified;
  bool? get stripeVerified => _$this._stripeVerified;
  set stripeVerified(bool? stripeVerified) =>
      _$this._stripeVerified = stripeVerified;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  UsersRecordBuilder() {
    UsersRecord._initializeBuilder(this);
  }

  UsersRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _displayName = $v.displayName;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _photoUrl = $v.photoUrl;
      _uid = $v.uid;
      _createdTime = $v.createdTime;
      _phoneNumber = $v.phoneNumber;
      _currJobsAccepted = $v.currJobsAccepted?.toBuilder();
      _currJobsPosted = $v.currJobsPosted?.toBuilder();
      _pastJobsAccepted = $v.pastJobsAccepted?.toBuilder();
      _pastJobsPosted = $v.pastJobsPosted?.toBuilder();
      _gender = $v.gender;
      _stripeAccountID = $v.stripeAccountID;
      _stripeVerified = $v.stripeVerified;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsersRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UsersRecord;
  }

  @override
  void update(void Function(UsersRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UsersRecord build() => _build();

  _$UsersRecord _build() {
    _$UsersRecord _$result;
    try {
      _$result = _$v ??
          new _$UsersRecord._(
              email: email,
              displayName: displayName,
              firstName: firstName,
              lastName: lastName,
              photoUrl: photoUrl,
              uid: uid,
              createdTime: createdTime,
              phoneNumber: phoneNumber,
              currJobsAccepted: _currJobsAccepted?.build(),
              currJobsPosted: _currJobsPosted?.build(),
              pastJobsAccepted: _pastJobsAccepted?.build(),
              pastJobsPosted: _pastJobsPosted?.build(),
              gender: gender,
              stripeAccountID: stripeAccountID,
              stripeVerified: BuiltValueNullFieldError.checkNotNull(
                  stripeVerified, r'UsersRecord', 'stripeVerified'),
              ffRef: ffRef);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currJobsAccepted';
        _currJobsAccepted?.build();
        _$failedField = 'currJobsPosted';
        _currJobsPosted?.build();
        _$failedField = 'pastJobsAccepted';
        _pastJobsAccepted?.build();
        _$failedField = 'pastJobsPosted';
        _pastJobsPosted?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UsersRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
