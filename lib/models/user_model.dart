import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final int point;
  final String rank; // bronze, silver, gold

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.point,
    required this.rank,
  });

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>;

    return User(
      id: userDoc.id,
      name: userData['name'],
      email: userData['email'],
      profileImage: userData['profileImage'],
      point: userData['point'],
      rank: userData['rank'],
    );
  }

  factory User.init() {
    return const User(
      id: '',
      name: '',
      email: '',
      profileImage: '',
      point: -1,
      rank: '',
    );
  }

  // @override
  // // TODO: implement props
  // List<Object?> get props => [id, name, email, profileImage, point, rank];

  // @override
  // String toString() {
  //   return 'User(id: $id, name: $name, email: $email, profileImage: $profileImage, point: $point, rank: $rank)';
  // }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, profileImage: $profileImage, point: $point, rank: $rank}';
  }

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      name,
      email,
      profileImage,
      point,
      rank,
    ];
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'profileImage': profileImage});
    result.addAll({'point': point});
    result.addAll({'rank': rank});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'] ?? '',
      point: map['point'] ?? '',
      rank: map['rank'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
