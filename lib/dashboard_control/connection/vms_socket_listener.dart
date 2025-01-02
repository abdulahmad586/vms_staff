import 'dart:convert';

import 'package:shevarms_user/dashboard_control/dashboard_control.dart';

class VMSSocketListener {
  static const String EVENT_DASHBOARD_SHUTDOWN = "DASHBOARD:SHUTDOWN";
  static const String EVENT_DASHBOARD_LOGIN = "DASHBOARD:LOGIN";
  static const String EVENT_DASHBOARD_LOGOUT = "DASHBOARD:LOGOUT";
  static const String EVENT_DASHBOARD_STATUS_ONLINE = "DASHBOARD:STATUS:ONLINE";

  static const String EVENT_FETCH_APPOINTMENT_QUEUE = "fetchAppointmentQueue";
  static const String EVENT_REPLY_FETCH_APPOINTMENT_QUEUE =
      "replyFetchAppointmentQueue";
  static const String EVENT_DASHBOARD_STATUS_OFFLINE =
      "DASHBOARD:STATUS:OFFLINE";
  static const String EVENT_DASHBOARD_STATUS_LOGGEDIN =
      "DASHBOARD:STATUS:LOGGEDIN";

  static const String EVENT_REPLY_CALL_IN = "replyCallIn";
  static const String EVENT_CALL_IN = "callIn";
  static const String EVENT_MARK_AS_DONE = "markAsDone";
  static const String EVENT_TV_LOGIN = "login";
  static const String EVENT_TV_LOGOUT = "logout";
  static const String EVENT_CALL_IN_APPOINTMENT = "callIn";
  static const String EVENT_REPLY_TV_LOGIN = "replyLogin";
  static const String EVENT_GET_ONLINE_TVS = "getOnlineTvs";
  static const String EVENT_REPLY_GET_ONLINE_TVS = "replyGetOnlineTvs";
  static const String EVENT_SLIDES_UPDATE = "SLIDES:UPDATE";
  static const String EVENT_SLIDES_TIMER_UPDATE = "SLIDES:TIMER:UPDATE";

  VMSSocketClient connection;
  Function(DashboardTvModel)? onDashboardLoggedIn;
  Function(List<DashboardTvModel>)? onReplyGetOnlineTvs;
  Function(DashboardTvModel)? onDashboardOffline;
  Function(DashboardTvModel)? onDashboardOnline;
  Function(String)? onCalledIn;
  Function(String dashboardId, List<QueueItemModel> queue)?
      onDashboardQueueUpdate;

  VMSSocketListener({
    required this.connection,
    this.onDashboardLoggedIn,
    this.onDashboardOffline,
    this.onDashboardOnline,
    this.onReplyGetOnlineTvs,
    this.onDashboardQueueUpdate,
    this.onCalledIn,
  }) {
    init();
  }

