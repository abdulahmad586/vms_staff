import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class VisitorMeetingScreen extends StatelessWidget {
  final DashboardTvModel tv;
  const VisitorMeetingScreen({required this.tv, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CURRENT VISITOR",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
      ),
      body: BlocBuilder<DashboardQueueCubit, DashboardQueueState>(
          builder: (context, state) {
        final liveUserIndex = state.queue?.indexWhere(
                (element) => element.id == state.currentVisitorBookingNumber) ??
            -1;
        if (liveUserIndex == -1) {
          return const DashboardMessage(
              title: "No Visitor",
              message: "No visitor has been called in yet");
        } else {
          final visitor = state.queue![liveUserIndex];
          return Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CardImage(
                      imageString: visitor.picture,
                      size: const Size(100, 100),
                      radius: 50),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        [visitor.firstName, visitor.lastName].join(" "),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Iceberg'),
                      ),
                      const Text(" - "),
                      Text(
                        visitor.visitorType.name.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontFamily: 'Iceberg'),
                      ),
                    ],
                  ),
                  Text(
                    "${visitor.designation ?? ""} @ ${visitor.placeOfWork}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey, fontFamily: 'Iceberg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    visitor.bookingNo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Iceberg',
                        color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                    ),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        children: [
                          GenericListItem(
                            label: 'Name',
                            desc: visitor.eventName,
                            verticalPadding: 5,
                          ),
                          GenericListItem(
                            label: 'Location',
                            desc: visitor.visitLocation,
                            verticalPadding: 5,
                            trailing: const Icon(Icons.location_on),
                          ),
                          const Divider(
                            height: 5,
                          ),
                          GenericListItem(
                            label: 'Description',
                            desc: visitor.description ?? "No description",
                            verticalPadding: 5,
                          ),
                          GenericListItem(
                            label: 'Date and Time',
                            desc: visitor.time,
                            verticalPadding: 5,
                            trailing: const Icon(Icons.access_time),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextButton(
                      label: "Mark as Done".toUpperCase(),
                      width: 290,
                      icon: Icons.done_all,
                      buttonColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        context
                            .read<DashboardControlCubit>()
                            .markAppointmentDone(tv.id, tv.group!, visitor.id!);
                      })
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
