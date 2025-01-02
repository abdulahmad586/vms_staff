import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/shared/shared.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService = AuthService();
  LoginCubit(super.initialState);

  signIn(String email, String password, Function(User) onLoggedIn) async {
    try {
      emit(state.copyWith(loading: true, error: ""));

      final loginResponse =
          await authService.login(email: email, password: password);
      emit(state.copyWith(loading: false, error: ""));
      onLoggedIn(loginResponse);
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  forgotPassword(String email) async {
    try {
      // await authRepo.resetPassword(email: email);
    } catch (e) {
      rethrow;
    }
  }
}

class LoginState {
  String? error;
  bool? loading;

  LoginState({this.error, this.loading});

  LoginState copyWith({String? error, bool? loading}) {
    return LoginState(
        error: error ?? this.error, loading: loading ?? this.loading);
  }
}
