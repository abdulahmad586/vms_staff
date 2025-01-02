import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';

class CardsListCubit extends Cubit<CardsListState> {
  final RefreshController refreshController;
  final CardsService _service = CardsService();

  CardsListCubit(super.initialState, {required this.refreshController}) {
    getData();
  }

  void getData({bool refresh = false}) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      refreshController.refreshCompleted();

      final page = refresh ? 1 : (state.page ?? 1);
      final pageSize = state.pageSize ?? CardsListState.defaultPageSize;

      final tags = await _service.getCards(page: page, pageSize: pageSize);

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

  void updateItem(int index, CardModel? item) {
    List<CardModel> list = [...(state.results ?? [])];
    list.removeAt(index);
    emit(state.copyWith(results: list));
  }

  void updateView(int view) {
    emit(state.copyWith(view: view));
  }

  void addCards(List<CardModel> cards) {
    emit(state
        .copyWith(results: [...cards, ...(state.results ?? <CardModel>[])]));
  }
}

class CardsListState {
  List<CardModel>? results;
  bool? loading;
  bool? dataFinished;
  int? page;
  int? pageSize;
  String? query;
  String? error;
  int? view;

  static int defaultPageSize = 1;

  CardsListState({
    this.loading,
    this.dataFinished,
    this.results,
    this.page,
    this.pageSize,
    this.query,
    this.error,
    this.view,
  });

  CardsListState copyWith({
    List<CardModel>? results,
    bool? loading,
    bool? dataFinished,
    int? page,
    int? pageSize,
    String? query,
    String? error,
    bool clearError = false,
    int? view,
  }) {
    return CardsListState(
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
