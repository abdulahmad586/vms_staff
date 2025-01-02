import 'dart:math';

import 'package:shevarms_user/tags_assignment/tags_assignment.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class TagsService{

  Future<List<TagModel>> getTags({int page = 1, int pageSize = 10})async{
    final visitors = VisitorModel.getSampleVisitors();
    return List.generate(10, (index) => TagModel(id: 'id-$index', code: "234-3243-2-13423-1344", cardType: CardType.values[Random().nextInt(CardType.values.length-1)], cardCategory: CardCategory.values[Random().nextInt(CardCategory.values.length-1)], assignedVisitor: visitors[Random().nextInt(visitors.length-1)], timeOfAssignment: DateTime.now().subtract(Duration(minutes: Random().nextInt(300)))));
  }

}