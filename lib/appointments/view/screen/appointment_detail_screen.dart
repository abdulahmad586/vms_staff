import 'package:flutter/material.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> cancelling = ValueNotifier(false);
    return Scaffold(
      appBar: AppBar(
          title: Text('APPOINTMENT DETAILS',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor, fontFamily: 'Iceberg'))),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appointment.label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                appointment.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
              // Guest Details
              if (appointment.guest != null) ...[
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Guest Information',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
                Card(
                  elevation: 0.2,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CardImage(
                          imageString: VisitorModel.getPicture(
                              appointment.guest?.picture),
                          size: const Size(70, 70),
                          radius: 100,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              _buildDataRow(context, "Name: ",
                                  appointment.guest!.fullName),
                              _buildDataRow(
                                  context,
                                  "PoW: ",
                                  appointment.guest!.placeOfWork ??
                                      "No data available"),
                              _buildDataRow(
                                  context,
                                  "Designation: ",
                                  appointment.guest!.designation ??
                                      "No data available"),
                              _buildDataRow(
                                  context, "Phone: ", appointment.guest!.phone),
                              _buildDataRow(
                                  context,
                                  "Email: ",
                                  appointment.guest!.email ??
                                      "No data available"),
                              _buildDataRow(
                                  context,
                                  "Home Address: ",
                                  appointment.guest!.address ??
                                      "No data available"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const Text(
                  'No guest information available.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
              Divider(
                height: 32,
                color: Colors.grey[300],
              ),
              // Appointment Details
              Text(
                'Appointment Details',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0.2,
                child: GenericListItem(
                  verticalPadding: 5,
                  label: "Location",
                  leading: AppIconButton(
                    width: 30,
                    height: 30,
                    icon: Icons.location_on,
                  ),
                  desc: appointment.visitLocation,
                  descStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ),
              Card(
                elevation: 0.2,
                child: GenericListItem(
                  verticalPadding: 5,
                  label: "Access Gate",
                  leading: AppIconButton(
                    width: 30,
                    height: 30,
                    icon: Icons.login,
                  ),
                  desc: appointment.accessGate,
                  descStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ),
              Card(
                elevation: 0.2,
                child: GenericListItem(
                  verticalPadding: 5,
                  label: "Date and Time",
                  leading: const AppIconButton(
                    width: 30,
                    height: 30,
                    icon: Icons.date_range,
                  ),
                  desc:
                      "${CalendarUtils.timeToString(appointment.date, includeTime: false)} ${appointment.time}",
                  descStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                      valueListenable: cancelling,
                      builder: (context, cancellingAP, _) {
                        return AppTextButton(
                            width: 120,
                            label: "Cancel",
                            loading: cancellingAP,
                            buttonColor: Colors.red,
                            textColor: Colors.white,
                            onPressed: () async {
                              Alert.caution(
                                context,
                                message:
                                    "Are you sure you want to cancel this appointment?",
                                title: "Cancel Appointment",
                                onProceed: () async {
                                  try {
                                    cancelling.value = true;
                                    final result = await AppointmentService()
                                        .cancelAppointment(appointment);
                                    cancelling.value = false;

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      Alert.toast(context,
                                          message: "Canceled successfully!",
                                          color: Colors.green);
                                    }
                                  } catch (e) {
                                    cancelling.value = false;

                                    print(e);
                                    if (context.mounted) {
                                      Alert.toast(context,
                                          message: e.toString(),
                                          color: Colors.red);
                                    }
                                  }
                                },
                              );
                            });
                      }),
                  AppTextButton(
                      width: 120,
                      label: "Reschedule",
                      buttonColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        NavUtils.navTo(
                            context, RescheduleAppointmentScreen(appointment),
                            onReturn: (ap) {
                          if (ap is AppointmentModel) {
                            NavUtils.navToReplace(context,
                                AppointmentDetailsScreen(appointment: ap));
                          }
                        });
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
