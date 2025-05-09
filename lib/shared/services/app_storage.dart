import 'package:hive/hive.dart';
import 'package:shevarms_user/shared/services/services.dart';

class AppStorage {
  static const boxName = "appStore";

  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;

  AppStorage._internal();

  Box? box;
  bool initialisedHive = false;

  String? get sipDest => box?.get("sipDest", defaultValue: null);
  set sipDest(String? sipDest) => box?.put("sipDest", sipDest);

  String? get sip_port => box?.get("sip_port", defaultValue: null);
  set sip_port(String? sip_port) => box?.put("sip_port", sip_port);

  String? get sip_ws_uri => box?.get("sip_ws_uri", defaultValue: null);
  set sip_ws_uri(String? sip_ws_uri) => box?.put("sip_ws_uri", sip_ws_uri);

  String? get sip_uri => box?.get("sip_uri", defaultValue: null);
  set sip_uri(String? sip_uri) => box?.put("sip_uri", sip_uri);

  String? get sip_display_name =>
      box?.get("sip_display_name", defaultValue: null);
  set sip_display_name(String? sip_display_name) =>
      box?.put("sip_display_name", sip_display_name);

  String? get sip_password => box?.get("sip_password", defaultValue: null);
  set sip_password(String? sip_password) =>
      box?.put("sip_password", sip_password);

  String? get sip_auth_user => box?.get("sip_auth_user", defaultValue: null);
  set sip_auth_user(String? sip_auth_user) =>
      box?.put("sip_auth_user", sip_auth_user);

  String? get userEmail => box?.get("userEmail", defaultValue: null);
  set userEmail(String? email) => box?.put("userEmail", email);

  String? get userPass => box?.get("userPass", defaultValue: null);
  set userPass(String? pass) => box?.put("userPass", pass);

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
