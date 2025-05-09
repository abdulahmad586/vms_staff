import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/appointments/appointments.dart';

class AppointmentsCubit extends Cubit<AppointmentState> {
  RefreshController refreshController;
  final AppointmentService service = AppointmentService();
  AppointmentsCubit(super.initialState, {required this.refreshController}) {
    getData();
  }

  void getData({bool refresh = false}) {
    emit(state.copyWith(loading: true, clearError: true));
    final page = refresh ? 1 : (state.page ?? 1) + 1;
    final pageSize = state.pageSize ?? AppointmentState.defaultPageSize;
    service
        .getMeetings(
      pageSize: pageSize,
      page: page,
      fromTime: state.fromTime,
      toTime: state.toTime,
    )
        .then((value) {
      refreshController.refreshCompleted();
      if (value.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }

      emit(state.copyWith(
        loading: false,
        list: refresh ? value : [...(state.list ?? []), ...value],
        page: page,
        dataFinish: value.length < pageSize,
      ));
    }).catchError((error, s) {
      print(s);
      refreshController.refreshCompleted();
      refreshController.loadFailed();
      emit(state.copyWith(loading: false, error: error.toString()));
    });
  }

  void nextPage({int increment = 1}) {
    if (state.dataFinish ?? false) return;
    getData();
  }

  void updateItem(int index, AppointmentModel? item) {
    List<AppointmentModel> list = [...(state.list ?? [])];
    list.replaceRange(index, index + 1, item == null ? [] : [item]);
    emit(state.copyWith(list: list));
  }

  void findAndUpdateItem(AppointmentModel? item) {
    if (item == null) return;
    int index = state.list!.indexOf(item);

    if (index == -1) return;

    List<AppointmentModel> list = [...(state.list ?? [])];
    list.replaceRange(index, index + 1, [item]);
    emit(state.copyWith(list: list));
  }

  void changeTimes(DateTime fromTime, DateTime toTime) {
    emit(state.copyWith(
        page: 1,
        list: [],
        fromTime: fromTime,
        toTime: toTime,
        dataFinish: false));
    getData();
  }

  void updateView(int i) {
    emit(state.copyWith(view: i));
  }
}

class AppointmentState {
  static const int defaultPageSize = 10;

  List<AppointmentModel>? list;
  bool? loading = true;
  bool? dataFinish = false;
  int? view;
  int? page;
  int? pageSize;
  DateTime? fromTime;
  DateTime? toTime;
  String? query;
  String? error;

  AppointmentState({
    this.loading,
    this.dataFinish,
    this.list,
    this.view,
    this.page,
    this.pageSize,
    this.fromTime,
    this.toTime,
    this.query,
    this.error,
  });

  AppointmentState copyWith(
      {List<AppointmentModel>? list,
      bool? loading,
      bool? dataFinish,
      int? view,
      int? page,
      int? pageSize,
      DateTime? fromTime,
      DateTime? toTime,
      String? query,
      String? error,
      bool clearError = false}) {
    return AppointmentState(
      list: list ?? this.list,
      loading: loading ?? this.loading,
      dataFinish: dataFinish ?? this.dataFinish,
      view: view ?? this.view,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      error: clearError ? null : error ?? this.error,
      query: query ?? this.query,
    );
  }
}
