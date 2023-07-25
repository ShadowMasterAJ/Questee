/*
README

A serializer is a component that converts complex data structures (e.g., objects) into a format that 
can be easily stored or transmitted, such as JSON or XML.

A deserializer does the reverse: it converts the serialized data back into its original data structure.

We need serializers and deserializers to facilitate data exchange between different systems or 
platforms, ensuring seamless communication and data compatibility.

In the code below, the serializers are used to convert Firestore-specific data types 
(e.g., DocumentReference, GeoPoint, Timestamp) into JSON-compatible representations 
and vice versa. This allows data to be stored and retrieved from Firestore while maintaining 
its original structure.

Table of Contents:

1. Global Constants and Variables
    - `kDocumentReferenceField`

2. Serializers
    - `Serializers`
    - `DocumentReferenceSerializer`
    - `DateTimeSerializer`
    - `LatLngSerializer`
    - `FirestoreUtilData`
    - `FirestoreUtilDataSerializer`
    - `ColorSerializer`

3. Extensions
    - `SerializerExtensions`
    - `GeoPointExtension`
    - `LatLngExtension`

4. Helper Functions
    - `serializedData`
    - `mapFromFirestore`
    - `mapToFirestore`
    - `toRef`
    - `safeGet`

Explanation:

1. Global Constants and Variables:
   - `kDocumentReferenceField`: A constant string with the value 'Document__Reference__Field'.

2. Serializers:
   - `Serializers`: A class instance responsible for serializing and deserializing objects.
   - `DocumentReferenceSerializer`: A class implementing the `PrimitiveSerializer` interface to handle serialization and deserialization of `DocumentReference` objects.
   - `DateTimeSerializer`: A class implementing the `PrimitiveSerializer` interface to handle serialization and deserialization of `DateTime` objects.
   - `LatLngSerializer`: A class implementing the `PrimitiveSerializer` interface to handle serialization and deserialization of `LatLng` objects.
   - `FirestoreUtilData`: A data class that represents Firestore utility data with optional fields: `fieldValues`, `clearUnsetFields`, `create`, and `delete`.
   - `FirestoreUtilDataSerializer`: A class implementing the `PrimitiveSerializer` interface to handle serialization and deserialization of `FirestoreUtilData` objects.
   - `ColorSerializer`: A class implementing the `PrimitiveSerializer` interface to handle serialization and deserialization of `Color` objects.

3. Extensions:
   - `SerializerExtensions`: An extension on the `Serializers` class providing a method `toFirestore` to convert an object of a specific type to a Firestore-compatible JSON map.
   - `GeoPointExtension`: An extension on the `LatLng` class to convert a `LatLng` object to a `GeoPoint` object (Firestore specific data type).
   - `LatLngExtension`: An extension on the `GeoPoint` class to convert a `GeoPoint` object (Firestore specific data type) to a `LatLng` object.

4. Helper Functions:
   - `serializedData`: A function that takes a `DocumentSnapshot` and returns a map representation of the document data with certain transformations applied to handle specific data types like `Timestamp` and `GeoPoint`.
   - `mapFromFirestore`: A function that takes a Firestore data map and applies transformations to handle specific data types like `Timestamp` and `GeoPoint`.
   - `mapToFirestore`: A function that takes a data map and applies transformations to handle specific data types like `LatLng`, converting them to Firestore-specific `GeoPoint` objects.
   - `toRef`: A function that takes a string reference and returns a `DocumentReference` object using `FirebaseFirestore.instance.doc()`.
   - `safeGet`: A generic function that safely executes another function (`func`) and catches any errors, optionally reporting them through the `reportError` callback.
*/


import 'package:built_value/standard_json_plugin.dart';
import 'package:from_css_color/from_css_color.dart';

import 'users_record.dart';
import 'job_record.dart';
import 'chats_record.dart';
import 'chat_messages_record.dart';

import 'index.dart';

export 'index.dart';

part 'serializers.g.dart';

/// The field name used for the DocumentReference field.
const kDocumentReferenceField = 'Document__Reference__Field';

