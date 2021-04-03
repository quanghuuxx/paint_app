import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserProfile {
  String id;
  String name;
  String email;
  String phone;
  int perms;
  String birthdate;
  Map<String, dynamic> address;
  int block;
  String gender;
  Map<String, dynamic> money;
  dynamic avatar;
  String password;
  UserProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.perms,
    this.birthdate,
    this.address,
    this.block,
    this.gender,
    this.money,
    this.avatar,
    this.password,
  });

  UserProfile copyWith({
    String id,
    String name,
    String email,
    String phone,
    int perms,
    String birthdate,
    Map<String, dynamic> address,
    int block,
    String gender,
    Map<String, dynamic> money,
    dynamic avatar,
    String password,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      perms: perms ?? this.perms,
      birthdate: birthdate ?? this.birthdate,
      address: address ?? this.address,
      block: block ?? this.block,
      gender: gender ?? this.gender,
      money: money ?? this.money,
      avatar: avatar ?? this.avatar,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'perms': perms,
      'birthdate': birthdate,
      'address': address,
      'block': block,
      'gender': gender,
      'money': money,
      'avatar': avatar,
      'password': password,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserProfile(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      perms: map['perms'],
      birthdate: map['birthdate'],
      address: Map<String, dynamic>.from(map['address']),
      block: map['block'],
      gender: map['gender'],
      money: Map<String, dynamic>.from(map['money']),
      avatar: map['avatar'],
      // password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, phone: $phone, perms: $perms, birthdate: $birthdate, address: $address, block: $block, gender: $gender, money: $money, avatar: $avatar, password: $password)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserProfile &&
        o.id == id &&
        o.name == name &&
        o.email == email &&
        o.phone == phone &&
        o.perms == perms &&
        o.birthdate == birthdate &&
        mapEquals(o.address, address) &&
        o.block == block &&
        o.gender == gender &&
        mapEquals(o.money, money) &&
        o.avatar == avatar &&
        o.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        perms.hashCode ^
        birthdate.hashCode ^
        address.hashCode ^
        block.hashCode ^
        gender.hashCode ^
        money.hashCode ^
        avatar.hashCode ^
        password.hashCode;
  }
}
