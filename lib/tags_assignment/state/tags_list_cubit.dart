import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/tags_assignment/tags_assignment.dart';

class TagsListCubit extends Cubit<TagsListState> {
  final RefreshController refreshController;
  final TagsService _service = TagsService();

  TagsListCubit(super.initialState, {required this.refreshController}) {
    getData();
  }

  void getData({bool refresh = false}) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      refreshController.refreshCompleted();

      final page = refresh ? 1 : (state.page ?? 1);
      final pageSize = state.pageSize ?? TagsListState.defaultPageSize;

      final tags = <TagModel>[]; //await _service.getTags();

      if (tags.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }

      emit(state.copyWith(
          results: tags,
          loading: false,
          page: page,
          pageSize: pageSize,
          dataFinished: tags.length < pageSize));
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

  void updateItem(int index, TagModel? item) {
    List<TagModel> list = [...(state.results ?? [])];
    list.removeAt(index);
    emit(state.copyWith(results: list));
  }

  void updateView(int view) {
    emit(state.copyWith(view: view));
  }
}

class TagsListState {
  List<TagModel>? results;
  bool? loading;
  bool? dataFinished;
  int? page;
  int? pageSize;
  String? query;
  String? error;
  int? view;

  static int defaultPageSize = 1;

  TagsListState({
    this.loading,
    this.dataFinished,
    this.results,
    this.page,
    this.pageSize,
    this.query,
    this.error,
    this.view,
  });

  TagsListState copyWith({
    List<TagModel>? results,
    bool? loading,
    bool? dataFinished,
    int? page,
    int? pageSize,
    String? query,
    String? error,
    bool clearError = false,
    int? view,
  }) {
    return TagsListState(
      results: results ?? this.results,
      loading: loading ?? this.loading,
      dataFinished: dataFinished ?? this.dataFinished,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      query: query ?? this.query,
      error: clearError ? null : error ?? this.error,
      view: view ?? this.view,
    );
  }
}
