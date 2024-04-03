// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdminInfo {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  AdminInfo({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  AdminInfo copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
  }) {
    return AdminInfo(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  String get fullName => '$firstName $lastName';

  factory AdminInfo.fromMap(Map<String, dynamic> map) {
    return AdminInfo(
      id: map['id'] as int,
      username: map['username'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminInfo.fromJson(String source) =>
      AdminInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminInfo(id: $id, username: $username, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(covariant AdminInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        firstName.hashCode ^
        lastName.hashCode;
  }
}
