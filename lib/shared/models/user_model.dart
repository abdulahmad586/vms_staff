import 'package:shevarms_user/shared/shared.dart';

enum UserStatus { active, pending, blocked }

enum UserType {
  admin,
  superUser,
  seniorStaff,
  cso,
  he,
  profiler,
  security,
  staff,
  paGovernor,
  chiefDetail,
  deptAdmin,
  pps,
  firstLady,
  paFirstLady,
  COS,
  DCOS,
}

UserType getUserType(String? str) {
  str = str == "HE" ? "he" : str;
  return str == null ? UserType.staff : UserType.values.byName(str);
}

class User {
  static const Map<UserType, String> typesLabel = {
    UserType.admin: "Admin",
    UserType.superUser: "Super User",
    UserType.seniorStaff: "Senior Staff",
    UserType.he: "His Excellency",
    UserType.cso: "CSO",
    UserType.profiler: "Profiler",
    UserType.security: "Security",
    UserType.staff: "Staff",
    UserType.paGovernor: "PA Governor",
    UserType.chiefDetail: "Chief Detail",
    UserType.deptAdmin: "Department Admin",
    UserType.pps: "Personal Secretary",
    UserType.firstLady: "First Lady",
    UserType.paFirstLady: "PA to First Lady",
    UserType.COS: "Chief of Staff",
    UserType.DCOS: "Deputy Chief of Staff",
  };

  String? get fullName => "$firstName $lastName";

  static UserType typesEnum(String label) {
    switch (label) {
      case "Admin":
        return UserType.admin;
      case "Super User":
        return UserType.superUser;
      case "Senior Staff":
        return UserType.seniorStaff;
      case "CSO":
        return UserType.cso;
      case "Profiler":
        return UserType.profiler;
      case "Security":
        return UserType.security;
      case "Staff":
        return UserType.staff;
      case "PA Governor":
        return UserType.paGovernor;
      case "Chief Detail":
        return UserType.chiefDetail;
      case "Department Admin":
        return UserType.deptAdmin;
      case "Personal Secretary":
        return UserType.pps;
      case "First Lady":
        return UserType.firstLady;
      case "PA to First Lady":
        return UserType.paFirstLady;
      case "Chief of Staff":
        return UserType.COS;
      case "Deputy Chief of Staff":
        return UserType.DCOS;
      default:
        return UserType.staff;
    }
  }

  static const defaultProfileImage =
      'https://res.cloudinary.com/verdant/image/upload/v1481824342/nopic_profile_w7smzi.jpg';
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? placeOfWork;
  final String? designation;
  final String? email;
  final String? location;
  final String? accessGate;
  final UserType userType;
  String picture;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<String>? dashboards;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.placeOfWork,
    this.designation,
    this.email,
    required this.location,
    required this.accessGate,
    this.userType = UserType.staff,
    this.picture = defaultProfileImage,
    this.createdAt,
    this.updatedAt,
    this.dashboards,
  }) {
    if (!picture.startsWith("http")) {
      picture = (AppSettings().baseUrl ?? ApiConstants.baseUrl) + picture;
    }
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["_id"] ?? map["id"],
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      phone: map["phone"],
      placeOfWork: map["placeOfWork"],
      designation: map["designation"],
      email: map["email"],
      location: map["location"],
      accessGate: map["accessGate"] ?? "",
      userType: getUserType(map['userType']),
      picture: map["picture"] ?? defaultProfileImage,
      dashboards: map['dashboards'] is List && map['dashboards'].isNotEmpty
          ? List<String>.from(map['dashboards'])
          : <String>[],
      createdAt:
          map["createdAt"] == null ? null : DateTime.parse(map['createdAt']),
      updatedAt:
          map["updatedAt"] == null ? null : DateTime.parse(map['updatedAt']),
    );
  }

  static List<User> fromMapArray(List<dynamic> list) {
    return list.map((e) => User.fromMap(e)).toList();
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? placeOfWork,
    String? designation,
    String? email,
    String? location,
    String? accessGate,
    UserType? userType,
    String? picture,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? dashboards,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      placeOfWork: placeOfWork ?? this.placeOfWork,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      location: location ?? this.location,
      accessGate: accessGate ?? this.accessGate,
      userType: userType ?? this.userType,
      picture: picture ?? this.picture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dashboards: dashboards ?? this.dashboards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "placeOfWork": placeOfWork,
      "designation": designation,
      "email": email,
      "location": location,
      "accessGate": accessGate,
      "userType": userType.name,
      "picture": picture,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "dashboards": dashboards,
    };
  }
}

var sampleUser = User(
  id: '232323',
  firstName: "Musa",
  lastName: "Suleiman",
  phone: "09012345678",
  location: null,
  accessGate: "",
  placeOfWork: "Lexington Technologies ltd.",
);
