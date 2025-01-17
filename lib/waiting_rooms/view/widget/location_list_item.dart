import 'package:flutter/widgets.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/waiting_rooms/waiting_rooms.dart';

class LocationListItem extends StatelessWidget {
  final LocationModel location;
  final Widget? trailing;
  const LocationListItem(this.location, {this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    return GenericListItem(
      verticalPadding: 5.0,
      label: location.name,
      desc: location.gate,
      trailing: trailing,
    );
  }
}