  void init() {
    if (onReplyGetOnlineTvs != null) {
      connection.listen(EVENT_REPLY_GET_ONLINE_TVS, (dashboardPayloads) {
        print("Received DASHBOARDS $dashboardPayloads");
        onReplyGetOnlineTvs?.call(
            DashboardTvModel.fromMapArray(jsonDecode(dashboardPayloads)));
      });
    }
    if (onDashboardLoggedIn != null) {
      connection.listen(EVENT_REPLY_TV_LOGIN, (dashboardPayload) {
        print("Received LOGGED IN STATUS through socket $dashboardPayload");
        if (dashboardPayload['dashId'] != null &&
            dashboardPayload['queue'] != null) {
          List<QueueItemModel> queue =
              QueueItemModel.fromMapArray(dashboardPayload['queue']);
          if (onDashboardQueueUpdate != null) {
            onDashboardQueueUpdate?.call(dashboardPayload['dashId'], queue);
          }
        }
        // if (dashboardPayload[0] != null) {
        //   DashboardTvModel dashboardModel =
        //       DashboardTvModel.fromMap(dashboardPayload[0]);
        //   if (onDashboardLoggedIn != null) onDashboardLoggedIn!(dashboardModel);
        // }
      });
    }
    if (onDashboardOffline != null) {
      connection.listen(EVENT_DASHBOARD_STATUS_OFFLINE, (dashboardPayload) {
        // print("Received OFFLINE STATUS through socket ${dashboardPayload[0]}");
        if (dashboardPayload[0] != null) {
          DashboardTvModel dashboardModel =
              DashboardTvModel.fromMap(dashboardPayload[0]);
          if (onDashboardOffline != null) onDashboardOffline!(dashboardModel);
        }
      });
    }
    if (onDashboardOnline != null) {
      connection.listen(EVENT_DASHBOARD_STATUS_ONLINE, (dashboardPayload) {
        if (dashboardPayload[0] != null) {
          DashboardTvModel dashboardModel =
              DashboardTvModel.fromMap(dashboardPayload[0]);
          if (onDashboardLoggedIn != null) onDashboardOnline!(dashboardModel);
        }
      });
    }
    if (onDashboardQueueUpdate != null) {
      connection.listen(EVENT_REPLY_FETCH_APPOINTMENT_QUEUE, (queueResponse) {
        if (queueResponse is String) {
          queueResponse = jsonDecode(queueResponse);
        }
        print(
            "RECEIVED UPDATE ON QUEUE: ${queueResponse.runtimeType} ${queueResponse} ");
        if (queueResponse['dashId'] != null && queueResponse['queue'] != null) {
          List<QueueItemModel> queue =
              QueueItemModel.fromMapArray(queueResponse['queue']);
          if (onDashboardQueueUpdate != null) {
            onDashboardQueueUpdate?.call(queueResponse['dashId'], queue);
          }
        }
      });
    }
    if (onCalledIn != null) {
      connection.listen(EVENT_REPLY_CALL_IN, (callInResponse) {
        if (callInResponse is String) {
          callInResponse = jsonDecode(callInResponse);
        }
        print("RECEIVED CALL IN FOR USER: $callInResponse");
        if (callInResponse['ok'] == true) {
          String bookingNumber = callInResponse['bookingNo'];
          if (onCalledIn != null) {
            onCalledIn?.call(bookingNumber);
          }
        }
      });
    }
  }

  void listenForTvQueue(String dashboardId) {
    connection.emit(EVENT_FETCH_APPOINTMENT_QUEUE, {'dashId': dashboardId});
  }

  void unlistenForTvQueue() {
    connection.unlisten(EVENT_REPLY_FETCH_APPOINTMENT_QUEUE);
  }

  void listenForOnlineTVs() {
    connection.emit(EVENT_GET_ONLINE_TVS, {});
  }

  void loginDashboard(
      String id, String username, String password, String tvSocketId) {
    connection.emit(EVENT_TV_LOGIN, {
      'dashId': id,
      'username': username,
      'password': password,
      'tvSocketId': tvSocketId
    });
  }

  void logoutDashboard(String id) {
    connection.emit(EVENT_TV_LOGOUT, {
      'dashId': id,
    });
  }

  void callInAppointment(String dashboardId, String bookingNumber) {
    connection.emit(EVENT_TV_LOGIN, {
      'dashId': dashboardId,
      'bookingNo': bookingNumber,
    });
  }

  void markAppointmentAsDone(String dashboardId, String bookingNumber) {
    connection.emit(EVENT_TV_LOGIN, {
      'dashId': dashboardId,
      'bookingNo': bookingNumber,
    });
  }

  void dispose() {
    connection.unlisten(EVENT_GET_ONLINE_TVS);
    connection.unlisten(EVENT_DASHBOARD_STATUS_LOGGEDIN);
    connection.unlisten(EVENT_DASHBOARD_STATUS_OFFLINE);
    connection.unlisten(EVENT_DASHBOARD_STATUS_ONLINE);
    connection.unlisten(EVENT_REPLY_FETCH_APPOINTMENT_QUEUE);
    connection.unlisten(EVENT_REPLY_CALL_IN);
    connection.closeConnection();
  }
}
