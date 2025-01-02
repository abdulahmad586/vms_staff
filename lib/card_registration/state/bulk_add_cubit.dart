import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';

class BulkCardAddCubit extends Cubit<BulkCardAddState> {
  final RefreshController refreshController;
  final CardsStorage _storage = CardsStorage();
  final CardsService _service = CardsService();

  BulkCardAddCubit(super.initialState, {required this.refreshController}) {
    getData();
  }

  void getData({bool refresh = false}) async {
    emit(state.copyWith(syncing: true, clearError: true));
    try {
      refreshController.refreshCompleted();

      final page = refresh ? 1 : (state.page ?? 1);
      final pageSize = state.pageSize ?? CardsListState.defaultPageSize;

      final cards = _storage.getCards();

      if (cards.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }

      emit(state.copyWith(
          cards: cards,
          syncing: false,
          page: page,
          pageSize: pageSize,
          dataFinished: cards.length < pageSize));
    } catch (e) {
      debugPrint(e.toString());
      refreshController.refreshCompleted();
      refreshController.loadFailed();
      emit(state.copyWith(syncing: false, error: e.toString()));
    }
  }

  void updateItem(int index, CardModel item) {
    List<CardModel> list = [...(state.cards ?? [])];
    list[index] = item;
    _storage.addCard(item);
    emit(state.copyWith(cards: list));
  }

  void removeItem(int index, CardModel item) {
    List<CardModel> list = [...(state.cards ?? [])];
    list.removeAt(index);
    _storage.removeCard(item);
    emit(state.copyWith(cards: list));
  }

  void addCards(List<CardModel> cards) {
    _storage.addCards(cards);
    emit(state.copyWith(cards: [...cards, ...(state.cards ?? <CardModel>[])]));
  }

  Future<List<CardModel>> uploadCards() async {
    try {
      if (state.cards == null || state.cards!.isEmpty) {
        throw "Please add at least one card";
      }
      emit(state.copyWith(syncing: true));
      final result = await _service.uploadCards(state.cards!);
      _storage.clearAllCards();
      emit(state.copyWith(syncing: false, cards: []));
      return result;
    } catch (e, s) {
      emit(state.copyWith(syncing: false));
      print(e);
      print(s);
      rethrow;
    }
  }
}

class BulkCardAddState {
  List<CardModel>? cards;
  bool? syncing;
  bool? dataFinished;
  int? page;
  int? pageSize;
  String? query;
  String? error;
  int? view;

  static int defaultPageSize = 1;

  BulkCardAddState({
    this.syncing,
    this.dataFinished,
    this.cards,
    this.page,
    this.pageSize,
    this.query,
    this.error,
    this.view,
  });

  BulkCardAddState copyWith({
    List<CardModel>? cards,
    bool? syncing,
    bool? dataFinished,
    int? page,
    int? pageSize,
    String? query,
    String? error,
    bool clearError = false,
  }) {
    return BulkCardAddState(
      cards: cards ?? this.cards,
      syncing: syncing ?? this.syncing,
      dataFinished: dataFinished ?? this.dataFinished,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      query: query ?? this.query,
      error: clearError ? null : error ?? this.error,
    );
  }
}
