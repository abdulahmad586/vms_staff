import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/appointments/state/state.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/shared/shared.dart';

class AppointmentLogScreen extends KFDrawerContent {
  @override
  State<AppointmentLogScreen> createState() => _AppointmentLogScreenState();
}

class _AppointmentLogScreenState extends State<AppointmentLogScreen> {
  RefreshController refreshController = RefreshController();
  BuildContext? cubitContext;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APPOINTMENTS LOG',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
      ),
      body: BlocProvider<AppointmentsCubit>(
        create: (context) => AppointmentsCubit(AppointmentState(),
            refreshController: refreshController),
        child: BlocBuilder<AppointmentsCubit, AppointmentState>(
          builder: (context, state) {
            cubitContext = context;
            ScrollController controller = ScrollController();
            controller.addListener(() {
              if (controller.offset >= controller.position.maxScrollExtent) {
                debouncer(const Duration(milliseconds: 500),
                    () => BlocProvider.of<CardsListCubit>(context).nextPage());
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                            "View all appointments that have been created"),
                        TextPopup(
                            list: const ["All", "Today", "This week"],
                            active: state.view ?? 0,
                            onSelected: (int i) {
                              BlocProvider.of<AppointmentsCubit>(context)
                                  .updateView(i);
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: state.list == null || state.list!.isEmpty
                          ? (state.error != null
                              ? ErrorPage(
                                  message: state.error!,
                                  onContinue: () {
                                    Navigator.pop(context);
                                  },
                                )
                              : EmptyResult(
                                  message: "No appointments found",
                                  loading: state.loading ?? false,
                                ))
                          : AppTable(
                              columns: const [
                                  "Host",
                                  "Guest",
                                  "Location",
                                  "Gate",
                                  "Date",
                                ],
                              data: state.list
                                      ?.map((e) => [
                                            e.hostname ?? e.staff,
                                            e.guest?.fullName ?? "",
                                            e.visitLocation,
                                            e.accessGate,
                                            e.date.toString()
                                          ])
                                      .toList() ??
                                  []),
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
}