/// The serializers used for the supported types: UsersRecord, JobRecord,
/// ChatsRecord, and ChatMessagesRecord.
@SerializersFor(const [
  UsersRecord,
  JobRecord,
  ChatsRecord,
  ChatMessagesRecord,
])
final Serializers serializers = (_$serializers.toBuilder()
      // Add DocumentReferenceSerializer to handle DocumentReference type.
      ..add(DocumentReferenceSerializer())
      // Add DateTimeSerializer to handle DateTime type.
      ..add(DateTimeSerializer())
      // Add LatLngSerializer to handle LatLng type.
      ..add(LatLngSerializer())
      // Add FirestoreUtilDataSerializer to handle FirestoreUtilData type.
      ..add(FirestoreUtilDataSerializer())
      // Add ColorSerializer to handle Color type.
      ..add(ColorSerializer())
      // Add StandardJsonPlugin to support standard JSON format.
      ..addPlugin(StandardJsonPlugin()))
    .build();

/// Extension methods for Serializers to convert a Dart object to Firestore data.
extension SerializerExtensions on Serializers {
  /// Converts a Dart object to Firestore data using the specified serializer.
  Map<String, dynamic> toFirestore<T>(Serializer<T> serializer, T object) =>
      mapToFirestore(serializeWith(serializer, object) as Map<String, dynamic>);
}

/// Serializer for DocumentReference type.
class DocumentReferenceSerializer
    implements PrimitiveSerializer<DocumentReference> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([DocumentReference]);
  @override
  final String wireName = 'DocumentReference';

  @override
  Object serialize(Serializers serializers, DocumentReference reference,
      {FullType specifiedType = FullType.unspecified}) {
    return reference;
  }

  @override
  DocumentReference deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      serialized as DocumentReference;
}

/// Serializer for DateTime type.
class DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  @override
  final Iterable<Type> types = new BuiltList<Type>([DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    return dateTime;
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      serialized as DateTime;
}

/// Serializer for LatLng type.
class LatLngSerializer implements PrimitiveSerializer<LatLng> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([LatLng]);
  @override
  final String wireName = 'LatLng';

  @override
  Object serialize(Serializers serializers, LatLng location,
      {FullType specifiedType = FullType.unspecified}) {
    return location;
  }

  @override
  LatLng deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      serialized as LatLng;
}

/// Model class for FirestoreUtilData.
class FirestoreUtilData {
  const FirestoreUtilData({
    this.fieldValues = const {},
    this.clearUnsetFields = true,
    this.create = false,
    this.delete = false,
  });

  /// The field values for Firestore data.
  final Map<String, dynamic> fieldValues;

  /// Indicates whether to clear unset fields.
  final bool clearUnsetFields;

  /// Indicates whether to create a new document.
  final bool create;

  /// Indicates whether to delete a document.
  final bool delete;

  static String get name => 'firestoreUtilData';
}

/// Serializer for FirestoreUtilData type.
class FirestoreUtilDataSerializer
    implements PrimitiveSerializer<FirestoreUtilData> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([FirestoreUtilData]);
  @override
  final String wireName = 'FirestoreUtilData';

  @override
  Object serialize(Serializers serializers, FirestoreUtilData firestoreUtilData,
      {FullType specifiedType = FullType.unspecified}) {
    return firestoreUtilData;
  }

  @override
  FirestoreUtilData deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      serialized as FirestoreUtilData;
}

/// Serializer for Color type.
class ColorSerializer implements PrimitiveSerializer<Color> {
  @override
  final Iterable<Type> types = new BuiltList<Type>([Color]);
  @override
  final String wireName = 'Color';

  @override
  Object serialize(Serializers serializers, Color color,
      {FullType specifiedType = FullType.unspecified}) {
    return color.toCssString();
  }

  @override
  Color deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      fromCssColor(serialized as String);
}

/// Converts the data from a DocumentSnapshot into a serialized map.
Map<String, dynamic> serializedData(DocumentSnapshot doc) => {
      ...mapFromFirestore(doc.data() as Map<String, dynamic>),
      kDocumentReferenceField: doc.reference
    };

