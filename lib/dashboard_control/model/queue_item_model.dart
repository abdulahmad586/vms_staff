import 'package:flutter/material.dart';

import '../../shared/shared.dart';

enum VisitorType {
  visitor,
  vip1,
  vip2,
  vip3,
}

class QueueItemModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String? placeOfWork;
  final String? designation;
  String picture;
  final String time;
  final String visitLocation;
  final String accessGate;
  final String bookingNo;
  final VisitorType visitorType;

  QueueItemModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.placeOfWork,
    required this.designation,
    required this.picture,
    required this.time,
    required this.visitLocation,
    required this.accessGate,
    required this.bookingNo,
    this.visitorType = VisitorType.visitor,
  }) {
    if (!picture.startsWith("http")) {
      picture = (AppSettings().baseUrl ?? ApiConstants.baseUrl) + picture;
    }
  }

  // Convert a Map to a QueueItemModel instance
  factory QueueItemModel.fromMap(Map<String, dynamic> map) {
    return QueueItemModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      placeOfWork: map['placeOfWork'] as String,
      designation: map['designation'] as String,
      picture: map['picture'] as String,
      time: map['time'] as String,
      visitLocation: map['visitLocation'] as String,
      accessGate: map['accessGate'] as String,
      bookingNo: map['bookingNo'] as String,
      visitorType: map['visitorType'] == null
          ? VisitorType.visitor
          : VisitorType.values.byName(map['visitorType']),
    );
  }

  static List<QueueItemModel> fromMapArray(List payloads) {
    return payloads.map((e) => QueueItemModel.fromMap(e)).toList();
  }

  // Convert a QueueItemModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'placeOfWork': placeOfWork,
      'designation': designation,
      'picture': picture,
      'time': time,
      'visitLocation': visitLocation,
      'accessGate': accessGate,
      'bookingNo': bookingNo,
      'visitorType': visitorType.name,
    };
  }

  // Create a copy of the current instance with optional new values
  QueueItemModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? placeOfWork,
    String? designation,
    String? picture,
    String? time,
    String? visitLocation,
    String? accessGate,
    String? bookingNo,
  }) {
    return QueueItemModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      placeOfWork: placeOfWork ?? this.placeOfWork,
      designation: designation ?? this.designation,
      picture: picture ?? this.picture,
      time: time ?? this.time,
      visitLocation: visitLocation ?? this.visitLocation,
      accessGate: accessGate ?? this.accessGate,
      bookingNo: bookingNo ?? this.bookingNo,
    );
  }

  Color getColor() {
    switch (visitorType) {
      case VisitorType.visitor:
        return Colors.grey;
      case VisitorType.vip1:
        return Colors.yellow;
      case VisitorType.vip2:
        return Colors.green;
      case VisitorType.vip3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getVisitorLabel() {
    switch (visitorType) {
      case VisitorType.visitor:
        return "";
      case VisitorType.vip1:
        return "I";
      case VisitorType.vip2:
        return "II";
      case VisitorType.vip3:
        return "III";
    }
  }
}
