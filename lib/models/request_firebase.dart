import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_custom_paint/models/doc.dart';

class RequestFirebase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference doc = FirebaseFirestore.instance.collection('doc');

  static Future<void> addDoc(Map<String, dynamic> map) {
    return doc
        .add(map)
        .then((value) => print("Doc Added"))
        .catchError((error) => print("Failed to add doc: $error"));
  }

  static Future<Doc> getDoc(String id) {
    return doc.doc(id).get().then((value) {
      final doc = Doc.fromMap(value.data());
      return doc;
    });
  }
}
