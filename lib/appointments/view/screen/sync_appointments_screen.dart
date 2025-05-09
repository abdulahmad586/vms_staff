import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:persistent_device_calendar/persistent_device_calendar.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/shared/shared.dart';

class SyncAppointments extends StatefulWidget {
  @override
  State<SyncAppointments> createState() => _SyncAppointmentsState();
}

class _SyncAppointmentsState extends State<SyncAppointments> {
  RefreshController refreshController = RefreshController();
  bool loading = false;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var times = CalendarUtils.getBeginningAndEndOfMonth(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('SYNCHRONIZE MEETINGS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
      ),
      body: BlocProvider<AppointmentsCubit>(
        create: (context) => AppointmentsCubit(
          AppointmentState(
              fromTime: DateTime.now(), toTime: times['to'], pageSize: 500),
          refreshController: refreshController,
        ),
        child: BlocBuilder<AppointmentsCubit, AppointmentState>(
          builder: (context, state) {
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
                    Text(
                      'Synchronize this month\'s meetings to your device calendar',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    // AppTabHeader(tabsList: const ['Normal users', 'Admins'], selectedTab: _tab, onTabChange: (int t)=> _tab = t,),
                    Expanded(
                      child: state.list == null || state.list!.isEmpty
                          ? EmptyResult(
                              message: "No meetings found",
                              loading: state.loading ?? false,
                            )
                          : ListView.builder(
                              itemCount: state.list!.length,
                              itemBuilder: (_, index) =>
                                  MeetingListItem(state.list![index],
                                      trailing: Column(
                                        children: [
                                          Icon(
                                            Icons.people,
                                            color: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.color
                                                ?.withAlpha(100),
                                          ),
                                          Text(
                                            (state.list![index].id).toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                          ),
                                        ],
                                      )),
                            ),
                    ),
                    AppTextButton(
                      buttonColor: AppColors.primaryColor,
                      textColor: Colors.white,
                      label: "SYNC NOW",
                      loading: loading,
                      onPressed: () async {
                        if (state.list != null && state.list!.isNotEmpty) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            await sync(state.list!);
                            setState(() {
                              loading = false;
                            });
                            Alert.message(context,
                                title: "Synced!",
                                message: "Calendar synced successfully",
                                error: false, close: () {
                              Navigator.pop(context);
                            });
                          } catch (e) {
                            Alert.message(context,
                                message:
                                    "Unable to sync to device calendar, please make sure you have granted permission to the app.",
                                error: true);
                            setState(() {
                              loading = false;
                            });
                          }
                        } else {
                          Alert.toast(context,
                              message: "Can't sync an empty list");
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final String _appName = dotenv.env['app_name'] as String;
  // final String _appFullName = (dotenv.env['full_name'] as String) + '\n'+(dotenv.env['app_desc'] as String);

  Future<void> sync(List<AppointmentModel> meetings) async {
/*
    var calPlugin = PersistentDeviceCalendar();
    if (!await calPlugin.setup()) return; // Setup permissions or return if not granted
    // print("READYYY");
    var location = getLocation("Africa/Lagos");

    var calendar = await calPlugin.getCalendar<AppointmentModel>(name: _appName,
        builder: (event, calendarId, eventId) => Event(calendarId, eventId: eventId, title: event.label, start: TZDateTime.from(event.date, location).subtract(Duration(hours:1)), end: TZDateTime.from(event.date, location).add(Duration(hours: 1))),
        idSelector: (event) => event.id
    );
    await calendar.prune(); // Optionally remove registered events which have been deleted on the device
    await calendar.put(meetings); // Put events, possibly replacing old version
*/
  }

  Timer? canceller;
  void debouncer(Duration delay, Function fn) {
    if (canceller?.isActive ?? false) canceller?.cancel();
    canceller = Timer(delay, () {
      fn();
    });
  }
}
