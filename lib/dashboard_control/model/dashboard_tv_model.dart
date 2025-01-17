enum DashboardTvState {
  offline,
  online,
  loggedIn,
}

class DashboardTvModel {
  final String id;
  final String name;
  final String? group;
  final String? username;
  final String? password;
  final String location;
  final String? tvSocketId;
  final DashboardTvState status;

  const DashboardTvModel({
    required this.id,
    required this.name,
    required this.username,
    this.group,
    required this.password,
    required this.location,
    this.tvSocketId,
    this.status = DashboardTvState.offline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'group': group,
      'location': location,
      'tvSocketId': tvSocketId,
      'status': status.name,
    };
  }

  factory DashboardTvModel.fromMap(Map<String, dynamic> json) {
    return DashboardTvModel(
      id: json['id'] ?? json['dashId'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      location: json['location'],
      group: json['group'],
      tvSocketId: json['tvSocketId'],
      status: DashboardTvState.values.byName(json['status'] ?? "offline"),
    );
  }

  static List<DashboardTvModel> fromMapArray(List payloads) {
    return payloads.map((e) => DashboardTvModel.fromMap(e)).toList();
  }
}
