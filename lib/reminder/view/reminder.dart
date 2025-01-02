import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shevarms_user/reminder/reminder.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:table_calendar/table_calendar.dart';

class RemindersScreen extends KFDrawerContent {
  RemindersScreen();

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  int selectedTab = 0;

  late final ValueNotifier<List<ReminderModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool hideCalendar = false;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<ReminderModel> _getEventsForDay(DateTime day) {
    return [];
  }

  List<ReminderModel> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.onMenuPressed!();
            }),
        title: Text('REMINDERS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                hideCalendar = !hideCalendar;
              });
            },
            icon: const Icon(
              Icons.calendar_today,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: isLandscape
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCalendarSection(),
                  Expanded(child: Center(child: _buildRemindersList())),
                ],
              )
            : Column(
                children: [
                  _buildCalendarSection(),
                  Expanded(child: Center(child: _buildRemindersList())),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          NavUtils.navTo(context, AddReminder());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 350),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 700,
            ),
            curve: Curves.easeInOut,
            child: TableCalendar<ReminderModel>(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 1000000)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: CalendarFormat.month,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                    ),
                    SizedBox(width: 3),
                    Text('Personal'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 3),
                    Text('Official'),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.yellow,
                    ),
                    SizedBox(width: 3),
                    Text('Family & Friends'),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(width: 3),
                    Text('Others'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildRemindersList() {
    return Column(
      children: [
        ValueListenableBuilder<List<ReminderModel>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return value.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const Icon(
                          Icons.access_time,
                          size: 90,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You have no reminders for today',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final element = value[index];
                      Color getColorForCategory(String category) {
                        if (category ==
                            ReminderCategory.personal.name[0].toUpperCase() +
                                ReminderCategory.personal.name.substring(1)) {
                          return Colors.red;
                        } else if (category ==
                            ReminderCategory.official.name[0].toUpperCase() +
                                ReminderCategory.official.name.substring(1)) {
                          return Theme.of(context).primaryColor;
                        } else if (category ==
                            ReminderCategory.familyAndFriends.name[0]
                                    .toUpperCase() +
                                ReminderCategory.familyAndFriends.name
                                    .substring(1)) {
                          return Colors.yellow;
                        } else {
                          return Colors.blue;
                        }
                      }

                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 10,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              color: getColorForCategory(
                                  element.calendarModelType),
                            ),
                          ),
                          title: Text(
                            element.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${TimeOfDay(hour: element.date.hour, minute: element.date.minute).format(context)}-${TimeOfDay(hour: element.date.hour, minute: element.date.minute).format(context)}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
          },
        ),
      ],
    );
  }
}
