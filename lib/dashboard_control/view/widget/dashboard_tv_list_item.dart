import 'package:flutter/material.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardTVListItem extends StatelessWidget {
  const DashboardTVListItem(this.tv, {Key? key, this.onTap, this.trailing})
      : super(key: key);
  final DashboardTvModel tv;
  final Widget? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = tv.status == DashboardTvState.online
        ? Colors.orange
        : (tv.status == DashboardTvState.loggedIn ? Colors.green : Colors.grey);

    return Card(
      elevation: 0.4,
      child: InkWell(
        onTap: onTap,
        child: GenericListItem(
            label: tv.name,
            desc: tv.location,
            verticalPadding: 10,
            leading: Stack(
              alignment: Alignment.topLeft,
              clipBehavior: Clip.none,
              children: [
                const AppIconButton(
                  icon: Icons.desktop_mac_rounded,
                  width: 40,
                  height: 40,
                ),
                Positioned(
                  top: -5,
                  left: -5,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: statusColor,
                  ),
                )
              ],
            ),
            trailing: trailing),
      ),
    );
  }
}
