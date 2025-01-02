import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/waiting_rooms/waiting_rooms.dart';

class WaitingRoomListScreen extends KFDrawerContent {
  @override
  State<WaitingRoomListScreen> createState() => _WaitingRoomListScreenState();
}

class _WaitingRoomListScreenState extends State<WaitingRoomListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.onMenuPressed!();
              }),
          title: Text('WAITING ROOMS',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Manage queues in your waiting rooms"),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DashboardStatWidget(
                    icon: Icons.meeting_room_outlined,
                    showShadow: false,
                    onClick: () {
                      // NavUtils.navTo(context, AppointmentLoggerScreen());
                    },
                    backgroundColor: AppColors.primaryColor.withOpacity(0.5),
                    label: "Waiting Rooms",
                    display: "2",
                    width: (MediaQuery.of(context).size.width / 2) - 20,
                  ),
                  DashboardStatWidget(
                    icon: Icons.logout,
                    showShadow: false,
                    iconBackgroundColor: AppColors.secondaryColor,
                    onClick: () {
                      // NavUtils.navTo(context, AppointmentCheckoutScreen());
                    },
                    label: "Appointments",
                    display: "234",
                    backgroundColor: AppColors.secondaryColor.withOpacity(0.5),
                    width: (MediaQuery.of(context).size.width / 2) - 20,
                  ),
                  // StatWidget(icon: Icons.location_history, showShadow: false, iconBackgroundColor:Colors.yellow, onClick: (){
                  //   NavUtils.navTo(context, const AppointmentCheckpointScreen());
                  // }, label: "Check-point", backgroundColor: Colors.yellow.withOpacity(0.5), width: (MediaQuery.of(context).size.width/3)-20, iconColor:Colors.grey[600],),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text("Waiting rooms"),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: WaitingRoomsList())
            ],
          ),
        ));
  }
}
