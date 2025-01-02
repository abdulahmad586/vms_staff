import 'dart:collection';

import 'package:shevarms_user/reminder/reminder.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:table_calendar/table_calendar.dart';

class ReminderService {
  final _dioClient = DioClient();

  final kEvents = LinkedHashMap<DateTime, List<ReminderModel>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(
      groupAppointmentsByDate(sampleReminders),
    );

  static LinkedHashMap<DateTime, List<ReminderModel>> groupAppointmentsByDate(
      List<ReminderModel> appointments) {
    LinkedHashMap<DateTime, List<ReminderModel>> events =
        LinkedHashMap<DateTime, List<ReminderModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (var appointment in appointments) {
      DateTime date = DateTime(
          appointment.date.year, appointment.date.month, appointment.date.day);
      if (events.containsKey(date)) {
        events[date]!.add(appointment);
      } else {
        events[date] = [appointment];
      }
    }

    return events;
  }

  Future<ReminderModel> createReminder(
      User user, ReminderModel reminder) async {
    try {
      final data = {
        'userId': user.id,
        'phone': user.phone,
        'title': reminder.title,
        'description': reminder.description,
        'type': reminder.calendarModelType,
        'date': "${reminder.date.toIso8601String().split('.').first}Z",
        'time': reminder.date.toString().split(" ")[1].substring(0, 5),
        'sms': reminder.sms,
        'fSms': reminder.fsms,
        'ring': reminder.ring,
        'tts': reminder.tts,
        'email': reminder.email,
        'voice': reminder.voice,
        'conferencing': reminder.conferencing,
        'voiceData': reminder.voiceData,
      };

      final result =
          await _dioClient.post(ApiConstants.postCreateReminder, data: data);

      ApiResponse response = ApiResponse.fromMap(result, dataField: 'reminder');
      if (response.ok ?? false) {
        return reminder;
      } else {
        throw response.message ?? "An unknown error occurred, please try again";
      }
    } catch (e) {
      rethrow;
    }
  }
}

final List<ReminderModel> sampleReminders = [
  ReminderModel(
      id: 'id-1',
      title: "Call a friend",
      description: "Call an old friend",
      calendarModelType: "Personal",
      date: DateTime.now().add(const Duration(minutes: 45)),
      createdAt: DateTime.now())
];
