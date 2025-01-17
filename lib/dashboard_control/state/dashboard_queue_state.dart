import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardQueueCubit extends Cubit<DashboardQueueState> {
  final RefreshController? refreshController;
  final BuildContext context;
  final DashboardTvModel tv;
  final DashboardControlService service = DashboardControlService();
  final List<QueueItemModel> initialQueue;

  DashboardQueueCubit(
    this.context,
    super.initialState, {
    required this.tv,
    this.refreshController,
    this.initialQueue = const [],
  }) {
    _initListener();
  }

  _initListener() {
    if (context.mounted) {
      emit(state.copyWith(queue: initialQueue));
      context.read<DashboardControlCubit>().listenForDashboardQueue(
          tv.id, tv.group ?? "", (List<QueueItemModel> queue, {bool? isNew}) {
        if (isNew ?? false) {
          final list = state.queue ?? [];
          list.addAll(queue);
          emit(state.copyWith(queue: list));
        } else {
          emit(state.copyWith(queue: queue));
        }
      });
      context.read<DashboardControlCubit>().listenForNewAppointment(
          tv.id, tv.group ?? "", (QueueItemModel queue) {
        final list = state.queue ?? [];
        if (list.indexWhere((element) => element.id == queue.id) == -1) {
          list.add(queue);
        }
        emit(state.copyWith(queue: list));
      });
      context
          .read<DashboardControlCubit>()
          .listenForRemoveAppointment(tv.id, tv.group ?? "", (String apId) {
        final list = state.queue ?? [];
        if (list.indexWhere((element) => element.id == apId) != -1) {
          list.removeWhere((element) => element.id == apId);
        }
        emit(state.copyWith(
            queue: list, clearCurrentVisitorBookingNumber: true));
      });
      context
          .read<DashboardControlCubit>()
          .listenForCallIn((String bookingNumber) {
        emit(state.copyWith(currentVisitorBookingNumber: bookingNumber));
        if (context.mounted) {
          final visitorIndex = state.queue
                  ?.indexWhere((element) => element.id == bookingNumber) ??
              -1;
          if (visitorIndex != -1) {
            NavUtils.navTo(
                context,
                VisitorMeetingScreen(
                  tv: tv,
                ));
          }
        }
      });
    }
  }

  dispose() {
    if (context.mounted) {
      context.read<DashboardControlCubit>().unlistenForDashboardQueue(tv.id);
      context.read<DashboardControlCubit>().listenForCallIn(null);
      context.read<DashboardControlCubit>().unlistenForAppointments();
    }
  }

  callIn(QueueItemModel visitor) {
    if (state.currentVisitorBookingNumber != null &&
        (state.queue?.isNotEmpty ?? false)) {
      final doneVisitor = state.queue!.firstWhere(
          (element) => element.id == state.currentVisitorBookingNumber);
      markDone(doneVisitor);
      emit(state.copyWith(clearCurrentVisitorBookingNumber: true));
    }
    if (context.mounted) {
      context
          .read<DashboardControlCubit>()
          .callInVisitor(tv.id, tv.group ?? "", visitor.id ?? "");
    }
  }

  markDone(QueueItemModel visitor) {
    if (context.mounted) {
      context
          .read<DashboardControlCubit>()
          .markAppointmentDone(tv.id, tv.group!, visitor.id!);
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
