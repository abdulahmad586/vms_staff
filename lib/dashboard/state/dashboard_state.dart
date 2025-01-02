import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/dashboard/dashboard.dart';
import 'package:shevarms_user/dashboard/view/screen/dashboard_screen.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final RefreshController refreshController;

  DashboardCubit(super.initialState, {required this.refreshController}) {
    getData();
  }

  void getData({bool refresh = false}) async {
    final locations = [
      "Waiting room I",
      "Waiting room II",
    ];

    emit(state.copyWith(loading: true, clearError: true));
    try {
      refreshController.refreshCompleted();

      final page = refresh ? 1 : (state.page ?? 1);
      final pageSize = state.pageSize ?? DashboardState.defaultPageSize;

      final items = [
        DashboardSection("Today's Appointments", [
          DashboardStat(
              category: "",
              label: "Total appointments",
              value2: "0/",
              value: "0",
              icon: Icons.people_outline),
          DashboardStat(
              category: "",
              label: "Current appointments",
              value: "0",
              value2: "0/")
        ]),
        DashboardSection("Visitors queue", [
          DashboardStat(
              category: "",
              label: "Total visitors",
              value: "0",
              icon: Icons.people_outline),
          DashboardStat(category: "", label: "Current visitors", value: "0")
        ]),
      ];

      if (items.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }

      emit(state.copyWith(
          results: items,
          loading: false,
          page: page,
          pageSize: pageSize,
          dataFinished: items.length < pageSize));
    } catch (e) {
      print(e);
      refreshController.refreshCompleted();
      refreshController.loadFailed();
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void nextPage({int increment = 1}) {
    if (state.dataFinished ?? false) return;
    emit(state.copyWith(page: (state.page!) + increment, dataFinished: false));
    getData();
  }
}

class DashboardState {
  List<DashboardSection>? results;
  bool? loading;
  bool? dataFinished;
  int? page;
  int? pageSize;
  String? query;
  String? error;

  static int defaultPageSize = 1;

  DashboardState(
      {this.loading,
      this.dataFinished,
      this.results,
      this.page,
      this.pageSize,
      this.query,
      this.error});

  DashboardState copyWith({
    List<DashboardSection>? results,
    bool? loading,
    bool? dataFinished,
    int? page,
    int? pageSize,
    String? query,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      results: results ?? this.results,
      loading: loading ?? this.loading,
      dataFinished: dataFinished ?? this.dataFinished,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      query: query ?? this.query,
      error: clearError ? null : error ?? this.error,
    );
  }
}
