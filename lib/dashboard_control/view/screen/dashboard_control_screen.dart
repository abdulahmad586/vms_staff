import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardControlScreen extends StatefulWidget {
  final DashboardTvModel tv;
  DashboardControlScreen({required this.tv});

  @override
  State<DashboardControlScreen> createState() => _DashboardControlScreenState();
}

class _DashboardControlScreenState extends State<DashboardControlScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardControlCubit, DashboardControlState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.tv.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryColor, fontFamily: 'Iceberg')),
            actions: [
              if (state.state == DashboardTvState.loggedIn)
                IconButton(
                  onPressed: () {
                    context
                        .read<DashboardControlCubit>()
                        .logoutMyDashboard(state.tv!);
                  },
                  icon: const Icon(Icons.logout),
                ),
            ],
          ),
          body: Builder(builder: (context) {
            if (!(state.socketConnected ?? false)) {
              return const SocketConnectionProblem();
            }
            final liveDashboardIndex = state.onlineTVs
                    ?.indexWhere((element) => element.id == widget.tv.id) ??
                -1;
            if (liveDashboardIndex == -1) {
              return const DashboardMessage(
                  title: "Missing Dashboard",
                  message:
                      "This dashboard may have disconnected from the network");
            }

            final liveDashboard = state.onlineTVs![liveDashboardIndex];

            switch (liveDashboard.status) {
              case DashboardTvState.offline:
                return DashboardOfflineWidget();
              case DashboardTvState.online:
                return DashboardOnlineWidget(liveDashboard);
              case DashboardTvState.loggedIn:
                return DashboardLoggedInWidget(liveDashboard);
              default:
                return DashboardOfflineWidget();
            }
          }));
    });
  }
}
