import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';

import '../../../shared/shared.dart';

class DashboardLoggedInWidget extends StatefulWidget {
  final DashboardTvModel tv;
  const DashboardLoggedInWidget(this.tv, {super.key});

  @override
  State<DashboardLoggedInWidget> createState() =>
      _DashboardLoggedInWidgetState();
}

class _DashboardLoggedInWidgetState extends State<DashboardLoggedInWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardQueueCubit>(
        create: (_) =>
            DashboardQueueCubit(context, DashboardQueueState(), tv: widget.tv),
        child: BlocBuilder<DashboardQueueCubit, DashboardQueueState>(
          builder: (BuildContext context, state) {
            return PopScope(
              onPopInvoked: (popped) {
                context.read<DashboardQueueCubit>().dispose();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: state.queue == null || state.queue!.isEmpty
                    ? (state.error != null
                        ? ErrorPage(
                            message: state.error!,
                            onContinue: () {
                              Navigator.pop(context);
                            },
                          )
                        : EmptyResult(
                            message: "No visitors found",
                            loading: state.loading ?? false,
                          ))
                    : ListView.builder(
                        itemCount: state.queue!.length,
                        itemBuilder: (_, index) => VisitorQueueListItem(
                          state.queue![index],
                          isActive: index == 0 ||
                              state.currentVisitorBookingNumber ==
                                  state.queue![index].bookingNo,
                          onPressed: () {
                            // NavUtils.
                          },
                        ),
                      ),
              ),
            );
          },
        ));
  }
}
