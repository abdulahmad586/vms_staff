import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/waiting_rooms/view/screen/waiting_room_visitors.dart';
import 'package:shevarms_user/waiting_rooms/waiting_rooms.dart';
import 'package:shevarms_user/shared/shared.dart';

class WaitingRoomsList extends StatelessWidget{

  final RefreshController refreshController = RefreshController();

  WaitingRoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaitingRoomListCubit>(
      create: (context)=>WaitingRoomListCubit(WaitingRoomListState(), refreshController),
      child: BlocBuilder<WaitingRoomListCubit,WaitingRoomListState>(
        builder: (context, state){
          ScrollController controller = ScrollController();
          controller.addListener(() {
            if (controller.offset >= controller.position.maxScrollExtent) {
              // debouncer(const Duration(milliseconds: 500), ()=>BlocProvider.of<WaitingRoomListCubit>(context).nextPage());
            }

            if (controller.offset <= controller.position.minScrollExtent &&
                !controller.position.outOfRange) {}
          });

          return  SmartRefresher(
            enablePullDown: true,
            controller: refreshController,
            onRefresh: () {
              BlocProvider.of<WaitingRoomListCubit>(context).getData();
            },child:Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: state.rooms ==null || state.rooms!.isEmpty ? ( state.error !=null ? ErrorPage(message: state.error!, onContinue: () { Navigator.pop(context); },) : EmptyResult(message: "No users found",loading: state.loading ?? false,)):
                  ListView.builder(
                    itemCount: state.rooms!.length,
                    controller: controller,
                    itemBuilder: (_, index)=> Hero(
                      tag: 'waiting-room-${state.rooms![index].id}',
                      child: WaitingRoomsListItem(
                        state.rooms![index],
                        onTap: (){
                          NavUtils.navTo(context, WaitingRoomVisitorsListScreen(state.rooms![index]));
                        },
                        trailing: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(state.rooms![index].queueSize.toString(), style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }

  Timer? canceller;
  void debouncer(Duration delay,Function fn) {
    if (canceller?.isActive ?? false) canceller?.cancel();
    canceller = Timer(delay, () {
      fn();
    });
  }

}