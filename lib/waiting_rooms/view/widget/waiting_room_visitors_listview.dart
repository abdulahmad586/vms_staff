import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/waiting_rooms/waiting_rooms.dart';

class WaitingRoomVisitorsList extends StatelessWidget {
  final RefreshController refreshController = RefreshController();

  WaitingRoomVisitorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VisitorsWaitingRoomListCubit>(
      create: (context) => VisitorsWaitingRoomListCubit(
          VisitorsWaitingRoomListState(), refreshController),
      child: BlocBuilder<VisitorsWaitingRoomListCubit,
          VisitorsWaitingRoomListState>(
        builder: (context, state) {
          ScrollController controller = ScrollController();
          controller.addListener(() {
            if (controller.offset >= controller.position.maxScrollExtent) {
              debouncer(
                  const Duration(milliseconds: 500),
                  () => BlocProvider.of<VisitorsWaitingRoomListCubit>(context)
                      .getData());
            }

            if (controller.offset <= controller.position.minScrollExtent &&
                !controller.position.outOfRange) {}
          });

          return SmartRefresher(
            enablePullDown: true,
            controller: refreshController,
            onRefresh: () {
              BlocProvider.of<WaitingRoomListCubit>(context).getData();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: state.visitors == null || state.visitors!.isEmpty
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
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisExtent: 95),
                      itemCount: state.visitors!.length,
                      controller: controller,
                      itemBuilder: (_, index) => WaitingRoomVisitorListItem(
                        state.visitors![index],
                        onPressed: () {
                          // NavUtils.
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Timer? canceller;
  void debouncer(Duration delay, Function fn) {
    if (canceller?.isActive ?? false) canceller?.cancel();
    canceller = Timer(delay, () {
      fn();
    });
  }
}
