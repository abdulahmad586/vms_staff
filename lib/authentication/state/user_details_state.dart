import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit(super.initialState);

  updateAddress(String address) {
    emit(state.copyWith(address: address));
  }

  updateDesignation(String value) {
    emit(state.copyWith(designation: value));
  }

  updatePlaceOfWork(String value) {
    emit(state.copyWith(placeOfWork: value));
  }

  updateNationality(String value) {
    emit(state.copyWith(nationality: value));
  }

  updateCountry(String value) {
    emit(state.copyWith(country: value));
  }

  updateState(String value) {
    emit(state.copyWith(state: value));
  }

  updateLGA(String value) {
    emit(state.copyWith(lga: value));
  }
}

class UserDetailsState {
  String? error;
  bool? loading;

  String? address;
  String? designation;
  String? placeOfWork;
  String? nationality;
  String? country;
  String? state;
  String? lga;

  UserDetailsState(
      {this.error,
      this.loading,
      this.address,
      this.designation,
      this.placeOfWork,
      this.nationality,
      this.country,
      this.state,
      this.lga});

  UserDetailsState copyWith(
      {String? error,
      bool? loading,
      String? designation,
      String? address,
      String? placeOfWork,
      String? nationality,
      String? country,
      String? state,
      String? lga}) {
    return UserDetailsState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      designation: designation ?? this.designation,
      address: address ?? this.address,
      placeOfWork: placeOfWork ?? this.placeOfWork,
      nationality: nationality ?? this.nationality,
      country: country ?? this.country,
      state: state ?? this.state,
      lga: lga ?? this.lga,
    );
  }
}
