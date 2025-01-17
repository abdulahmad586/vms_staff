import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/waiting_rooms/waiting_rooms.dart';

class WaitingRoomVisitorsListScreen extends StatefulWidget {
  final WaitingRoomModel waitingRoom;
  const WaitingRoomVisitorsListScreen(this.waitingRoom, {super.key});

  @override
  State<WaitingRoomVisitorsListScreen> createState() =>
      _WaitingRoomVisitorsListScreenState();
}

class _WaitingRoomVisitorsListScreenState
    extends State<WaitingRoomVisitorsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WAITING ROOM",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'waiting-room-${widget.waitingRoom.id}',
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.waitingRoom.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(widget.waitingRoom.location)
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.waitingRoom.queueSize.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontSize: 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text("Visitors queue"),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: WaitingRoomVisitorsList())
            ],
          ),
        ));
  }
}
