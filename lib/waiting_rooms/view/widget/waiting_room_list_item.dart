import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/waiting_rooms/model/waiting_room_model.dart';

class WaitingRoomsListItem extends StatelessWidget {
  const WaitingRoomsListItem(this.roomModel,
      {Key? key, this.onTap, this.trailing})
      : super(key: key);
  final WaitingRoomModel roomModel;
  final Widget? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      child: InkWell(
        onTap: onTap,
        child: GenericListItem(
            label: roomModel.name,
            desc: roomModel.location,
            leading: const AppIconButton(
              icon: Icons.meeting_room_outlined,
              width: 40,
              height: 40,
            ),
            trailing: trailing),
      ),
    );
  }
}
