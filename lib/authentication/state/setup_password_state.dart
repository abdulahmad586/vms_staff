import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/shared/models/models.dart';

class SetupPasswordCubit extends Cubit<SetupPasswordState> {

  SetupPasswordCubit(super.initialState);

  registerUser(User user, String password, Function() onFinish)async{
    try{
      emit(state.copyWith(loading: true, error: null));
      // await authRepo.registerUser(
      //     user: user,
      //     password:password
      // );
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(loading: false, error: null));

      onFinish();

    }catch(e){
      emit(state.copyWith(loading: false, error:e.toString()));
    }
  }

  login(String phone, String password, Function(User) onFinish)async{
    try{
      emit(state.copyWith(loading: true, error: null));
      // final response = await authRepo.login(phone:phone, password:password);
      emit(state.copyWith(loading: false, error: null));

      // onFinish(response.user);

    }catch(e){
      emit(state.copyWith(loading: false, error:e.toString()));
    }
  }


}

class SetupPasswordState {
  String? error;
  bool? loading;

  SetupPasswordState({this.error, this.loading});

  SetupPasswordState copyWith(
      {String? error, bool? loading}) {
    return SetupPasswordState(
        error: error ?? this.error,
        loading: loading ?? this.loading
    );
  }
}
