import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class VisitorsWaitingRoomListCubit extends Cubit<VisitorsWaitingRoomListState> {

  final RefreshController refreshController;

  VisitorsWaitingRoomListCubit(super.initialState, this.refreshController){
    Future.delayed(const Duration(seconds: 1), getData);
  }

  void getData({bool refresh = false}){
    emit(state.copyWith(loading: true, clearError: true));
    try{
      refreshController.requestLoading();
      final visitors =  VisitorModel.getSampleVisitors();
      refreshController.loadComplete();
      emit(state.copyWith(loading: false, visitors: visitors));
    }catch(e){
      print(e);
      refreshController.loadFailed();
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

}

class VisitorsWaitingRoomListState {
  String? error;
  bool? loading;
  List<VisitorModel>? visitors;

  VisitorsWaitingRoomListState({this.error, this.loading, this.visitors});

  VisitorsWaitingRoomListState copyWith(
      {String? error, bool? loading, List<VisitorModel>? visitors, bool clearError=false}) {
    return VisitorsWaitingRoomListState(
      error: clearError ? null : error ?? this.error,
      loading: loading ?? this.loading,
      visitors: visitors ?? this.visitors,
    );
  }
}