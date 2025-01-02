import 'package:flutter/material.dart';

class CalendarUtils {
  static List<String> months = [
    'huh',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  static const List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static bool timeIsEqual(String time1, String time2) {
    try {
      int hour1 = int.parse(time1.split(":")[0]);
      int minute1 = int.parse(time1.split(":")[1]);
      int hour2 = int.parse(time2.split(":")[0]);
      int minute2 = int.parse(time2.split(":")[1]);

      return hour1 == hour2 && minute1 == minute2;
    } catch (e) {
      debugPrint("TimeUtils error $e");
    }

    return false;
  }

  static bool timeIsGreater(String time1, String time2) {
    try {
      int hour1 = int.parse(time1.split(":")[0]);
      int minute1 = int.parse(time1.split(":")[1]);
      int hour2 = int.parse(time2.split(":")[0]);
      int minute2 = int.parse(time2.split(":")[1]);

      return (hour1 > hour2) || (hour1 == hour2 ? minute1 > minute2 : false);
    } catch (e) {
      debugPrint("TimeUtils error $e");
    }

    return false;
  }

  static bool timeIsLesser(String time1, String time2) {
    try {
      int hour1 = int.parse(time1.split(":")[0]);
      int minute1 = int.parse(time1.split(":")[1]);
      int hour2 = int.parse(time2.split(":")[0]);
      int minute2 = int.parse(time2.split(":")[1]);

      return (hour1 < hour2) || (hour1 == hour2 ? minute1 < minute2 : false);
    } catch (e) {
      debugPrint("TimeUtils error $e");
    }

    return false;
  }

  static int calculateDuration(String from, String to) {
    int hour1 = int.parse(from.split(":")[0]);
    int minute1 = int.parse(from.split(":")[1]);
    int hour2 = int.parse(to.split(":")[0]);
    int minute2 = int.parse(to.split(":")[1]);

    DateTime now = DateTime.now();
    DateTime time1 = DateTime(now.year, now.month, now.day, hour1, minute1);
    DateTime time2 = DateTime(now.year, now.month, now.day, hour2, minute2);

    return time2.difference(time1).inMinutes;
  }

  static String timeInMsToString(int time, {bool includeTime = false}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    String dateStr = '${date.day} ${months[date.month]}, ${date.year}';
    String timeStr = '${date.hour}:${date.minute}';

    return '$dateStr ${includeTime ? timeStr : ''}';
  }

  static String timeRemaining(DateTime dateTime, DateTime dateTime2) {
    Duration difference = dateTime2.difference(dateTime);
    int days = difference.inDays;
    int hours = difference.inHours;

    if (days > 30 || days < -30) {
      return '${(days / 7).round()} wks';
    } else if (hours > 168 || hours < -168) {
      return '${(hours / 24).round()} dys';
    } else {
      return '$hours hrs';
    }
  }

  static numFormat(int num) {
    return num.toString().length > 1 ? num.toString() : '0$num';
  }

  static String timeToString(DateTime? time,
      {bool includeTime = false, bool reverse = false}) {
    if (time == null) return 'Time not specified';
    DateTime date = time;
    String dateStr = '${date.day} ${months[date.month]}, ${date.year}';
    String timeStr = '${numFormat(date.hour)}:${numFormat(date.minute)}';

    return reverse
        ? '${includeTime ? timeStr : ''} $dateStr'
        : '$dateStr ${includeTime ? timeStr : ''}';
  }

  static bool withinRange(DateTime dateTime,
      {required DateTime from, required DateTime to}) {
    return from.millisecondsSinceEpoch <= dateTime.millisecondsSinceEpoch &&
        to.millisecondsSinceEpoch >= dateTime.millisecondsSinceEpoch;
  }

  static bool isSameDay(DateTime dateTime, DateTime dateTime2) {
    return dateTime.day == dateTime2.day &&
        dateTime.month == dateTime2.month &&
        dateTime.year == dateTime2.year;
  }

  static Map<String, DateTime> getBeginningAndEndOfDay(DateTime date) {
    date = date.subtract(
        Duration(hours: date.hour, minutes: date.minute, seconds: date.second));

    DateTime endDate = date;
    endDate = endDate.subtract(
        Duration(hours: date.hour, minutes: date.minute, seconds: date.second));
    endDate = endDate.add(const Duration(
        hours: Duration.hoursPerDay - 1,
        minutes: Duration.minutesPerHour - 1,
        seconds: Duration.secondsPerMinute - 1));
    return {'from': date, 'to': endDate};
  }

  static Map<String, DateTime> getBeginningAndEndOfMonth(DateTime date) {
    date = DateTime(date.year, date.month, 1);
    DateTime endDate = DateTime(date.year, date.month + 1, 0);
    return {'from': date, 'to': endDate};
  }

  static timeOfDayFromString(String str) {
    TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);
    try {
      time = TimeOfDay(
          hour: int.parse(str.split(":")[0]),
          minute: int.parse(str.split(":")[1]));
    } catch (e) {
      debugPrint("Error $e");
    }
    return time;
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
