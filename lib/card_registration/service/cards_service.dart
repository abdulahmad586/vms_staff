import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/shared/shared.dart';

class CardsService {
  final DioClient _client = DioClient();

  Future<List<CardModel>> getCards({int page = 1, int pageSize = 10}) async {
    try {
      final response = await _client.get(ApiConstants.getAllCards);
      final cardsMap = ApiResponse.fromMap(response, dataField: "cards");
      return CardModel.fromMapArray(cardsMap.data);
    } catch (e, s) {
      print(s);
      print(e);
      rethrow;
    }
  }

  Future<CardModel> getCardByQrCode(String qrCode) async {
    try {
      final response = await _client.get(ApiConstants.getACardByQrCode(qrCode));
      final cardsMap = ApiResponse.fromMap(response, dataField: "card");
      return CardModel.fromMap(cardsMap.data);
    } catch (e, s) {
      print(s);
      print(e);
      rethrow;
    }
  }

  Future<CardModel> getCardBySerialNo(String serialNo) async {
    try {
      final response =
          await _client.get(ApiConstants.getACardBySerialNo(serialNo));
      final cardsMap = ApiResponse.fromMap(response, dataField: "card");
      return CardModel.fromMap(cardsMap.data);
    } catch (e, s) {
      print(s);
      print(e);
      rethrow;
    }
  }

  Future<List<CardModel>> uploadCards(List<CardModel> cards) async {
    try {
      final response = await _client.post(ApiConstants.uploadCards,
          data: {"cards": cards.map((e) => e.toMap()).toList()});
      final res = ApiResponse.fromMap(response, dataField: "cards");
      if (!(res.ok ?? false)) {
        throw res.message ?? "An unknown error occurred";
      }
      return cards;
    } catch (e, s) {
      print(s);
      print(e);
      rethrow;
    }
  }
}
