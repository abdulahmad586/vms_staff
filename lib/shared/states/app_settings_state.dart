import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/shared/shared.dart';

class SettingsCubit extends Cubit<SettingsState> {
  AppSettings settings = AppSettings();

  SettingsCubit() : super(SettingsState()) {
    _loadSettings();
  }

  _loadSettings() {
    final baseUrl = settings.baseUrl;
    DioClient().initBaseUrl(baseUrl ?? ApiConstants.baseUrl);
    emit(state.copyWith(baseUrl: baseUrl));
  }

  void updateServerUrl(String text) {
    if (text.isEmpty) {
      return;
    }

    DioClient().initBaseUrl(text);
    AppSettings().baseUrl = text;
    emit(state.copyWith(baseUrl: text));
  }
}

class SettingsState {
  String? baseUrl;
  SettingsState({this.baseUrl});

  SettingsState copyWith({String? baseUrl}) {
    return SettingsState(baseUrl: baseUrl ?? this.baseUrl);
  }
}
