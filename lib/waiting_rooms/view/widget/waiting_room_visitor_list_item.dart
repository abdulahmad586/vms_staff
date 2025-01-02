import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/model/model.dart';

class WaitingRoomVisitorListItem extends StatelessWidget {
  final VisitorModel visitor;
  final Function() onPressed;
  const WaitingRoomVisitorListItem(this.visitor,
      {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 75,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.grey[200],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CardImage(
              imageString: visitor.picture,
              size: const Size(30, 30),
              radius: 40,
              showBorder: false,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [visitor.firstName, visitor.lastName].join(" "),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  if (visitor.designation != null &&
                      visitor.designation!.isNotEmpty)
                    Text(
                      visitor.designation ?? "No designation",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  if (visitor.placeOfWork != null &&
                      visitor.placeOfWork!.isNotEmpty)
                    Text(
                      visitor.placeOfWork ?? "No place of work",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          Container(
            height: 75,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.grey[200]),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15)),
                      color: visitor.getColor(),
                    ),
                    child: Text(
                      "${visitor.userType == VisitorType.visitor ? "VISITOR" : "VIP"} ${visitor.getVisitorLabel()}",
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    child: Center(
                        child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${Random().nextInt(6)}:00pm"),
                    MorePopup(
                      onAction: (a) {},
                      options: const [
                        "Call in",
                        "Mark as done",
                        "Reschedule AP"
                      ],
                    ),
                  ],
                ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
