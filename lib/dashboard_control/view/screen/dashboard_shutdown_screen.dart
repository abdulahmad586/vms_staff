import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardShutdownScreen extends StatelessWidget {
  final DashboardTvModel tv;
  DashboardShutdownScreen(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SHUTDOWN DASHBOARD TV",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
      ),
      body: BlocBuilder<DashboardControlCubit, DashboardControlState>(
          builder: (context, state) {
        if (!(state.socketConnected ?? false)) {
          return const SocketConnectionProblem();
        }

        final liveDashboardIndex =
            state.onlineTVs?.indexWhere((element) => element.id == tv.id) ?? -1;
        if (liveDashboardIndex == -1) {
          return const DashboardMessage(
              title: "Missing Dashboard",
              message: "This dashboard may have disconnected from the network");
        } else if (state.onlineTVs![liveDashboardIndex].status ==
            DashboardTvState.loggedIn) {
          return DashboardMessage(
            title: "Shutdown TV",
            icon: Icons.power_off,
            message:
                "You are about to shutdown this TV, this action is not reversible. Press shutdown to proceed.",
            action: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextButton(
                    label: "Shutdown",
                    buttonColor: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      context
                          .read<DashboardControlCubit>()
                          .shutdownMyDashboard(tv);
                    }),
              ],
            ),
          );
        } else {
          return const DashboardMessage(
              title: "Dashboard Not Logged In",
              message:
                  "You must login to your dashboard to be able to shut it down");
        }
      }),
    );
  }
}
