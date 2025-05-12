import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/reminder/reminder.dart';
import 'package:shevarms_user/shared/shared.dart';

class AddReminder extends StatelessWidget {
  AddReminder({super.key});

  final List<String> calendars = const [
    'Personal',
    'Official',
    'Family & Friends',
    'Others',
  ];

  final List<String> _reminderChannels = const [
    'SMS',
    'SMS Flash',
    'Email',
    'Ring',
    'Text to Speech',
    'Conferencing',
    'Voice',
  ];

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return BlocProvider<AddReminderCubit>(
      create: (_) => AddReminderCubit(AddReminderState()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Reminder'),
        ),
        body: BlocBuilder<AddReminderCubit, AddReminderState>(
            builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      if (isLandscape)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildReminderDetails(context, state),
                            const SizedBox(
                              width: 20,
                            ),
                            _buildReminderOptions(context, state),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildReminderDetails(context, state),
                            _buildReminderOptions(context, state),
                          ],
                        ),
                      SizedBox(
                        height: 30,
                        child: Center(
                          child: Text(state.error ?? ""),
                        ),
                      ),
                      Center(
                        child: AppTextButton(
                          buttonColor: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          loading: state.loading ?? false,
                          width: MediaQuery.of(context).size.width - 80,
                          label: "Save",
                          onPressed: () async {
                            try {
                              if (!(formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              } else if (state.channels?.isEmpty ?? true) {
                                Alert.message(context,
                                    message:
                                        "Please select at least one notification medium");
                                return;
                              }
                              final reminder = await context
                                  .read<AddReminderCubit>()
                                  .addReminder(context.read<AppCubit>().user!);
                              if (context.mounted) {
                                Navigator.pop(context, reminder);
                                Alert.toast(context,
                                    message: "Reminder queued successfully",
                                    color: Colors.green);
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReminderDetails(BuildContext context, AddReminderState state) {
    return Column(
      children: [
        const Text("Reminder Details"),
        const SizedBox(height: 5),
        AppTextField(
          labelText: "Reminder name",
          initialValue: state.reminderName,
          onChange: context.read<AddReminderCubit>().updateName,
          validator: (s) {
            if (s == null || s.isEmpty) return "This field is required";
            return null;
          },
        ),
        const SizedBox(height: 15),
        AppTextDropdown(
          validator: (text) =>
              text == null || text.isEmpty ? "Field is required" : null,
          labelText: "Calendar",
          keyboardType: TextInputType.name,
          enableSearch: false,
          initialValue: state.calendarType,
          onChanged: (val) {
            if (val is String) {
              return;
            }
            context
                .read<AddReminderCubit>()
                .updateType((val as DropDownValueModel).value as String);
          },
          list: calendars,
        ),
        const SizedBox(height: 15),
        AppDateTimeField(
          labelText: 'Date & Time',
          hintText: 'Pick date & time',
          minimumDate: DateTime.now().add(const Duration(minutes: 10)),
          initialValue: state.time,
          onChange: (dateTime) {
            context.read<AddReminderCubit>().updateTime(dateTime);
          },
        ),
        const SizedBox(height: 15),
        AppTextField(
          initialValue: state.description,
          hintText: 'Description',
          minLines: 2,
          maxLines: 3,
          maxLength: 200,
          onChange: context.read<AddReminderCubit>().updateDescription,
          validator: (s) {
            if (s == null || s.isEmpty) return "This field is required";
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildReminderOptions(BuildContext context, AddReminderState state) {
    return Column(
      children: [
        const Text("How would you like to be reminded?"),
        const SizedBox(height: 5),
        Container(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Card(
            elevation: 0,
            color: Colors.grey[300],
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              children: [
                ..._reminderChannels.map((String key) {
                  return CheckboxListTile(
                    dense: true,
                    title: Text(key),
                    value: state.channels?.contains(key) ?? false,
                    onChanged: (bool? value) {
                      if (value ?? false) {
                        context.read<AddReminderCubit>().addChannel(key);
                      } else {
                        context.read<AddReminderCubit>().removeChannel(key);
                      }
                    },
                  );
                }).toList(),
                if (state.channels?.contains("Voice") ?? false)
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AppTextField(
                        labelText: state.recordedVoice == null
                            ? "Record Voice"
                            : "Finished recording",
                        focusNode: AlwaysDisabledFocusNode(),
                        validator: (s) {
                          if (state.recordedVoice == null) {
                            return "Please record voice";
                          }
                          return null;
                        },
                        prefixIcon: state.recordedVoice == null
                            ? null
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AppIconButton(
                                  icon: Icons.clear,
                                  width: 30,
                                  height: 30,
                                  onTap: () {
                                    context
                                        .read<AddReminderCubit>()
                                        .updatedRecordedVoice(null);
                                  },
                                ),
                              ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if ((state.playingVoice ?? false) ||
                                  (state.recordingVoice ?? false))
                                Text((state.playingVoice ?? false)
                                    ? "${state.playbackDuration?.inSeconds ?? 0} s"
                                    : "${state.recordedDuration?.inSeconds ?? 0} s"),
                              const SizedBox(
                                width: 5,
                              ),
                              AppIconButton(
                                height: 30,
                                width: 30,
                                icon: state.recordedVoice == null
                                    ? ((state.recordingVoice ?? false)
                                        ? Icons.stop
                                        : Icons.mic)
                                    : ((state.playingVoice ?? false)
                                        ? Icons.stop
                                        : Icons.play_circle),
                                onTap: () {
                                  if (state.recordedVoice == null) {
                                    context
                                        .read<AddReminderCubit>()
                                        .toggleRecording(context);
                                  } else {
                                    context
                                        .read<AddReminderCubit>()
                                        .togglePlayback();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
