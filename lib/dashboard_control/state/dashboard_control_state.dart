import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardControlCubit extends Cubit<DashboardControlState> {
  final RefreshController? refreshController;
  final DashboardControlService service = DashboardControlService();
  VMSSocketListener? _listener;

  DashboardControlCubit(super.initialState, {this.refreshController}) {
    getDashboard();
    initTVState();
  }

  refreshDashboards() {
    _listener?.listenForOnlineTVs();
  }

  void initTVState() {
    print("Initializing socket!");
    if (_listener != null) {
      _listener?.dispose();
    }
    _listener = VMSSocketListener(
        connection: VMSSocketClient(
            url: /*"http://10.8.0.9:3000"*/
                AppSettings().baseUrl ?? ApiConstants.baseUrl,
            connectionChange: (connected) {
              emit(state.copyWith(socketConnected: connected));
              if (connected) {
                getOnlineTVs();
              }
            }),
        onReplyGetOnlineTvs: (tvs) {
          final myDashboards = state.userDashboards ?? <String>[];
          final myTvs = tvs.where((tv) {
            return myDashboards.contains("${tv.id}-${tv.group}");
          }).toList();
          emit(state.copyWith(onlineTVs: myTvs));
        },
        onDashboardLoggedIn: (queue) {
          emit(state.copyWith(activeDashboardInitQueue: queue));
        },
        onDashboardQueueUpdate:
            (String dashboardId, List<QueueItemModel> queue) {
          if (state.queueListener?.containsKey(dashboardId) ?? false) {
            state.queueListener![dashboardId]?.call(queue);
          }
        },
        onRemoveAppointment: (String apId) {
          if (state.removeAppointmentListener?.values.isNotEmpty ?? false) {
            print("Sending remove ap");
            state.removeAppointmentListener?.values.first(apId);
          } else {
            print("No listener");
          }
        },
        onCalledIn: (String bookingNumber) {
          state.callInListener?.call(bookingNumber);
        },
        onNewAppointment: (QueueItemModel newAppointment) {
          if (state.newAppointmentListener?.values.isNotEmpty ?? false) {
            print("Sending new ap");
            state.newAppointmentListener?.values.first(newAppointment);
          } else {
            print("No listener");
          }
        });
  }

  void getOnlineTVs() {
    _listener?.listenForOnlineTVs();
  }

  void getDashboard({bool refresh = false}) async {
    emit(state.copyWith(clearError: true));
    try {
      refreshController?.refreshCompleted();
      final tv = await service.getMyDashboard();
      refreshController?.loadComplete();
      emit(state.copyWith(loading: false, clearError: true, tv: tv));
    } catch (e) {
      print(e);
      refreshController?.refreshCompleted();
      refreshController?.loadFailed();
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void logoutMyDashboard(
    DashboardTvModel tv,
  ) {
    _listener?.logoutDashboard(tv.id);
    emit(state.copyWith(activeDashboard: ""));
  }

  void loginMyDashboard(DashboardTvModel tv) {
    _listener?.loginDashboard(tv.id, tv.group ?? "");
    emit(state.copyWith(activeDashboard: tv.id));
  }

  void listenForDashboardQueue(String id, String group,
      Function(List<QueueItemModel> queue, {bool? isNew}) listener) {
    if (!(state.queueListener?.containsKey(id) ?? false)) {
      final queueListener = state.queueListener ?? {};
      queueListener.addAll({id: listener});
      emit(state.copyWith(queueListener: queueListener));
    }
    _listener?.listenForTvQueue(id, group);
  }

  void unlistenForDashboardQueue(String id) {
    if ((state.queueListener?.containsKey(id) ?? false)) {
      final queueListener = state.queueListener ?? {};
      queueListener.removeWhere((key, value) => key == id);
      emit(state.copyWith(queueListener: queueListener));
    }
    if (state.queueListener?.isEmpty ?? true) {
      _listener?.unlistenForTvQueue();
    }
  }

  listenForCallIn(Function(String)? listener) {
    emit(state.copyWith(
        callInListener: listener, clearCallInListener: listener == null));
  }

  void callInVisitor(String dashId, String group, String apId) {
    _listener?.callInAppointment(dashId, group, apId);
  }

  void markAppointmentDone(String dashId, String group, String apId) {
    _listener?.markAppointmentAsDone(dashId, group, apId);
  }

  void updateUserDashboards(List<String> dashboards) {
    emit(state.copyWith(userDashboards: dashboards));
  }

  void shutdownMyDashboard(DashboardTvModel tv) {
    _listener?.shutdownDashboard(tv.id, tv.group);
  }

  void listenForNewAppointment(
      String id, String groupId, Function(QueueItemModel queue) onNewAP) {
    emit(state.copyWith(newAppointmentListener: {id: onNewAP}));
  }

  void listenForRemoveAppointment(
      String id, String groupId, Function(String apId) onRemoveAP) {
    emit(state.copyWith(removeAppointmentListener: {id: onRemoveAP}));
  }

  void unlistenForAppointments() {
    emit(state.copyWith(clearNewAppointmentListener: true));
  }
}

class DashboardControlState {
  DashboardTvState? state;
  String? error;
  DashboardTvModel? tv;
  List<DashboardTvModel>? onlineTVs;
  bool? loading;
  bool? socketConnected;
  Map<String, Function(List<QueueItemModel> queue, {bool? isNew})>?
      queueListener;
  Function(String)? callInListener;
  List<String>? userDashboards;
  String? activeDashboard;
  List<QueueItemModel>? activeDashboardInitQueue;
  Map<String, Function(QueueItemModel queue)>? newAppointmentListener;
  Map<String, Function(String apId)>? removeAppointmentListener;

  DashboardControlState({
    this.state,
    this.tv,
    this.onlineTVs,
    this.error,
    this.loading,
    this.socketConnected,
    this.queueListener,
    this.callInListener,
    this.userDashboards,
    this.activeDashboard,
    this.activeDashboardInitQueue,
    this.newAppointmentListener,
    this.removeAppointmentListener,
  });

  int get loggedInLength =>
      onlineTVs
          ?.where((element) => element.status == DashboardTvState.loggedIn)
          .length ??
      0;

  DashboardControlState copyWith({
    DashboardTvState? state,
    DashboardTvModel? tv,
    List<DashboardTvModel>? onlineTVs,
    bool? loading,
    bool? socketConnected,
    String? error,
    bool clearError = false,
    bool clearCallInListener = false,
    Map<String, Function(List<QueueItemModel> queue, {bool? isNew})>?
        queueListener,
    Function(String)? callInListener,
    List<String>? userDashboards,
    String? activeDashboard,
    List<QueueItemModel>? activeDashboardInitQueue,
    Map<String, Function(QueueItemModel queue)>? newAppointmentListener,
    Map<String, Function(String apId)>? removeAppointmentListener,
    bool clearNewAppointmentListener = false,
    bool clearRemoveAppointmentListener = false,
  }) {
    return DashboardControlState(
      state: state ?? this.state,
      onlineTVs: onlineTVs ?? this.onlineTVs,
      error: clearError ? null : error ?? this.error,
      loading: loading ?? this.loading,
      socketConnected: socketConnected ?? this.socketConnected,
      tv: tv ?? this.tv,
      queueListener: queueListener ?? this.queueListener,
      callInListener:
          clearCallInListener ? null : callInListener ?? this.callInListener,
      userDashboards: userDashboards ?? this.userDashboards,
      activeDashboard: activeDashboard ?? this.activeDashboard,
      activeDashboardInitQueue:
          activeDashboardInitQueue ?? this.activeDashboardInitQueue,
      newAppointmentListener: clearNewAppointmentListener
          ? null
          : newAppointmentListener ?? this.newAppointmentListener,
      removeAppointmentListener: clearRemoveAppointmentListener
          ? null
          : removeAppointmentListener ?? this.removeAppointmentListener,
    );
  }
}
