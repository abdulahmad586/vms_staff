import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardOnlineWidget extends StatelessWidget {
  final DashboardTvModel tv;
  const DashboardOnlineWidget(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.desktop_mac_rounded,
            size: 90,
            color: Colors.green,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Dashboard is Online",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Click on the button below to log in your Dashboard TV",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextButton(
              label: "LOGIN",
              onPressed: () {
                context
                    .read<DashboardControlCubit>()
                    .loginMyDashboard(tv, tv.username ?? "", tv.password ?? "");
              }),
        ],
      ),
    );
  }
}
