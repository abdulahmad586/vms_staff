import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/notifications/notifications.dart' as app;

class NotificationsListCubit extends Cubit<NotificationsListState> {
  RefreshController refreshController;
  NotificationsListCubit(super.initialState,
      {
        required this.refreshController}) {
    getData();
  }

  void getData({bool refresh = false}) {
    emit(NotificationsListState(
        prevState: state, page: refresh ? 1 : state.page, loading: true));
    app.Notification.getNotifications(
        pageSize: 10,
        page: state.page ?? 1,
        read: state.view == 0?null:(state.view==1?false: true)
    ).then((value) {
      refreshController.refreshCompleted();
      if (value.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      if (value.isEmpty) {
        emit(NotificationsListState(prevState: state, dataFinish: true));
      }
      emit(NotificationsListState(
        prevState: state,
        loading: false,
        list: refresh ? value : [...(state.list ?? []), ...value],
      ));
    }).catchError((error) {
      refreshController.refreshCompleted();
      refreshController.loadFailed();
      emit(NotificationsListState(
          prevState: state, loading: false, error: error.toString()));
    });
  }

  void nextPage({int increment = 1}) {
    if (state.dataFinish ?? false) return;
    emit(NotificationsListState(
        prevState: state, page: (state.page!) + increment, dataFinish: false));
    getData();
  }

  void updateItem(int index, app.Notification? notification) {
    List<app.Notification> list = [...(state.list ?? [])];
    list.replaceRange(
        index, index + 1, notification == null ? [] : [notification]);
    emit(NotificationsListState(prevState: state, list: list));
  }

  void findAndUpdateItem(app.Notification? notification) {
    if (notification == null) return;
    int index = state.list!.indexOf(notification);

    if (index == -1) return;

    List<app.Notification> list = [...(state.list ?? [])];
    list.replaceRange(
        index, index + 1, [notification]);
    emit(NotificationsListState(prevState: state, list: list));
  }

  void changeView(int view) {
    emit(NotificationsListState(
        prevState: state, page: 1, list: [], view: view, dataFinish: false));
    getData();
  }
}

class NotificationsListState {
  NotificationsListState? prevState;
  List<app.Notification>? list;
  bool? loading = true;
  bool? dataFinish = false;
  int? page;
  int? view;
  int? pageSize;
  String? query;
  String? error;

  NotificationsListState(
      {this.prevState,
        this.loading,
        this.dataFinish,
        this.list,
        this.page,
        this.view,
        this.pageSize,
        this.query,
        this.error}) {
    if (prevState != null) {
      list = list ?? prevState!.list;
      loading = loading ?? prevState!.loading;
      dataFinish = dataFinish ?? prevState!.dataFinish;
      page = page ?? prevState!.page;
      view = view ?? prevState!.view;
      pageSize = pageSize ?? prevState!.pageSize;
      query = query ?? prevState!.query;
      error = error;
    } else {
      list = list ?? [];
      loading = loading ?? false;
      dataFinish = dataFinish ?? false;
      page = page ?? 1;
      view = view ?? 0;
      pageSize = pageSize ?? 10;
      query = query ?? '';
      error = error;
    }
  }
}
