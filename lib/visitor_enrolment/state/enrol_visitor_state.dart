import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class EnrolVisitorCubit extends Cubit<EnrolVisitorState> {
  EnrolVisitorCubit(super.initialState);

  updateFirstName(String firstName) {
    emit(state.copyWith(firstName: firstName));
  }

  updateLastName(String value) {
    emit(state.copyWith(lastName: value));
  }

  updateEmail(String value) {
    emit(state.copyWith(email: value));
  }

  updatePhoneNumber(String value) {
    emit(state.copyWith(phoneNumber: value));
  }

  updateAddress(String value) {
    emit(state.copyWith(address: value));
  }

  updatePlaceOfWork(String value) {
    emit(state.copyWith(placeOfWork: value));
  }

  updateDesignation(String value) {
    emit(state.copyWith(designation: value));
  }

  updateProfilePicture(String value) {
    emit(state.copyWith(profilePicture: value));
  }

  enrol(Function(VisitorModel) onSignup) async {
    try {
      emit(state.copyWith(loading: true, error: ""));

      final registeredUser = await VisitorsService().createVisitor(
          firstName: state.firstName!,
          lastName: state.lastName!,
          phone: state.phoneNumber!,
          picture: state.profilePicture,
          designation: state.designation,
          placeOfWork: state.placeOfWork,
          email: state.email);
      emit(state.copyWith(loading: false, error: ""));
      onSignup(registeredUser);
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}

class EnrolVisitorState {
  String? error;
  bool? loading;

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address;
  String? placeOfWork;
  String? profilePicture;
  String? designation;

  EnrolVisitorState(
      {this.error,
      this.loading,
      this.firstName,
      this.placeOfWork,
      this.profilePicture,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.address,
      this.designation});

  EnrolVisitorState copyWith({
    String? error,
    bool? loading,
    String? firstName,
    String? lastName,
    String? placeOfWork,
    String? profilePicture,
    String? email,
    String? phoneNumber,
    String? address,
    String? designation,
  }) {
    return EnrolVisitorState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      placeOfWork: placeOfWork ?? this.placeOfWork,
      designation: designation ?? this.designation,
    );
  }
}