/// Converts the data from a Firestore map to a serialized map.
///
/// This method handles the conversion of Firestore-specific data types (e.g., Timestamp,
/// GeoPoint) to their corresponding Dart types (e.g., DateTime, LatLng). It also recursively
/// handles nested data structures to ensure the entire Firestore map is converted to a
/// serialized map with the appropriate data types.
///
/// Parameters:
/// - `data`: The Firestore map data to be converted to a serialized map.
///
/// Returns:
/// A serialized map with appropriate data types, where Firestore-specific types are
/// converted to their Dart equivalents.
Map<String, dynamic> mapFromFirestore(Map<String, dynamic> data) =>
    mergeNestedFields(data)
        .where((k, _) => k != FirestoreUtilData.name)
        .map((key, value) {
      // Handle Timestamp
      if (value is Timestamp) {
        value = value.toDate();
      }
      // Handle list of Timestamp
      if (value is Iterable && value.isNotEmpty && value.first is Timestamp) {
        value = value.map((v) => (v as Timestamp).toDate()).toList();
      }
      // Handle GeoPoint
      if (value is GeoPoint) {
        value = value.toLatLng();
      }
      // Handle list of GeoPoint
      if (value is Iterable && value.isNotEmpty && value.first is GeoPoint) {
        value = value.map((v) => (v as GeoPoint).toLatLng()).toList();
      }
      // Handle nested data.
      if (value is Map) {
        value = mapFromFirestore(value as Map<String, dynamic>);
      }
      // Handle list of nested data.
      if (value is Iterable && value.isNotEmpty && value.first is Map) {
        value = value
            .map((v) => mapFromFirestore(v as Map<String, dynamic>))
            .toList();
      }
      return MapEntry(key, value);
    });

/// Converts the data from a serialized map to a Firestore map.
///
/// This method handles the conversion of Dart-specific data types (e.g., DateTime,
/// LatLng) to their corresponding Firestore types (e.g., Timestamp, GeoPoint).
/// It also recursively handles nested data structures to ensure the entire serialized
/// map is converted to a Firestore map with the appropriate data types.
///
/// Parameters:
/// - `data`: The serialized map data to be converted to a Firestore map.
///
/// Returns:
/// A Firestore map with appropriate data types, where Dart-specific types are
/// converted to their Firestore equivalents.
Map<String, dynamic> mapToFirestore(Map<String, dynamic> data) =>
    data.where((k, v) => k != FirestoreUtilData.name).map((key, value) {
      // Handle GeoPoint
      if (value is LatLng) value = value.toGeoPoint();

      // Handle list of GeoPoint
      if (value is Iterable && value.isNotEmpty && value.first is LatLng)
        value = value.map((v) => (v as LatLng).toGeoPoint()).toList();

      // Handle nested data.
      if (value is Map) value = mapFromFirestore(value as Map<String, dynamic>);

      // Handle list of nested data.
      if (value is Iterable && value.isNotEmpty && value.first is Map)
        value = value
            .map((v) => mapFromFirestore(v as Map<String, dynamic>))
            .toList();

      return MapEntry(key, value);
    });

/// Extension to convert a LatLng object to a GeoPoint object.
extension GeoPointExtension on LatLng {
  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}

/// Extension to convert a GeoPoint object to a LatLng object.
extension LatLngExtension on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

/// Converts a string reference to a DocumentReference object.
DocumentReference toRef(String ref) => FirebaseFirestore.instance.doc(ref);

/// Safely invokes the provided function and handles any errors that may occur.
T? safeGet<T>(T Function() func, [Function(dynamic)? reportError]) {
  try {
    return func();
  } catch (e) {
    reportError?.call(e);
  }
  return null;
}

/// Merges nested fields of a data map into a single field.
/// Example:
/// *  Input: {'foo.bar': 1, 'foo.baz': 2, 'foo.qux': 3}
/// *  Output: {'foo': {'bar': 1, 'baz': 2, 'qux': 3}}
Map<String, dynamic> mergeNestedFields(Map<String, dynamic> data) {
  final nestedData = data.where((k, _) => k.contains('.'));
  final fieldNames = nestedData.keys.map((k) => k.split('.').first).toSet();
  // Remove nested values (e.g. 'foo.bar') and merge them into a map.
  data.removeWhere((k, _) => k.contains('.'));
  fieldNames.forEach((name) {
    final mergedValues = mergeNestedFields(
      nestedData
          .where((k, _) => k.split('.').first == name)
          .map((k, v) => MapEntry(k.split('.').skip(1).join('.'), v)),
    );
    final existingValue = data[name];
    data[name] = {
      if (existingValue != null && existingValue is Map)
        ...existingValue as Map<String, dynamic>,
      ...mergedValues,
    };
  });
  // Merge any nested maps inside any of the fields as well.
  data.where((_, v) => v is Map).forEach((k, v) {
    data[k] = mergeNestedFields(v as Map<String, dynamic>);
  });

  return data;
}

extension _WhereMapExtension<K, V> on Map<K, V> {
  Map<K, V> where(bool Function(K, V) test) =>
      Map.fromEntries(entries.where((e) => test(e.key, e.value)));
}
