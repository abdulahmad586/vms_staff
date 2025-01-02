import 'package:flutter/material.dart';
import 'package:shevarms_user/notifications/notifications.dart' as app;
import 'package:shevarms_user/shared/shared.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem(this.notification, {Key? key, this.trailing, this.onTap}) : super(key: key);
  final app.Notification notification;
  final Widget? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 0.4,
      child: GenericListItem(
          onPressed: onTap,
          label: notification.label,
          desc: notification.content,
          desc2: CalendarUtils.timeToString(notification.time, includeTime: true),
          desc2Style: Theme.of(context).textTheme.labelSmall,
          leading: AppIconButton(
            height: 40,
            width:40,
            icon: Icons.notifications,
            iconSize: 17,
            borderColor: Colors.grey.withAlpha(100),
          ),
          trailing: trailing
      ),);
  }
}
