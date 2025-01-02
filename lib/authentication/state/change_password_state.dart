import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/authentication/authentication.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthService authService = AuthService();
  ChangePasswordCubit(super.initialState);

  changePassword(String userId, String oldPassword, String newPassword,
      Function() onFinish) async {
    try {
      emit(state.copyWith(loading: true, error: null));
      // await Future.delayed(const Duration(seconds: 2));
      final response = await authService.changePassword(
          userId: userId, oldPassword: oldPassword, newPassword: newPassword);
      emit(state.copyWith(loading: false, error: null));
      if (response) {
        onFinish();
      } else {
        throw "An error occurred, please try again";
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}

class ChangePasswordState {
  String? error;
  bool? loading;

  ChangePasswordState({this.error, this.loading});

  ChangePasswordState copyWith({String? error, bool? loading}) {
    return ChangePasswordState(
        error: error ?? this.error, loading: loading ?? this.loading);
  }
}
