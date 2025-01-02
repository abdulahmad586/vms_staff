import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';

class UserCard extends StatelessWidget {
  UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  User user;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).highlightColor,
                blurRadius: 3,
                offset: Offset(-3, 3))
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardImage(
              imageString: user.picture,
              size: const Size(100, 100),
              radius: 15,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [user.firstName, user.lastName].join(" "),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontFamily: 'Iceberg'),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    user.designation ?? "No designation",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.location ?? "No location",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    user.phone,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Last login: ${CalendarUtils.timeToString(user.updatedAt, includeTime: true)}",
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            AppIconButton(
              icon: Icons.qr_code_2,
              iconSize: 15,
              height: 30,
              width: 30,
              onTap: () {
                Alert.showModal(context, UserCode(user));
              },
            )
          ],
        ));
  }
}
