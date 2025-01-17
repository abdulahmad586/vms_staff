import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardTvLoginScreen extends StatelessWidget {
  final DashboardTvModel tv;
  DashboardTvLoginScreen(this.tv, {super.key});

  final TextEditingController username =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final TextEditingController password =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN DASHBOARD TV",
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
            title: "Dashboard is Logged In",
            message:
                "This TV is currently logged in, open the dashboard's queue to manage visitors",
            action: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextButton(
                    label: "Logout",
                    buttonColor: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      context
                          .read<DashboardControlCubit>()
                          .logoutMyDashboard(tv);
                    }),
                const SizedBox(
                  width: 10,
                ),
                AppTextButton(
                    label: "Open Queue",
                    buttonColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      NavUtils.navTo(context, DashboardControlScreen(tv: tv));
                    }),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
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
                    "Enter your TV's credentials and press the button below to log in your Dashboard TV",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  AppTextButton(
                      label: "LOGIN TV",
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width - 100,
                      buttonColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        context
                            .read<DashboardControlCubit>()
                            .loginMyDashboard(tv);
                      }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
