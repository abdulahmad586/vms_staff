import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class VisitorsListCubit extends Cubit<VisitorsListState> {
  final RefreshController refreshController;
  final VisitorsService _service = VisitorsService();

  VisitorsListCubit(super.initialState, {required this.refreshController}) {
    getData();
  }

  void getData({bool refresh = false})async {
    emit(state.copyWith(loading: true, clearError:true));
    try{
      refreshController.refreshCompleted();

      final page = refresh ? 1 : (state.page??1);
      final pageSize = state.pageSize ?? VisitorsListState.defaultPageSize;

      final visitors = await _service.getVisitors();

      if (visitors.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }

      emit(state.copyWith(results: visitors, loading: false, page: page, pageSize: pageSize, dataFinished: visitors.length < pageSize ));

    }catch(e){
      print(e);
      refreshController.refreshCompleted();
      refreshController.loadFailed();
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void nextPage({int increment = 1}) {
    if (state.dataFinished ?? false) return;
    emit(state.copyWith( page: (state.page!) + increment, dataFinished: false));
    getData();
  }

  void updateItem(int index, VisitorModel? item) {
    List<VisitorModel> list = [...(state.results ?? [])];
    list.removeAt(index);
    emit(state.copyWith(results: list));
  }


}

class VisitorsListState {
  List<VisitorModel>? results;
  bool? loading;
  bool? dataFinished;
  int? page;
  int? pageSize;
  String? query;
  String? error;

  static int defaultPageSize = 1;

  VisitorsListState({
    this.loading,
    this.dataFinished,
    this.results,
    this.page,
    this.pageSize,
    this.query,
    this.error});

  VisitorsListState copyWith(
      {List<VisitorModel>? results,
        bool? loading,
        bool? dataFinished,
        int? page,
        int? pageSize,
        String? query,
        String? error,
        bool clearError = false,
      }){
    return VisitorsListState(
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
