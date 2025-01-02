import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/notifications/notifications.dart' as app;
import 'package:shevarms_user/notifications/notifications.dart';
import 'package:shevarms_user/shared/shared.dart';

class NotificationsPage extends KFDrawerContent {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _tab = 0;

  List<String> views = ["All", "Unread", "Read"];
  int currentView = 0;

  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.onMenuPressed!();
            }),
        title: Text('NOTIFICATIONS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
      ),
      body: BlocProvider<NotificationsListCubit>(
        create: (context) => NotificationsListCubit(NotificationsListState(),
            refreshController: refreshController),
        child: BlocBuilder<NotificationsListCubit, NotificationsListState>(
          builder: (context, state) {
            ScrollController controller = ScrollController();
            controller.addListener(() {
              if (controller.offset >= controller.position.maxScrollExtent) {
                debouncer(
                    Duration(milliseconds: 500),
                    () => BlocProvider.of<NotificationsListCubit>(context)
                        .nextPage());
              }

              if (controller.offset <= controller.position.minScrollExtent &&
                  !controller.position.outOfRange) {}
            });

            return SmartRefresher(
              enablePullDown: true,
              controller: refreshController,
              onRefresh: () {
                BlocProvider.of<NotificationsListCubit>(context)
                    .getData(refresh: true);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'View notifications',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                        TextPopup(
                            list: views,
                            active: state.view ?? 0,
                            onSelected: (int i) {
                              BlocProvider.of<NotificationsListCubit>(context)
                                  .changeView(i);
                            })
                      ],
                    ),
                    const SizedBox(height: 10),
                    // AppTabHeader(tabsList: const ['Normal users', 'Admins'], selectedTab: _tab, onTabChange: (int t)=> _tab = t,),
                    Expanded(
                      child: state.list == null || state.list!.isEmpty
                          ? EmptyResult(
                              message: "No notifications found",
                              loading: state.loading ?? false)
                          : ListView.builder(
                              itemCount: state.list!.length,
                              controller: controller,
                              itemBuilder: (_, index) => NotificationListItem(
                                  state.list![index], onTap: () {
                                Alert.message(
                                  context,
                                  title: state.list![index].label,
                                  message: state.list![index].content,
                                );
                                app.Notification.updateSeen(
                                        state.list![index].id)
                                    .then((value) {
                                  var not = state.list![index];
                                  not.read = true;
                                  BlocProvider.of<NotificationsListCubit>(
                                          context)
                                      .updateItem(index, not);
                                }).catchError((err) {
                                  debugPrint(
                                      'Unable to update notification $err');
                                });
                              },
                                  trailing: MorePopup(
                                    options: ['Read', 'Delete'],
                                    onAction: (i) {
                                      switch (i) {
                                        case 0:
                                          app.Notification.updateSeen(
                                                  state.list![index].id)
                                              .then((value) {
                                            var not = state.list![index];
                                            not.read = true;
                                            BlocProvider.of<
                                                        NotificationsListCubit>(
                                                    context)
                                                .updateItem(index, not);
                                          }).catchError((err) {
                                            debugPrint(
                                                'Unable to update notification $err');
                                          });
                                          break;
                                        case 1:
                                          app.Notification.deleteNotification(
                                                  state.list![index].id)
                                              .then((value) {
                                            BlocProvider.of<
                                                        NotificationsListCubit>(
                                                    context)
                                                .updateItem(index, null);
                                          }).catchError((err) {
                                            debugPrint(
                                                'Unable to delete notification $err');
                                            Alert.toast(context,
                                                message: err.toString());
                                          });
                                          break;
                                      }
                                    },
                                  )),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
