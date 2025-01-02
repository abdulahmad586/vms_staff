import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';

class DashboardQueueCubit extends Cubit<DashboardQueueState> {
  final RefreshController? refreshController;
  final BuildContext context;
  final DashboardTvModel tv;
  final DashboardControlService service = DashboardControlService();

  DashboardQueueCubit(this.context, super.initialState,
      {required this.tv, this.refreshController}) {
    _initListener();
  }

  _initListener() {
    if (context.mounted) {
      context.read<DashboardControlCubit>().listenForDashboardQueue(tv.id,
          (List<QueueItemModel> queue) {
        emit(state.copyWith(queue: queue));
      });
      context
          .read<DashboardControlCubit>()
          .listenForCallIn((String bookingNumber) {
        emit(state.copyWith(currentVisitorBookingNumber: bookingNumber));
      });
    }
  }

  dispose() {
    if (context.mounted) {
      context.read<DashboardControlCubit>().unlistenForDashboardQueue(tv.id);
      context.read<DashboardControlCubit>().listenForCallIn(null);
    }
  }

  callIn(QueueItemModel visitor) {
    if (state.currentVisitorBookingNumber != null) {
      final doneVisitor = state.queue!.firstWhere(
          (element) => element.bookingNo == state.currentVisitorBookingNumber);
      markDone(doneVisitor);
      emit(state.copyWith(clearCurrentVisitorBookingNumber: true));
    }
    if (context.mounted) {
      context
          .read<DashboardControlCubit>()
          .callInVisitor(tv.id, visitor.bookingNo);
    }
  }

  markDone(QueueItemModel visitor) {
    if (context.mounted) {
      context
          .read<DashboardControlCubit>()
          .markAppointmentDone(tv.id, visitor.bookingNo);
    }
  }
}

class DashboardQueueState {
  String? error;
  List<QueueItemModel>? queue;
  bool? loading;
  String? currentVisitorBookingNumber;

  DashboardQueueState({
    this.queue,
    this.error,
    this.loading,
    this.currentVisitorBookingNumber,
  });

  DashboardQueueState copyWith({
    List<QueueItemModel>? queue,
    bool? loading,
    String? error,
    bool clearError = false,
    String? currentVisitorBookingNumber,
    bool clearCurrentVisitorBookingNumber = false,
  }) {
    return DashboardQueueState(
      queue: queue ?? this.queue,
      error: clearError ? null : error ?? this.error,
      loading: loading ?? this.loading,
      currentVisitorBookingNumber: clearCurrentVisitorBookingNumber
          ? null
          : currentVisitorBookingNumber ?? this.currentVisitorBookingNumber,
    );
  }
}
