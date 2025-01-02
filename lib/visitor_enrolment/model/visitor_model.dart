import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';

enum VisitorStatus { active, pending, suspended }

enum VisitorType { visitor, vip, vvip, vvvip }

class VisitorModel {
  static const defaultProfileImage =
      'https://res.cloudinary.com/verdant/image/upload/v1481824342/nopic_profile_w7smzi.jpg';
  final String id;
  final String firstName;
  final String lastName;
  final String? placeOfWork;
  final String? designation;
  final String? email;
  final String phone;
  final String? address;
  final String picture;
  final VisitorType userType;
  final VisitorStatus status;

  String get fullName => "$firstName $lastName";

  VisitorModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.designation = "",
      this.picture = defaultProfileImage,
      required this.phone,
      this.email,
      this.address = "",
      this.placeOfWork = "",
      this.userType = VisitorType.visitor,
      this.status = VisitorStatus.pending});

  factory VisitorModel.fromMap(Map<String, dynamic> map) {
    return VisitorModel(
      id: map["_id"] ?? map["id"] ?? "",
      firstName: map["firstName"],
      lastName: map["lastName"],
      placeOfWork: map["pow"] ?? map["placeOfWork"] ?? "No data available",
      designation: map["designation"] ?? "No data available",
      phone: map["phone"],
      email: map["email"] ?? "No data available",
      picture: map["picture"],
      address: map["address"] ?? "No data available",
      userType: map['userType'] == null
          ? VisitorType.visitor
          : VisitorType.values.byName(map['userType']),
      status: map['status'] == null
          ? VisitorStatus.pending
          : VisitorStatus.values.byName(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "placeOfWork": placeOfWork,
      "picture": picture,
      "designation": designation,
      "email": email,
      "address": address,
      "userType": userType.name,
      "status": status.name
    };
  }

  static String getPicture(String? path) {
    if (path == null) {
      return defaultProfileImage;
    }
    if (path.startsWith("http")) {
      return path;
    }
    return (AppSettings().baseUrl ?? ApiConstants.baseUrl) + path;
  }

  static List<VisitorModel> fromMapArray(List<dynamic> list) {
    return list.map((e) => VisitorModel.fromMap(e)).toList();
  }

  Color getColor() {
    switch (userType) {
      case VisitorType.visitor:
        return Colors.grey;
      case VisitorType.vip:
        return Colors.yellow;
      case VisitorType.vvip:
        return Colors.green;
      case VisitorType.vvvip:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getVisitorLabel() {
    switch (userType) {
      case VisitorType.visitor:
        return "";
      case VisitorType.vip:
        return "I";
      case VisitorType.vvip:
        return "II";
      case VisitorType.vvvip:
        return "III";
    }
  }

  static getVisitor(String id) {
    return VisitorModel(
        id: 'id',
        firstName: 'Muhammad',
        lastName: "Tanko",
        phone: "090123455555",
        email: "teekay017@gmail.com",
        status: VisitorStatus.active);
  }

  static List<VisitorModel> getSampleVisitors() {
    return [
      VisitorModel(
          id: 'id1',
          firstName: 'Feyishola',
          lastName: "Ologunebi",
          phone: "070332303242",
          email: "feyisholaologunebi@gmail.com",
          status: VisitorStatus.active,
          userType: VisitorType.vip,
          placeOfWork: "ZITDA",
          designation: "Director"),
      VisitorModel(
          id: 'id2',
          firstName: 'Muhammad',
          lastName: "Tanko",
          phone: "07033333333",
          email: "teekay017@gmail.com",
          status: VisitorStatus.active,
          userType: VisitorType.vip,
          placeOfWork: "Lexington Technologies",
          designation: "Director of Research"),
      VisitorModel(
          id: 'id3',
          firstName: 'Umar',
          lastName: "Jere",
          phone: "070334232312",
          email: "umar.jere@gmail.com",
          userType: VisitorType.vvip,
          placeOfWork: "Jere Oils Ltd",
          designation: "C.E.O"),
      VisitorModel(
          id: 'id4',
          firstName: 'Abubakar',
          lastName: "Sadiq",
          phone: "070335232312",
          email: "abubakarsadiq@gmail.com",
          userType: VisitorType.visitor,
          placeOfWork: "NURTW",
          designation: "Accountant"),
    ];
  }
}
