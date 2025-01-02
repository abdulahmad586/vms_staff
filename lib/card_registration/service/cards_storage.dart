import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/shared/services/services.dart';

class CardsStorage {
  static const boxName = "cardsStore";

  static final CardsStorage _instance = CardsStorage._internal();
  factory CardsStorage() => _instance;

  CardsStorage._internal();

  Box<String>? box;
  bool initialisedHive = false;

  void addCard(CardModel card) {
    box?.put(card.id, card.toJson());
  }

  void addCards(List<CardModel> cards) {
    box?.putAll(Map.fromIterables(
        cards.map((e) => e.id), cards.map((e) => e.toJson())));
  }

  void removeCard(CardModel card) {
    box?.delete(card.id);
  }

  CardModel? getCard(String id) {
    final cardJson = box?.get(id, defaultValue: null);
    final card =
        cardJson == null ? null : CardModel.fromMap(jsonDecode(cardJson));
    return card;
  }

  List<CardModel> getCards() {
    final cardJson = box?.values.toList();
    if (cardJson == null) {
      return [];
    }
    return CardModel.fromMapArray(cardJson.map((e) => jsonDecode(e)).toList());
  }

  Future<int>? clearAllCards() {
    return box?.clear();
  }

  Future<void> initHive() async {
    AppConfig config = AppConfig();
    if (config.appStoreBoxPath == null) {
      throw Exception(
          "Storage box path not set, please use AppConfig to set this value");
    }

    if (!initialisedHive) {
      Hive.init(config.appStoreBoxPath);
      await Hive.openBox<String>(boxName);
      box = Hive.box<String>(boxName);
      initialisedHive = true;
      print("Cards storage initialised");
    }
  }
}
