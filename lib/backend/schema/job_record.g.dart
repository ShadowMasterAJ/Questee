// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<JobRecord> _$jobRecordSerializer = new _$JobRecordSerializer();

class _$JobRecordSerializer implements StructuredSerializer<JobRecord> {
  @override
  final Iterable<Type> types = const [JobRecord, _$JobRecord];
  @override
  final String wireName = 'JobRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, JobRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.note;
    if (value != null) {
      result
        ..add('note')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.store;
    if (value != null) {
      result
        ..add('store')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.delLocation;
    if (value != null) {
      result
        ..add('del_location')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.price;
    if (value != null) {
      result
        ..add('price')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.delTime;
    if (value != null) {
      result
        ..add('del_time')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.items;
    if (value != null) {
      result
        ..add('items')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.verificationImages;
    if (value != null) {
      result
        ..add('verificationImages')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.verifiedByPoster;
    if (value != null) {
      result
        ..add('verifiedByPoster')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.itemQuantity;
    if (value != null) {
      result
        ..add('item_quantity')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.posterID;
    if (value != null) {
      result
        ..add('posterID')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.acceptorID;
    if (value != null) {
      result
        ..add('acceptorID')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
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
  JobRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new JobRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'note':
          result.note = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'store':
          result.store = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'del_location':
          result.delLocation = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'del_time':
          result.delTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'items':
          result.items.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'verificationImages':
          result.verificationImages.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'verifiedByPoster':
          result.verifiedByPoster = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'item_quantity':
          result.itemQuantity = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'posterID':
          result.posterID = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'acceptorID':
          result.acceptorID = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
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

class _$JobRecord extends JobRecord {
  @override
  final String? type;
  @override
  final String? note;
  @override
  final String? store;
  @override
  final String? delLocation;
  @override
  final double? price;
  @override
  final String? status;
  @override
  final DateTime? delTime;
  @override
  final BuiltList<String>? items;
  @override
  final BuiltList<String>? verificationImages;
  @override
  final bool? verifiedByPoster;
  @override
  final int? itemQuantity;
  @override
  final DocumentReference<Object?>? posterID;
  @override
  final DocumentReference<Object?>? acceptorID;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$JobRecord([void Function(JobRecordBuilder)? updates]) =>
      (new JobRecordBuilder()..update(updates))._build();

  _$JobRecord._(
      {this.type,
      this.note,
      this.store,
      this.delLocation,
      this.price,
      this.status,
      this.delTime,
      this.items,
      this.verificationImages,
      this.verifiedByPoster,
      this.itemQuantity,
      this.posterID,
      this.acceptorID,
      this.ffRef})
      : super._();

  @override
  JobRecord rebuild(void Function(JobRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JobRecordBuilder toBuilder() => new JobRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JobRecord &&
        type == other.type &&
        note == other.note &&
        store == other.store &&
        delLocation == other.delLocation &&
        price == other.price &&
        status == other.status &&
        delTime == other.delTime &&
        items == other.items &&
        verificationImages == other.verificationImages &&
        verifiedByPoster == other.verifiedByPoster &&
        itemQuantity == other.itemQuantity &&
        posterID == other.posterID &&
        acceptorID == other.acceptorID &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, delLocation.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, delTime.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, verificationImages.hashCode);
    _$hash = $jc(_$hash, verifiedByPoster.hashCode);
    _$hash = $jc(_$hash, itemQuantity.hashCode);
    _$hash = $jc(_$hash, posterID.hashCode);
    _$hash = $jc(_$hash, acceptorID.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JobRecord')
          ..add('type', type)
          ..add('note', note)
          ..add('store', store)
          ..add('delLocation', delLocation)
          ..add('price', price)
          ..add('status', status)
          ..add('delTime', delTime)
          ..add('items', items)
          ..add('verificationImages', verificationImages)
          ..add('verifiedByPoster', verifiedByPoster)
          ..add('itemQuantity', itemQuantity)
          ..add('posterID', posterID)
          ..add('acceptorID', acceptorID)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class JobRecordBuilder implements Builder<JobRecord, JobRecordBuilder> {
  _$JobRecord? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _store;
  String? get store => _$this._store;
  set store(String? store) => _$this._store = store;

  String? _delLocation;
  String? get delLocation => _$this._delLocation;
  set delLocation(String? delLocation) => _$this._delLocation = delLocation;

  double? _price;
  double? get price => _$this._price;
  set price(double? price) => _$this._price = price;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _delTime;
  DateTime? get delTime => _$this._delTime;
  set delTime(DateTime? delTime) => _$this._delTime = delTime;

  ListBuilder<String>? _items;
  ListBuilder<String> get items => _$this._items ??= new ListBuilder<String>();
  set items(ListBuilder<String>? items) => _$this._items = items;

  ListBuilder<String>? _verificationImages;
  ListBuilder<String> get verificationImages =>
      _$this._verificationImages ??= new ListBuilder<String>();
  set verificationImages(ListBuilder<String>? verificationImages) =>
      _$this._verificationImages = verificationImages;

  bool? _verifiedByPoster;
  bool? get verifiedByPoster => _$this._verifiedByPoster;
  set verifiedByPoster(bool? verifiedByPoster) =>
      _$this._verifiedByPoster = verifiedByPoster;

  int? _itemQuantity;
  int? get itemQuantity => _$this._itemQuantity;
  set itemQuantity(int? itemQuantity) => _$this._itemQuantity = itemQuantity;

  DocumentReference<Object?>? _posterID;
  DocumentReference<Object?>? get posterID => _$this._posterID;
  set posterID(DocumentReference<Object?>? posterID) =>
      _$this._posterID = posterID;

  DocumentReference<Object?>? _acceptorID;
  DocumentReference<Object?>? get acceptorID => _$this._acceptorID;
  set acceptorID(DocumentReference<Object?>? acceptorID) =>
      _$this._acceptorID = acceptorID;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  JobRecordBuilder() {
    JobRecord._initializeBuilder(this);
  }

  JobRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _note = $v.note;
      _store = $v.store;
      _delLocation = $v.delLocation;
      _price = $v.price;
      _status = $v.status;
      _delTime = $v.delTime;
      _items = $v.items?.toBuilder();
      _verificationImages = $v.verificationImages?.toBuilder();
      _verifiedByPoster = $v.verifiedByPoster;
      _itemQuantity = $v.itemQuantity;
      _posterID = $v.posterID;
      _acceptorID = $v.acceptorID;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JobRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$JobRecord;
  }

  @override
  void update(void Function(JobRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JobRecord build() => _build();

  _$JobRecord _build() {
    _$JobRecord _$result;
    try {
      _$result = _$v ??
          new _$JobRecord._(
              type: type,
              note: note,
              store: store,
              delLocation: delLocation,
              price: price,
              status: status,
              delTime: delTime,
              items: _items?.build(),
              verificationImages: _verificationImages?.build(),
              verifiedByPoster: verifiedByPoster,
              itemQuantity: itemQuantity,
              posterID: posterID,
              acceptorID: acceptorID,
              ffRef: ffRef);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
        _$failedField = 'verificationImages';
        _verificationImages?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'JobRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
