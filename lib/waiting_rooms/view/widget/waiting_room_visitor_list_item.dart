import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      color: getColor(visitor.userType),
                    ),
                    child: Text(
                      "${visitor.userType == VisitorType.visitor ? "VISITOR" : "VIP"} ${getVisitorLabel(visitor.userType)}",
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    child: Center(
                        child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${Random().nextInt(6)}:00pm"),
                    BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                      if (state.user?.userType == UserType.seniorStaff) {
                        return MorePopup(
                          onAction: (a) {},
                          options: const [
                            "Call in",
                            "Reschedule AP",
                            "Cancel AP",
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ],
                ))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color getColor(VisitorType userType) {
    switch (userType) {
      case VisitorType.visitor:
        return Colors.grey;
      case VisitorType.vip:
        return Colors.yellow;
      case VisitorType.vvip:
        return Colors.green;
      case VisitorType.vvvip:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getVisitorLabel(VisitorType userType) {
    switch (userType) {
      case VisitorType.visitor:
        return "";
      case VisitorType.vip:
        return "I";
      case VisitorType.vvip:
        return "II";
      case VisitorType.vvvip:
        return "III";
    }
  }
}
