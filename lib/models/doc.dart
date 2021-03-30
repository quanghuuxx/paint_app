import 'dart:convert';

class Doc {
  String name;
  String token;
  List<dynamic> page;

  Doc({
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

  factory Doc.fromMap(Map<String, dynamic> map) {
    return Doc(
      name: map['name'],
      token: map['token'],
      page: List<dynamic>.from(map['page']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Doc.fromJson(String source) => Doc.fromMap(json.decode(source));
}
