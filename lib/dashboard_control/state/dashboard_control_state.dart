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
        emit(state.copyWith(onlineTVs: tvs));
      },
      onDashboardLoggedIn: (DashboardTvModel tv) {
        if (tv.username == state.tv?.username) {
          emit(state.copyWith(state: DashboardTvState.loggedIn));
        }
      },
      onDashboardQueueUpdate: (String dashboardId, List<QueueItemModel> queue) {
        if (state.queueListener?.containsKey(dashboardId) ?? false) {
          state.queueListener![dashboardId]?.call(queue);
        }
      },
      onCalledIn: (String bookingNumber) {
        emit(state.copyWith(state: DashboardTvState.offline));
      },
    );
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
  }

  void loginMyDashboard(DashboardTvModel tv, String username, String password) {
    _listener?.loginDashboard(tv.id, username, password, tv.tvSocketId ?? "");
  }

  void listenForDashboardQueue(
      String id, Function(List<QueueItemModel> queue) listener) {
    if (!(state.queueListener?.containsKey(id) ?? false)) {
      final queueListener = state.queueListener ?? {};
      queueListener.addAll({id: listener});
      emit(state.copyWith(queueListener: queueListener));
    }
    _listener?.listenForTvQueue(id);
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

  void callInVisitor(String id, String bookingNo) {
    _listener?.callInAppointment(id, bookingNo);
  }

  void markAppointmentDone(String id, String bookingNo) {
    _listener?.markAppointmentAsDone(id, bookingNo);
  }
}

class DashboardControlState {
  DashboardTvState? state;
  String? error;
  DashboardTvModel? tv;
  List<DashboardTvModel>? onlineTVs;
  bool? loading;
  bool? socketConnected;
  Map<String, Function(List<QueueItemModel> queue)>? queueListener;
  Function(String)? callInListener;

  DashboardControlState({
    this.state,
    this.tv,
    this.onlineTVs,
    this.error,
    this.loading,
    this.socketConnected,
    this.queueListener,
    this.callInListener,
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
    Map<String, Function(List<QueueItemModel> queue)>? queueListener,
    Function(String)? callInListener,
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
    );
  }
}
