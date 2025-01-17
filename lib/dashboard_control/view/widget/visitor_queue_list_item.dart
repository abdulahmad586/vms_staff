import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class VisitorQueueListItem extends StatelessWidget {
  final QueueItemModel visitor;
  final Function() onPressed;
  final bool isActive;
  const VisitorQueueListItem(this.visitor,
      {required this.onPressed, super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 75,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: isActive ? AppColors.primaryColor : Colors.grey[200],
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
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: isActive ? Colors.white : null),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (visitor.designation != null &&
                      visitor.designation!.isNotEmpty)
                    Text(
                      "# ${visitor.bookingNo}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: isActive ? Colors.grey[300] : null),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${visitor.designation ?? "No Designation"} | ${visitor.placeOfWork ?? ""}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: isActive ? Colors.grey[300] : null),
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
                color: isActive ? AppColors.primaryColor : Colors.grey[200]),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15)),
                      color: isActive
                          ? AppColors.secondaryColor
                          : visitor.getColor(),
                    ),
                    child: Text(
                      "${visitor.visitorType == VisitorType.visitor ? "VISITOR" : "VIP"} ${visitor.getVisitorLabel()}",
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    child: Center(
                        child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      visitor.time,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: isActive ? Colors.white : null),
                    ),
                    MorePopup(
                      onAction: (a) {
                        switch (a) {
                          case 0:
                            //callin or mark as done
                            if (isActive) {
                              context
                                  .read<DashboardQueueCubit>()
                                  .markDone(visitor);
                            } else {
                              context
                                  .read<DashboardQueueCubit>()
                                  .callIn(visitor);
                            }
                            break;
                          case 1:
                            //res
                            break;
                        }
                      },
                      options: [
                        isActive ? "Mark as done" : "Call in",
                        "Cancel AP",
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
