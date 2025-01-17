import 'package:shevarms_user/visitor_enrolment/model/model.dart';

class AppointmentModel {
  static const String MEETING_PATH = '/api/v1/meeting';

  String id;
  String label;
  String staff;
  String description;
  String calendar;
  String visitLocation;
  String accessGate;
  DateTime date;
  String? time;
  bool meetingFinished;
  VisitorModel? guest;

  AppointmentModel(
      {this.id = "",
      this.label = "",
      this.staff = "",
      this.description = "",
      this.visitLocation = "",
      this.accessGate = "",
      this.time,
      this.calendar = "Others",
      required this.date,
      this.meetingFinished = false,
      this.guest}) {
    meetingFinished =
        date.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch;
  }

  static AppointmentModel parse(Map<String, dynamic> obj) {
    return AppointmentModel(
        id: obj['_id'] ?? obj['id'] ?? '',
        staff: obj['staff'] ?? '',
        label: obj['label'] ?? obj['eventName'] ?? '',
        description: obj['description'] ?? '',
        calendar: obj['calendar'] ?? 'Others',
        time: obj['time'] ?? '',
        date: obj.containsKey('date')
            ? DateTime.parse(obj['date'])
            : DateTime.fromMillisecondsSinceEpoch(0),
        visitLocation: obj['visitLocation'] ?? "",
        accessGate: obj['accessGate'] ?? "",
        guest:
            obj['guest'] == null ? null : VisitorModel.fromMap(obj['guest']));
  }

  static List<AppointmentModel> parseMany(List<dynamic> items) {
    return List.generate(items.length,
        (index) => parse(Map<String, dynamic>.from(items[index])));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staff': staff,
      'eventName': label,
      'description': description,
      'calendar': calendar,
      'time': time,
      'date': date.toIso8601String(),
      'visitLocation': visitLocation,
      'accessGate': accessGate,
      'guest': guest?.toMap(),
    };
  }
}
