import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserProfile {
  String id;
  String fullname;
  String email;
  String phone;
  String birthdate;
  String gender;
  dynamic avatar;
  UserProfile({
    this.id = '',
    this.fullname = '',
    this.email = '',
    this.phone = '',
    this.birthdate = '',
    this.gender = '',
    @required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'birthdate': birthdate,
      'gender': gender,
      'avatar': avatar,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      fullname: map['fullname'],
      email: map['email'],
      phone: map['phone'],
      birthdate: map['birthdate'],
      gender: map['gender'],
      avatar: map['avatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(id: $id, fullname: $fullname, email: $email, phone: $phone, birthdate: $birthdate, gender: $gender, avatar: $avatar)';
  }
}
