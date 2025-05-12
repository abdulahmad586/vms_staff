import 'package:flutter/material.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/shared/shared.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  AppointmentModel appointment;
  RescheduleAppointmentScreen(this.appointment);

  @override
  State<StatefulWidget> createState() {
    return _RescheduleAppointmentScreenState();
  }
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  late TextEditingController dateController;

  late TextEditingController topicController,
      descriptionController,
      calendarController;

  final _formKey = GlobalKey<FormState>();

  String? stat;
  bool? loading;

  @override
  void initState() {
    dateController = TextEditingController.fromValue(TextEditingValue(
        text:
            "${CalendarUtils.timeToString(widget.appointment.date, includeTime: false)} ${widget.appointment.time}"));
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    topicController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "RESCHEDULE APPOINTMENT",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Please select a new time for this appointment to be moved",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  height: 40,
                ),
                AppTextField(
                  labelText: "Old Date & Time",
                  controller: dateController,
                  enabled: false,
                ),
                const SizedBox(height: 15),
                const Text("New Date & Time"),
                const SizedBox(height: 10),
                AppDateTimeField(
                  labelText: 'Date & Time',
                  hintText: 'Pick date & time',
                  initialValue: widget.appointment.date,
                  minimumDate: DateTime.now().add(const Duration(minutes: 10)),
                  onChange: (dateTime) {
                    setState(() {
                      widget.appointment.date = dateTime;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(stat ?? '',
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                ),
                const SizedBox(height: 30),
                AppTextButton(
                  buttonColor: AppColors.primaryColor,
                  textColor: Colors.white,
                  width: 290,
                  loading: loading ?? false,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    setState(() {
                      loading = true;
                    });
                    AppointmentService()
                        .rescheduleAppointment(widget.appointment)
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Alert.toast(context,
                          message: 'Appointment rescheduled successfully',
                          color: Colors.green);
                      Future.delayed(
                          const Duration(
                            milliseconds: 500,
                          ), () {
                        Navigator.pop(context, value);
                      });
                    }).catchError((e) {
                      setState(() {
                        loading = false;
                      });
                      Alert.message(context,
                          message: e.toString(), error: true);
                    });
                  },
                  label: 'CONTINUE',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
