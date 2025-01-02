import 'dart:convert';

class CardModel {
  final String id;
  final String sno;
  final String rfid;
  final String qrCode;
  final String type;

  const CardModel({
    required this.id,
    required this.sno,
    required this.rfid,
    required this.qrCode,
    required this.type,
  });

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] ?? map['_id'],
      sno: map['sno'] ?? map['sno'],
      rfid: map['rfid'] ?? map['rfid'],
      qrCode: map['qrCode'] ?? map['qrCode'],
      type: map['type'] ?? map['type'],
    );
  }

  static List<CardModel> fromMapArray(List<dynamic> list) {
    return list.map((e) => CardModel.fromMap(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sno': sno.replaceAll("\n", "").trim(),
      'rfid': rfid.replaceAll("\n", "").trim(),
      'qrCode': qrCode.replaceAll("\n", "").trim(),
      'type': type,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
