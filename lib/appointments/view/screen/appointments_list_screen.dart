import 'dart:async';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
// import 'package:map_launcher/map_launcher.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/model/model.dart';

class AppointmentsScreen extends KFDrawerContent {
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool isAdmin = false;
  DateTime initialFrom = DateTime.now();
  DateTime initialTo = DateTime.now();

  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    isAdmin = true;
    // print("IS ADMIN ${BlocProvider.of<MainCubit>(context).user.userType}");
    setTimes(DateTime.now(), null);
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  void setTimes(DateTime time, BuildContext? context) {
    initialFrom = DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
    initialTo = DateTime(time.year, time.month, time.day, 23, 59, 59, 0, 0);
    if (context != null) {
      BlocProvider.of<AppointmentsCubit>(context)
          .changeTimes(initialFrom, initialTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppCubit>().user!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.onMenuPressed!();
            }),
        title: Text('MY APPOINTMENTS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        actions: [
          MorePopup(
              options: ["Sync Calendar"],
              onAction: (i) {
                if (i == 0) {
                  NavUtils.navTo(context, SyncAppointments());
                }
              }),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                NavUtils.navTo(
                    context,
                    AddAppointment(AppointmentModel(
                        date: DateTime.now(),
                        staff: currentUser.id,
                        visitLocation: currentUser.location ?? "",
                        accessGate: currentUser.accessGate ?? "")),
                    onReturn: (appointment) {
                  refreshController.requestRefresh();
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocProvider<AppointmentsCubit>(
        create: (context) => AppointmentsCubit(
            AppointmentState(
                fromTime: initialFrom, toTime: initialTo, list: [], page: 1),
            refreshController: refreshController),
        child: BlocBuilder<AppointmentsCubit, AppointmentState>(
          builder: (context, state) {
            ScrollController controller = ScrollController();
            controller.addListener(() {
              if (controller.offset >= controller.position.maxScrollExtent) {
                debouncer(
                    const Duration(milliseconds: 500),
                    () =>
                        BlocProvider.of<AppointmentsCubit>(context).nextPage());
              }

              if (controller.offset <= controller.position.minScrollExtent &&
                  !controller.position.outOfRange) {}
            });
            return SmartRefresher(
              enablePullDown: true,
              controller: refreshController,
              onRefresh: () {
                BlocProvider.of<AppointmentsCubit>(context)
                    .getData(refresh: true);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CalendarTimeline(
                      initialDate: state.fromTime!,
                      firstDate: DateTime(2019, 1, 15),
                      lastDate: DateTime(2030, 11, 20),
                      onDateSelected: (date) {
                        setTimes(date, context);
                      },
                      leftMargin: 20,
                      monthColor: Colors.blueGrey,
                      dayColor: AppColors.primaryColor,
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: Theme.of(context).hintColor,
                      // selectableDayPredicate: (date) => date.day != 23,
                      locale: 'en_ISO',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(CalendarUtils.isSameDay(
                            DateTime.now(), state.fromTime!)
                        ? "Today's appointments"
                        : "Appointments on ${CalendarUtils.timeToString(state.fromTime!, includeTime: false)}"),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Builder(
                        builder: (_) {
                          if (state.error != null && state.error!.isNotEmpty) {
                            return ErrorPage(
                                message: state.error,
                                onContinue: () {
                                  refreshController.requestRefresh();
                                });
                          } else if (state.list == null ||
                              state.list!.isEmpty) {
                            return EmptyResult(
                              message: "No appointments found",
                              loading: state.loading ?? false,
                            );
                          } else {
                            return ListView.builder(
                                itemCount: state.list?.length ?? 0,
                                controller: controller,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 0.3,
                                    child: GenericListItem(
                                      onPressed: () {
                                        NavUtils.navTo(
                                            context,
                                            AppointmentDetailsScreen(
                                                appointment:
                                                    state.list![index]),
                                            onReturn: (res) {
                                          refreshController.requestRefresh();
                                        });
                                      },
                                      verticalPadding: 10,
                                      leading: Column(
                                        children: [
                                          CardImage(
                                            imageString:
                                                VisitorModel.getPicture(state
                                                    .list![index]
                                                    .guest
                                                    ?.picture),
                                            size: const Size(40, 40),
                                            radius: 5,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${state.list?[index].time}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ],
                                      ),
                                      label: state.list![index].label,
                                      desc:
                                          state.list![index].guest?.fullName ??
                                              "No visitor",
                                      desc2:
                                          "${state.list![index].guest?.designation ?? "No desg."} . ${state.list![index].guest?.placeOfWork ?? ""}",
                                      trailing:
                                          state.list![index].meetingFinished
                                              ? const AppIconButton(
                                                  height: 30,
                                                  width: 30,
                                                  icon: Icons.verified,
                                                  iconSize: 15,
                                                  iconColor: Colors.white,
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                )
                                              : const Icon(
                                                  Icons.keyboard_arrow_right),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Timer? canceller;
  void debouncer(Duration delay, Function fn) {
    if (canceller?.isActive ?? false) canceller?.cancel();
    canceller = Timer(delay, () {
      fn();
    });
  }

  void trackLocation(double locationLat, double locationLong,
      {String title = "Meeting location"}) async {
    Alert.toast(context, message: "Launching map...");
    // final availableMaps = await MapLauncher.installedMaps;
    // // print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
    // if(availableMaps.isNotEmpty){
    //   await availableMaps.first.showMarker(
    //     coords: Coords(locationLat, locationLong),
    //     title: title,
    //   );
    // }else{
    //   Alert.toast(context, message: "No maps found");
    // }
  }
}
