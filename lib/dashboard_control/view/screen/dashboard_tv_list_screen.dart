import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/dashboard_control/view/screen/dashboard_login_screen.dart';
import 'package:shevarms_user/shared/shared.dart';

class DashboardTVsListScreen extends KFDrawerContent {
  @override
  State<DashboardTVsListScreen> createState() => _DashboardTVsListScreenState();
}

class _DashboardTVsListScreenState extends State<DashboardTVsListScreen> {
  @override
  Widget build(BuildContext context) {
    final refreshController = RefreshController();
    return BlocBuilder<DashboardControlCubit, DashboardControlState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  widget.onMenuPressed!();
                }),
            title: Text('DASHBOARD TVs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryColor, fontFamily: 'Iceberg')),
          ),
          floatingActionButton: state.tv == null && !(state.loading ?? false)
              ? FloatingActionButton(
                  onPressed: () {
                    NavUtils.navTo(context, const NewDashboardTVScreen());
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.add),
                )
              : null,
          body: (state.socketConnected ?? false)
              ? Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Manage TVs that are online/logged-in"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DashboardStatWidget(
                            icon: Icons.online_prediction,
                            showShadow: false,
                            textColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                            iconBackgroundColor:
                                AppColors.primaryColor.withOpacity(0.5),
                            iconColor: Colors.white,
                            label: "Online",
                            display: (state.onlineTVs?.length ?? 0).toString(),
                            width: (MediaQuery.of(context).size.width / 2) - 20,
                          ),
                          DashboardStatWidget(
                            icon: Icons.login,
                            showShadow: false,
                            iconBackgroundColor: AppColors.secondaryColor,
                            onClick: () {
                              // NavUtils.navTo(context, AppointmentCheckoutScreen());
                            },
                            label: "Logged in",
                            display: state.loggedInLength.toString(),
                            backgroundColor:
                                AppColors.secondaryColor.withOpacity(0.5),
                            iconColor: Colors.white,
                            width: (MediaQuery.of(context).size.width / 2) - 20,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("Online Dashboard TVs"),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: SmartRefresher(
                        enablePullDown: true,
                        controller: refreshController,
                        onRefresh: () {
                          BlocProvider.of<DashboardControlCubit>(context)
                              .refreshDashboards();
                          refreshController.loadComplete();
                        },
                        child: state.onlineTVs == null ||
                                state.onlineTVs!.isEmpty
                            ? (state.error != null
                                ? ErrorPage(
                                    message: state.error!,
                                    onContinue: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                : EmptyResult(
                                    message: "TVs are all offline",
                                    loading: state.loading ?? false,
                                  ))
                            : ListView.builder(
                                itemCount: state.onlineTVs!.length,
                                itemBuilder: (_, index) => Hero(
                                  tag:
                                      'online-tv-${state.onlineTVs![index].id}',
                                  child: DashboardTVListItem(
                                    state.onlineTVs![index],
                                    onTap: () {
                                      // NavUtils.navTo(context, WaitingRoomVisitorsListScreen(state.rooms![index]));
                                    },
                                    trailing: MorePopup(
                                      onAction: (a) {
                                        switch (a) {
                                          case 0:
                                            if (state
                                                    .onlineTVs![index].status ==
                                                DashboardTvState.loggedIn) {
                                              NavUtils.navTo(
                                                  context,
                                                  DashboardControlScreen(
                                                      tv: state
                                                          .onlineTVs![index]));
                                            } else {
                                              Alert.toast(context,
                                                  message:
                                                      "Please login first");
                                            }
                                            break;
                                          case 1:
                                            NavUtils.navTo(
                                                context,
                                                DashboardTvLoginScreen(
                                                  state.onlineTVs![index],
                                                ));
                                            break;
                                        }
                                      },
                                      options: [
                                        "View queue",
                                        state.onlineTVs![index].status ==
                                                DashboardTvState.loggedIn
                                            ? "Logout"
                                            : "Login",
                                        "Shutdown",
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ))
                    ],
                  ),
                )
              : const SocketConnectionProblem());
    });
  }
}
