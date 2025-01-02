import 'package:shevarms_user/notifications/notifications.dart' as app;

class Notification{

  static const String NOTIFICATION_PATH = '/api/v1/notification';

  String id;
  String label;
  String content;
  DateTime time;
  bool read;

  Notification({this.id="",this.label="", this.content="", required this.time, this.read=false});

  static Notification parse(Map<String, dynamic> obj){
    return Notification(
      id: obj['_id'] ?? '',
      label: obj['label'] ?? '',
      content: obj['content'] ?? '',
      time: obj.containsKey('created') ? DateTime.parse(obj['created']) : DateTime.fromMillisecondsSinceEpoch(0),
      read: obj['read'] ?? false,

    );
  }

  static List<Notification> parseMany(List<dynamic> items) {
    return List.generate(items.length,
            (index) => parse(Map<String, dynamic>.from(items[index])));
  }

  static Future<List<Notification>> getNotifications({int page = 1, int pageSize = 10, bool? read}) async {
    List<app.Notification> list = [
      app.Notification(time: DateTime(2023, 3, 23, 8, 30,0), label: "Upcoming meeting", content: "You have an upcoming meeting by 8:30am tomorrow", read: false),
      app.Notification(time: DateTime(2023, 3, 24, 11, 30,0), label: "Attendance verified", content: "Your attendance has been verified", read: false),
      app.Notification(time: DateTime(2023, 3, 26, 1, 30,0), label: "Meeting invitation", content: "You are invited to attend a meeting", read: true),
      app.Notification(time: DateTime(2023, 3, 27, 7, 30,0), label: "Upcoming meeting", content: "You have an upcoming meeting by 8:30am tomorrow", read: true),
      app.Notification(time: DateTime(2023, 3, 28, 9, 30,0), label: "Upcoming meeting", content: "You have an upcoming meeting by 8:30am tomorrow", read: true),
    ];
    return list;
  }

  static Future<bool> deleteNotification(String id) async {
    // InternetGrabber grabber = InternetGrabber();
    // ApiResponse result = await grabber.request(
    //     endpoint: NOTIFICATION_PATH+'/$id',
    //     method: 'DELETE'
    // );
    // if (result.statusOk) {
    //   return result.statusOk;
    // } else {
    //   return Future.error(result.message ?? 'An error occurred');
    // }
    return false;
  }

  static Future<bool> updateSeen(String id) async {
    // InternetGrabber grabber = InternetGrabber();
    // ApiResponse result = await grabber.request(
    //     endpoint: NOTIFICATION_PATH+'/mark_read/$id',
    //     method: 'PUT'
    // );
    // if (result.statusOk) {
    //   return result.statusOk;
    // } else {
    //   return Future.error(result.message ?? 'An error occurred');
    // }
    return false;
  }

}