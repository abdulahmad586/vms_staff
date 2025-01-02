import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/shared/models/models.dart';

class PhoneOtpCubit extends Cubit<PhoneOtpState> {

  final String phone;

  PhoneOtpCubit(super.initialState, this.phone);

  validateOTP(String otp, Function(User) onSend)async{
    try{
      emit(state.copyWith(loading: true, error: null));
      await Future.delayed(const Duration(seconds: 2));
      // final result = await authRepo.validateOTPAndFetchNINData(otp:otp, phone:phone, nin:nin);

      emit(state.copyWith(loading: false, error: null));

      onSend(sampleUser);

    }catch(e){
      emit(state.copyWith(loading: false, error:e.toString()));
      rethrow;
    }
  }


}

class PhoneOtpState {
  String? error;
  bool? loading;

  PhoneOtpState({this.error, this.loading});

  PhoneOtpState copyWith(
      {String? error, bool? loading}) {
    return PhoneOtpState(
        error: error ?? this.error,
        loading: loading ?? this.loading
    );
  }
}
