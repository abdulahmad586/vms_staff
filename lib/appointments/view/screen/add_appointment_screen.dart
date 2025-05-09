import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/appointments/view/screen/staff_search_screen.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class AddAppointment extends StatefulWidget {
  AppointmentModel meeting;
  AddAppointment(this.meeting);

  @override
  State<StatefulWidget> createState() {
    return _AddAppointmentState();
  }
}

class _AddAppointmentState extends State<AddAppointment> {
  late TextEditingController dateController;

  late TextEditingController topicController,
      descriptionController,
      calendarController,
      hostnameController;

  final _formKey = GlobalKey<FormState>();
  final _hostnameKey = GlobalKey();
  final _hostKey = GlobalKey();

  String? stat;
  bool? loading;

  @override
  void initState() {
    dateController = TextEditingController.fromValue(TextEditingValue(
        text: CalendarUtils.timeToString(widget.meeting.date,
            includeTime: true)));
    topicController = TextEditingController.fromValue(
        TextEditingValue(text: widget.meeting.label));
    topicController = TextEditingController.fromValue(
        TextEditingValue(text: widget.meeting.label));
    descriptionController = TextEditingController.fromValue(
        TextEditingValue(text: widget.meeting.description));
    calendarController = TextEditingController.fromValue(
        TextEditingValue(text: widget.meeting.calendar));
    hostnameController = TextEditingController.fromValue(
        TextEditingValue(text: widget.meeting.hostname ?? ''));
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
                  "Add new appointment",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Fill the form below to register a meeting",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Meeting Information",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(height: 15),
                AppTextField(
                  labelText: 'Topic',
                  widthPercentage: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Topic is required';
                    }
                    return null;
                  },
                  controller: topicController,
                  onChange: (str) {
                    // setState(() {
                    widget.meeting.label = str;
                    // });
                  },
                  keyboardType: TextInputType.name,
                  icon: Icons.topic,
                ),
                const SizedBox(height: 15),
                AppTextDropdown(
                  labelText: 'Select calendar',
                  widthPercentage: 100,
                  enableSearch: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Calendar is required';
                    }
                    return null;
                  },
                  initialValue: widget.meeting.calendar,
                  list: const ["Personal", "Official", "FaF", "Others"],
                  onChanged: (str) {
                    // setState(() {
                    if (str is String) {
                      setState(() {
                        widget.meeting.calendar = "";
                      });
                    } else {
                      setState(() {
                        widget.meeting.calendar =
                            (str as DropDownValueModel).name;
                      });
                    }
                    // });
                  },
                  keyboardType: TextInputType.name,
                  icon: Icons.topic,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  labelText: 'Description',
                  widthPercentage: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  onChange: (str) {
                    // setState(() {
                    widget.meeting.description = str;
                    // });
                  },
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.description,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Meeting Date & Time",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(children: [
                  TimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.date,
                    // paddingHorizontal: 50,
                    initTime: widget.meeting.date,
                    minTime: DateTime.now().subtract(Duration(days: 10)),
                    // maxTime: DateTime.now().add(const Duration(days: 99999999)),
                    barrierColor:
                        Colors.black12, //Barrier Color when pop up show
                    onChange: (dateTime) {
                      var setDate = widget.meeting.date;
                      var date = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          setDate.hour,
                          setDate.minute,
                          setDate.second,
                          0);
                      setState(() {
                        widget.meeting.date = date;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  TimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.time,
                    initTime: widget.meeting.date,
                    minTime: DateTime.now().subtract(Duration(days: 10)),
                    // maxTime: DateTime.now().add(const Duration(days: 10)),
                    barrierColor:
                        Colors.black12, //Barrier Color when pop up show
                    onChange: (dateTime) {
                      var setDate = widget.meeting.date;
                      var date = DateTime(
                          setDate.year,
                          setDate.month,
                          setDate.day,
                          dateTime.hour,
                          dateTime.minute,
                          dateTime.second,
                          0);
                      setState(() {
                        widget.meeting.date = date;
                      });
                    },
                    // Customize your time format
                    // timeFormat: 'dd/MM/yyyy',
                  ),
                ]),
                const SizedBox(height: 25),
                if (context.read<AppCubit>().user?.userType ==
                    UserType.deptAdmin)
                  Text(
                    "Meeting Host",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                if (context.read<AppCubit>().user?.userType ==
                    UserType.deptAdmin)
                  const SizedBox(
                    height: 15,
                  ),
                if (context.read<AppCubit>().user?.userType ==
                    UserType.deptAdmin)
                  (widget.meeting.host == null
                      ? AppTextField(
                          labelText: 'Host',
                          widthPercentage: 100,
                          key: _hostKey,
                          focusNode: AlwaysDisabledFocusNode(),
                          validator: (s) => s == null || s.isEmpty
                              ? "This field is required"
                              : null,
                          onTap: () {
                            NavUtils.navTo(context, const StaffSearchScreen(),
                                onReturn: (staff) {
                              if (staff is User) {
                                setState(() {
                                  widget.meeting.host = staff;
                                });
                              }
                            });
                          },
                          keyboardType: TextInputType.name,
                          icon: Icons.person,
                        )
                      : AppTextField(
                          key: _hostnameKey,
                          labelText: 'Host',
                          widthPercentage: 100,
                          controller: TextEditingController(
                              text: widget.meeting.host?.fullName),
                          focusNode: AlwaysDisabledFocusNode(),
                          suffixIcon:
                              CustomIconButton(Icons.clear, onPressed: () {
                            setState(() {
                              widget.meeting.host = null;
                            });
                          }),
                          keyboardType: TextInputType.name,
                          icon: Icons.person,
                        )),
                const SizedBox(height: 15),
                Text(
                  "Visitor Profile",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Search for the visitor if they exist, or create a new profile",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
                if (widget.meeting.guest == null)
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          labelText: 'Search visitor by phone',
                          widthPercentage: 90,
                          keyboardType: TextInputType.phone,
                          validator: (s) => s == null || s.isEmpty
                              ? "This field is required"
                              : null,
                          focusNode: AlwaysDisabledFocusNode(),
                          onTap: () {
                            NavUtils.navTo(context, const VisitorSearchScreen(),
                                onReturn: (visitor) {
                              if (visitor is VisitorModel) {
                                setState(() {
                                  widget.meeting.guest = visitor;
                                });
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      AppIconButton(
                        icon: Icons.add,
                        onTap: () {
                          NavUtils.navTo(
                              context,
                              const EnrolVisitorScreen(
                                allowMinimumData: true,
                              ), onReturn: (visitor) {
                            if (visitor is VisitorModel) {
                              setState(() {
                                widget.meeting.guest = visitor;
                              });
                            }
                          });
                        },
                        backgroundColor: AppColors.primaryColor,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                if (widget.meeting.guest != null)
                  VisitorListItem(
                    widget.meeting.guest!,
                    trailing: CustomIconButton(
                      Icons.clear,
                      onPressed: () =>
                          setState(() => widget.meeting.guest = null),
                    ),
                  ),
                SizedBox(
                  height: 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(stat ?? '',
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                ),
                const SizedBox(height: 10),
                AppTextButton(
                  buttonColor: AppColors.primaryColor,
                  textColor: Colors.white,
                  width: 290,
                  loading: loading ?? false,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    if (widget.meeting.guest == null) {
                      setState(() {
                        stat = "Please select visitor";
                      });
                      return;
                    }
                    setState(() {
                      loading = true;
                    });
                    AppointmentService()
                        .createMeeting(widget.meeting)
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Alert.toast(context,
                          message: 'Appointment added successfully',
                          color: Colors.green);
                      Future.delayed(
                          const Duration(
                            milliseconds: 500,
                          ), () {
                        Navigator.pop(context);
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
