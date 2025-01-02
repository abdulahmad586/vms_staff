import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/shared/services/services.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;

  AppConfig._internal();

  String? appStoreBoxPath;

  static Future<void> configure({bool initialiseHive = true}) async {
    await dotenv.load(fileName: ".env");
    WidgetsFlutterBinding.ensureInitialized();
    String appStoreBoxPath = (await getApplicationSupportDirectory()).path;
    AppConfig config = AppConfig();
    config.appStoreBoxPath = appStoreBoxPath;
    if (initialiseHive) {
      AppStorage storage = AppStorage();
      AppSettings settings = AppSettings();
      CardsStorage cardsStorage = CardsStorage();
      await Future.wait(
          [storage.initHive(), settings.initHive(), cardsStorage.initHive()]);
    }
  }
}
