import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class DocumentReferenceAdapter extends TypeAdapter<DocumentReference> {
  @override
  final typeId = 2; // Choose a unique ID for this adapter

  @override
  DocumentReference read(BinaryReader reader) {
    final path = reader.readString();
    return FirebaseFirestore.instance.doc(path);
  }

  @override
  void write(BinaryWriter writer, DocumentReference obj) {
    writer.writeString(obj.path);
  }
}
