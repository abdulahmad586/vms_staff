import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

enum CardType {
  visitor,
  vip,
  vvip,
  vvvip
}

enum CardCategory {
  normal,
  governor,
  conference,
}

class TagModel {
  String id;
  String code;
  VisitorModel? assignedVisitor;
  DateTime? timeOfAssignment;
  CardType cardType;
  CardCategory cardCategory;

  TagModel({
    required this.id,
    required this.code,
    this.assignedVisitor,
    this.timeOfAssignment,
    required this.cardType,
    required this.cardCategory,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      code: json['code'],
      assignedVisitor: json['assignedVisitor'] != null
          ? VisitorModel.fromMap(json['assignedVisitor'])
          : null,
      timeOfAssignment: json['timeOfAssignment'] != null
          ? DateTime.parse(json['timeOfAssignment'])
          : null,
      cardType: CardType.values[json['cardType']],
      cardCategory: CardCategory.values[json['cardCategory']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'assignedVisitor': assignedVisitor?.toMap(),
      'timeOfAssignment': timeOfAssignment?.toIso8601String(),
      'cardType': cardType.index,
      'cardCategory': cardCategory.index,
    };
  }
}

