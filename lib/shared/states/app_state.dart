import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:sip_ua/sip_ua.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(super.initialState) {
    _initSipComm();
  }

  User? get user => state.user;

  updateUserData(User? user) {
    emit(state.copyWith(user: user));
  }

  updateLoginStatus(bool isLoggedIn) {
    emit(state.copyWith(isLoggedIn: isLoggedIn));
  }

  toggleFirstTimeLoad(bool isFirstTimeLoad) {
    AppSettings().isFirstTimeLoad = isFirstTimeLoad;
    emit(state.copyWith(isFirstTimeLoad: isFirstTimeLoad));
  }

  updateCurrentHomeItem(int currentItem) {
    emit(state.copyWith(currentHomeItem: currentItem));
  }

  logoutUser(BuildContext context) {
    emit(state.copyWith(logout: true));
  }

  void _initSipComm() {
    emit(state.copyWith(sipUaHelper: SIPUAHelper()));
  }
}

class AppState {
  User? user;
  bool? isLoggedIn;
  bool? isFirstTimeLoad;
  int? currentHomeItem;
  SIPUAHelper? sipUaHelper;
  AppState(
      {this.user,
      this.sipUaHelper,
      this.currentHomeItem,
      this.isLoggedIn,
      this.isFirstTimeLoad});

  AppState copyWith(
      {User? user,
      SIPUAHelper? sipUaHelper,
      int? currentHomeItem,
      bool? isLoggedIn,
      bool? isFirstTimeLoad,
      bool logout = false}) {
    return AppState(
      user: logout ? null : (user ?? this.user),
      currentHomeItem: currentHomeItem ?? this.currentHomeItem,
      isLoggedIn: logout ? null : isLoggedIn ?? this.isLoggedIn,
      isFirstTimeLoad: isFirstTimeLoad ?? this.isFirstTimeLoad,
      sipUaHelper: sipUaHelper ?? this.sipUaHelper,
    );
  }
}
