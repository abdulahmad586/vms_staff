import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneSignupCubit extends Cubit<PhoneSignupState> {

  PhoneSignupCubit(super.initialState);

  sendOtp(String phone, Function() onSend)async{
    try{
      emit(state.copyWith(loading: true, error: null));

      // await authRepo.generateSignupOTP(phone:phone);
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(loading: false, error: null));
      onSend();

    }catch(e){
      emit(state.copyWith(loading: false, error:e.toString()));
    }
  }

}

class PhoneSignupState {
  String? error;
  bool? loading;

  PhoneSignupState({this.error, this.loading});

  PhoneSignupState copyWith(
      {String? error, bool? loading}) {
    return PhoneSignupState(
        error: error ?? this.error,
        loading: loading ?? this.loading
    );
  }
}
