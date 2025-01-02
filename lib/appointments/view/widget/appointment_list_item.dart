import 'package:flutter/material.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/shared/shared.dart';

class MeetingListItem extends StatelessWidget {
  const MeetingListItem(this.meeting, {Key? key, this.trailing, this.onTap})
      : super(key: key);
  final AppointmentModel meeting;
  final Widget? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      child: GenericListItem(
          onPressed: onTap,
          label: meeting.label,
          desc2: CalendarUtils.timeToString(meeting.date, includeTime: true),
          desc: meeting.visitLocation,
          leading: AppIconButton(
            height: 40,
            width: 40,
            icon: Icons.meeting_room_outlined,
            iconSize: 17,
            borderColor: Colors.grey.withAlpha(100),
          ),
          trailing: trailing),
    );
  }
}
