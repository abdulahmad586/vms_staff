import 'package:hive/hive.dart';
import 'package:shevarms_user/shared/services/services.dart';

class AppStorage {
  static const boxName = "appStore";

  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;

  AppStorage._internal();

  Box? box;
  bool initialisedHive = false;

  Map<dynamic, dynamic> get videosStatus =>
      box?.get("videosStatus", defaultValue: <dynamic, dynamic>{}) ??
      <String, String>{};
  set videosStatus(Map<dynamic, dynamic> statuses) =>
      box?.put("videosStatus", statuses);

  List<String> get cards =>
      box?.get("cards", defaultValue: <String>[]) ?? <String>[];
  set cards(List<String> cards) => box?.put("cards", cards);

  Future<void> initHive() async {
    AppConfig config = AppConfig();
    if (config.appStoreBoxPath == null) {
      throw Exception(
          "Storage box path not set, please use AppConfig to set this value");
    }

    if (!initialisedHive) {
      Hive.init(config.appStoreBoxPath);
      await Hive.openBox(boxName);
      box = Hive.box(boxName);
      initialisedHive = true;
      print("App storage initialised");
    }
  }
}
