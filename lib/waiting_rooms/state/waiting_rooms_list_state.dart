import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/waiting_rooms/waiting_rooms.dart';

class WaitingRoomListCubit extends Cubit<WaitingRoomListState> {
  final RefreshController refreshController;

  WaitingRoomListCubit(super.initialState, this.refreshController) {
    Future.delayed(const Duration(seconds: 1), getData);
  }

  void getData() {
    emit(state.copyWith(loading: true, clearError: true));
    refreshController.requestLoading();
    try {
      const rooms = [
        WaitingRoomModel(
            id: 'id-0',
            name: 'Conference Room 1',
            location: "Conference Hall",
            queueSize: 3),
        WaitingRoomModel(
            id: 'id-1',
            name: 'Conference Room 2',
            location: "Conference Hall",
            queueSize: 0),
        WaitingRoomModel(
            id: 'id-2',
            name: 'Conference Room 3',
            location: "Conference Hall",
            queueSize: 1),
        WaitingRoomModel(
            id: 'id-3',
            name: 'PO Lobby 1',
            location: "Protocol Office",
            queueSize: 2),
        WaitingRoomModel(
            id: 'id-4',
            name: 'PO Lobby 2',
            location: "Protocol Office",
            queueSize: 0),
      ];
      refreshController.refreshCompleted();
      emit(state.copyWith(loading: false, rooms: rooms));
    } catch (e) {
      print(e);
      refreshController.refreshFailed();
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}

class WaitingRoomListState {
  String? error;
  bool? loading;
  List<WaitingRoomModel>? rooms;

  WaitingRoomListState({this.error, this.loading, this.rooms});

  WaitingRoomListState copyWith(
      {String? error,
      bool? loading,
      List<WaitingRoomModel>? rooms,
      bool clearError = false}) {
    return WaitingRoomListState(
      error: clearError ? null : error ?? this.error,
      loading: loading ?? this.loading,
      rooms: rooms ?? this.rooms,
    );
  }
}
