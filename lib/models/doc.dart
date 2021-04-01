import 'package:cloud_firestore/cloud_firestore.dart';

class Doc {
  String id;
  String name;
  String token;
  List<dynamic> page;

  Doc({
    this.id = '',
    this.name = '',
    this.token = '',
    this.page = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'token': token,
      'page': page,
    };
  }

  // factory Doc.fromMap(Map<String, dynamic> map) {
  //   return Doc(
  //     name: map['name'],
  //     token: map['token'],
  //     page: List<dynamic>.from(map['page']),
  //   );
  // }

  factory Doc.formDocumentSnapShot(QueryDocumentSnapshot documentSnapshot) {
    Map<String, dynamic> map = documentSnapshot.data();
    return Doc(
        id: documentSnapshot.id,
        name: map['name'],
        token: map['token'],
        page: List<dynamic>.from(map['page']));
  }
}
