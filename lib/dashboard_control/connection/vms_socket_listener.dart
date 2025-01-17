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
  static const String EVENT_ADD_NEW_APPOINTMENT = "add:new:appointment";
  static const String EVENT_REMOVE_APPOINTMENT =
      "remove:appointment"; //_id, group
  static const String EVENT_MARK_APPOINTMENT_DONE = "markAsDone"; //_id
  static const String EVENT_DASHBOARD_STATUS_OFFLINE =
      "DASHBOARD:STATUS:OFFLINE";
  static const String EVENT_DASHBOARD_STATUS_LOGGEDIN =
      "DASHBOARD:STATUS:LOGGEDIN";

  static const String EVENT_REPLY_CALL_IN = "replyCallin";
  static const String EVENT_CALL_IN = "callin";
  static const String EVENT_MARK_AS_DONE = "markAsDone";
  static const String EVENT_TV_LOGIN = "login";
  static const String EVENT_TV_SHUTDOWN = "shutdown";
  static const String EVENT_TV_LOGOUT = "logout";
  static const String EVENT_CALL_IN_APPOINTMENT = "callIn";
  static const String EVENT_REPLY_TV_LOGIN = "replyLogin";
  static const String EVENT_GET_ONLINE_TVS = "getOnlineTvs";
  static const String EVENT_REPLY_GET_ONLINE_TVS = "replyGetOnlineTvs";
  static const String EVENT_SLIDES_UPDATE = "SLIDES:UPDATE";
  static const String EVENT_SLIDES_TIMER_UPDATE = "SLIDES:TIMER:UPDATE";

  VMSSocketClient connection;
  Function(dynamic)? onDashboardLoggedIn;
  Function(List<DashboardTvModel>)? onReplyGetOnlineTvs;
  Function(DashboardTvModel)? onDashboardOffline;
  Function(DashboardTvModel)? onDashboardOnline;
  Function(QueueItemModel)? onNewAppointment;
  Function(String)? onRemoveAppointment;
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
    this.onNewAppointment,
    this.onRemoveAppointment,
  }) {
    init();
  }

  String? activeDashLogin;
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
        if (dashboardPayload is String) {
          dashboardPayload = jsonDecode(dashboardPayload);
        }
        // print("Received LOGGED IN STATUS through socket $dashboardPayload");
        // log(jsonEncode(dashboardPayload));
        if (activeDashLogin != null) {
          final dashboardId = activeDashLogin;

          activeDashLogin = null;

          List<QueueItemModel> queue =
              dashboardPayload['queue'].map<QueueItemModel>((item) {
            return QueueItemModel.fromDetailedMap(item);
          }).toList();
          if (onDashboardLoggedIn != null) {
            onDashboardLoggedIn?.call(queue);
          }
          if (onDashboardQueueUpdate != null) {
            onDashboardQueueUpdate?.call(dashboardId!, queue);
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
              QueueItemModel.fromDetailedMapArray(queueResponse['queue']);
          if (onDashboardQueueUpdate != null) {
            onDashboardQueueUpdate?.call(queueResponse['dashId'], queue);
          }
        }
      });
    }
    if (onNewAppointment != null) {
      connection.listen(EVENT_ADD_NEW_APPOINTMENT, (newAppointmentResponse) {
        if (newAppointmentResponse is String) {
          newAppointmentResponse = jsonDecode(newAppointmentResponse);
        }
        print(
            "RECEIVED NEW APPOINTMENT: ${newAppointmentResponse.runtimeType} ${newAppointmentResponse} ");
        final item = QueueItemModel.fromDetailedMap(
            newAppointmentResponse['appointment']);
        if (onNewAppointment != null) {
          onNewAppointment?.call(item);
        }
      });
    }

    if (onRemoveAppointment != null) {
      connection.listen(EVENT_REMOVE_APPOINTMENT, (response) {
        if (response is String) {
          response = jsonDecode(response);
        }
        final apId = response['_id'];
        print("RECEIVED REMOVE FOR APPOINTMENT $apId");

        if (onRemoveAppointment != null) {
          onRemoveAppointment?.call(apId);
        }
      });
    }
    if (onCalledIn != null) {
      connection.listen(EVENT_REPLY_CALL_IN, (callInResponse) {
        if (callInResponse is String) {
          callInResponse = jsonDecode(callInResponse);
        }
        print("RECEIVED CALL IN FOR USER: $callInResponse");
        onCalledIn?.call(callInResponse['_id']);
      });
    }
  }

  void listenForTvQueue(String dashboardId, String group) {
    connection.emit(
        EVENT_FETCH_APPOINTMENT_QUEUE, {'dashId': dashboardId, "group": group});
  }

  void unlistenForTvQueue() {
    connection.unlisten(EVENT_REPLY_FETCH_APPOINTMENT_QUEUE);
  }

  void listenForOnlineTVs() {
    connection.emit(EVENT_GET_ONLINE_TVS, {});
  }

  void loginDashboard(String id, String group) {
    activeDashLogin = id;
    connection.emit(EVENT_TV_LOGIN, {
      'dashId': id,
      'group': group,
      // 'tvSocketId': tvSocketId
    });
  }

  void logoutDashboard(String id) {
    connection.emit(EVENT_TV_LOGOUT, {
      'dashId': id,
    });
  }

  void callInAppointment(String dashboardId, String group, String apId) {
    connection.emit(EVENT_CALL_IN, {
      'dashId': dashboardId,
      'group': group,
      '_id': apId,
    });
  }

  void markAppointmentAsDone(
      String dashboardId, String group, String appointmentId) {
    connection.emit(
        EVENT_MARK_APPOINTMENT_DONE, {'_id': appointmentId, 'group': group});
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

  void shutdownDashboard(String id, String? group) {
    connection.emit(EVENT_TV_SHUTDOWN, {
      'dashId': id,
      'group': group,
    });
  }
}
