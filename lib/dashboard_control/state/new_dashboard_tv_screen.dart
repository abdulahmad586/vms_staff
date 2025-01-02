import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';

class NewDashboardTVCubit extends Cubit<NewDashboardTVState> {
  final DashboardControlService service = DashboardControlService();
  NewDashboardTVCubit(super.initialState);

  createDashboard(Function(DashboardTvModel) onFinish) async {
    try {
      emit(state.copyWith(loading: true, error: null));
      final response = await service.createDashboard(
          name: state.name,
          username: state.username,
          location: state.location,
          password: state.password);
      emit(state.copyWith(loading: false, error: null));

      onFinish(response);
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateUsername(String value) {
    emit(state.copyWith(username: value));
  }

  void updateLocation(String value) {
    emit(state.copyWith(location: value));
  }

  void updatePassword(String value) {
    emit(state.copyWith(password: value));
  }
}

class NewDashboardTVState {
  String? error;
  bool? loading;
  String? name;
  String? username;
  String? location;
  String? password;

  NewDashboardTVState(
      {this.error,
      this.name,
      this.username,
      this.location,
      this.password,
      this.loading});

  NewDashboardTVState copyWith({
    String? error,
    bool? loading,
    String? username,
    String? password,
    String? name,
    String? location,
  }) {
    return NewDashboardTVState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      name: name ?? this.name,
      username: username ?? this.username,
      location: location ?? this.location,
      password: password ?? this.password,
    );
  }
}
