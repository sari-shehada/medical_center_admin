// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:medical_center_admin/core/extensions/date_time_extensions.dart';

class Doctor {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final DateTime dateOfBirth;
  final DateTime careerStartDate;
  final String certificateUrl;
  final bool isApproved;
  final bool isMale;
  final int? approvingAdminId;
  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.dateOfBirth,
    required this.careerStartDate,
    required this.certificateUrl,
    required this.isApproved,
    required this.isMale,
    required this.approvingAdminId,
  });

  Doctor copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    DateTime? dateOfBirth,
    DateTime? careerStartDate,
    String? certificateUrl,
    bool? isApproved,
    bool? isMale,
    int? approvingAdminId,
  }) {
    return Doctor(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      careerStartDate: careerStartDate ?? this.careerStartDate,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      isApproved: isApproved ?? this.isApproved,
      isMale: isMale ?? this.isMale,
      approvingAdminId: approvingAdminId ?? this.approvingAdminId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'dateOfBirth': dateOfBirth.getDateOnly(),
      'careerStartDate': careerStartDate.getDateOnly(),
      'certificateUrl': certificateUrl,
      'isApproved': isApproved,
      'isMale': isMale,
      'approvingAdminId': approvingAdminId,
    };
  }

  String get fullName => '$firstName $lastName';

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      careerStartDate: DateTime.now() ?? DateTime.parse(map['careerStartDate']),
      certificateUrl: map['certificateUrl'] as String,
      isApproved: map['isApproved'] as bool,
      isMale: true ?? map['isMale'] as bool,
      approvingAdminId: map['approvingAdminId'] != null
          ? map['approvingAdminId'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) =>
      Doctor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Doctor(id: $id, firstName: $firstName, lastName: $lastName, username: $username, dateOfBirth: $dateOfBirth, careerStartDate: $careerStartDate, certificateUrl: $certificateUrl, isApproved: $isApproved, isMale: $isMale, approvingAdminId: $approvingAdminId)';
  }

  @override
  bool operator ==(covariant Doctor other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.dateOfBirth == dateOfBirth &&
        other.careerStartDate == careerStartDate &&
        other.certificateUrl == certificateUrl &&
        other.isApproved == isApproved &&
        other.isMale == isMale &&
        other.approvingAdminId == approvingAdminId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        username.hashCode ^
        dateOfBirth.hashCode ^
        careerStartDate.hashCode ^
        certificateUrl.hashCode ^
        isApproved.hashCode ^
        isMale.hashCode ^
        approvingAdminId.hashCode;
  }
}
