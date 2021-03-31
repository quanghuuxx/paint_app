import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_custom_paint/models/doc.dart';

class RequestFirebase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference doc = FirebaseFirestore.instance.collection('doc');

  static Future<bool> addDoc(Map<String, dynamic> map) {
    return doc.add(map).then((value) => true).catchError((error) {
      print("Failed to add doc: $error");
      return false;
    });
  }

  static Query getAllDoc() {
    return doc
        .where('token', isEqualTo: 'ABC')
        .orderBy('name', descending: false);
  }

  static Future<Doc> getDoc(String id) {
    return doc.doc(id).get().then((value) {
      final doc = Doc.formDocumentSnapShot(value);
      return doc;
    }).catchError((error) {
      print("Failed to get doc: $error");
      return new Doc();
    });
  }

  static Future<bool> deleteDoc(String id) {
    return doc.doc(id).delete().then((value) => true).catchError((error) {
      print("Failed to delete doc: $error");
      return false;
    });
  }

  static Future<bool> updateDoc(String id, Map<String, dynamic> map) {
    return doc.doc(id).update(map).then((value) => true).catchError((error) {
      print("Failed to update doc: $error");
      return false;
    });
  }
}
