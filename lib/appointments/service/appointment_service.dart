import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/shared/shared.dart';

class AppointmentService {
  final _dioClient = DioClient();

  Future<AppointmentModel> createMeeting(AppointmentModel meeting) async {
    final data = {
      "guest": meeting.guest?.id,
      "staff": meeting.staff,
      "eventName": meeting.label,
      "guestPhone": meeting.guest?.phone,
      "calendar": meeting.calendar,
      if (meeting.host != null)
        "host": {
          '_id': meeting.host?.id,
          'designation': meeting.host?.designation,
          'email': meeting.host?.email,
          'firstName': meeting.host?.firstName,
          'lastName': meeting.host?.lastName,
          'phone': meeting.host?.phone,
          'placeOfWork': meeting.host?.placeOfWork,
        },
      "date": meeting.date.toString().split(" ")[0],
      "time": meeting.date.toString().split(" ")[1].substring(0, 5),
      "visitLocation": meeting.visitLocation,
      "accessGate": meeting.accessGate,
      "description": meeting.description,
    };

    if (meeting.hostname != null) {
      data.addAll({"hostname": meeting.hostname});
    }

    final response =
        await _dioClient.post(ApiConstants.postCreateAppointment, data: data);

    if (response["ok"] ?? false) {
      return meeting;
    } else {
      throw response["message"] ??
          "An unknown error occurred, please try again later";
    }
  }

  Future<AppointmentModel> rescheduleAppointment(
      AppointmentModel meeting) async {
    final data = {
      "date": meeting.date.toString().split(" ")[0],
      "time": meeting.date.toString().split(" ")[1].substring(0, 5),
    };
    final response = await _dioClient
        .put(ApiConstants.putRescheduleAppointment(meeting.id), data: data);

    if (response["ok"] ?? false) {
      return meeting;
    } else {
      throw response["message"] ??
          "An unknown error occurred, please try again later";
    }
  }

  Future<bool> cancelAppointment(AppointmentModel meeting) async {
    final response =
        await _dioClient.put(ApiConstants.putCancelAppointment(meeting.id));

    if (response["ok"] ?? false) {
      return true;
    } else {
      throw response["message"] ??
          "An unknown error occurred, please try again later";
    }
  }

  Future<AppointmentModel> updateMeeting(AppointmentModel meeting) async {
    // InternetGrabber grabber = InternetGrabber();
    // ApiResponse result = await grabber.request(
    //     endpoint: MEETING_PATH+'/'+meeting.id,
    //     method: 'PUT',
    //     params: {
    //       "label":meeting.label,
    //       "agenda":meeting.agenda,
    //       "date":meeting.date.toIso8601String(),
    //       "locationAddress":meeting.locationAddress,
    //       "locationCoordinates": {
    //         "latitude": meeting.locationLat,
    //         "longitude": meeting.locationLong
    //       },
    //       "invitedUserIds": List.generate(meeting.invitedUsers?.length ??0, (index) => meeting.invitedUsers?[index].id)
    //     });

    return meeting;
  }

  Future<List<User>> searchUsersByPhone(String phone,
      {int page = 1, int pageSize = 10, String? deptAdminLocation}) async {
    final apiEndpoint =
        ApiConstants.searchStaffByPhone(phone, filter: deptAdminLocation);
    final result = await _dioClient.get(apiEndpoint);
    ApiResponse response = ApiResponse.fromMap(result, dataField: 'staff');
    if (response.data != null) {
      final users = User.fromMapArray(response.data);
      return users;
    }
    return [];
  }

  Future<List<AppointmentModel>> getMeetings(
      {int page = 1,
      int pageSize = 10,
      DateTime? fromTime,
      DateTime? toTime}) async {
    final endpoint =
        "${ApiConstants.getMyAppointments}?from=${fromTime?.toIso8601String()}&to=${toTime?.toIso8601String()}";
    final result = await _dioClient.get(endpoint);
    ApiResponse response =
        ApiResponse.fromMap(result, dataField: 'appointments');
    if (!(response.ok ?? false)) {
      throw response.message ?? "An unknown error occurred";
    }
    // return [
    //   AppointmentModel(date: DateTime.now().subtract(const Duration(minutes: 5)), id: '123', label: "Disbursal of funds", invitedUser: VisitorModel(id: '1', firstName: 'Yakubu', lastName: 'Ismail', userType: VisitorType.vip, placeOfWork: "ZITDA", designation: "Chief Accountant", phone: ""),locationAddress: 'Governor\'s Office' ),
    //   AppointmentModel(date: DateTime.now().add(const Duration(minutes: 30)), id: '123', label: "Disbursal of funds", invitedUser: VisitorModel(id: '1', firstName: 'Yakubu', lastName: 'Ismail', userType: VisitorType.vip, placeOfWork: "ZITDA", designation: "Chief Accountant", phone: ""),locationAddress: 'Governor\'s Office' ),
    //   AppointmentModel(date: DateTime.now().add(const Duration(minutes: 60)), id: '23', label: "Disbursal of funds", invitedUser: VisitorModel(id: '1', firstName: 'Yakubu', lastName: 'Ismail', userType: VisitorType.vip, placeOfWork: "ZITDA", designation: "Chief Accountant", phone: ""),locationAddress: 'Governor\'s Office' ),
    //   AppointmentModel(date: DateTime.now().add(const Duration(minutes: 90)), id: '13', label: "Disbursal of funds", invitedUser: VisitorModel(id: '1', firstName: 'Yakubu', lastName: 'Ismail', userType: VisitorType.vip, placeOfWork: "ZITDA", designation: "Chief Accountant", phone: ""),locationAddress: 'Governor\'s Office' ),
    //   AppointmentModel(date: DateTime.now().add(const Duration(minutes: 120)), id: '1', label: "Disbursal of funds", invitedUser: VisitorModel(id: '1', firstName: 'Yakubu', lastName: 'Ismail', userType: VisitorType.vip, placeOfWork: "ZITDA", designation: "Chief Accountant", phone: ""),locationAddress: 'Governor\'s Office' ),
    // ];
    return AppointmentModel.parseMany(response.data);
  }
}
