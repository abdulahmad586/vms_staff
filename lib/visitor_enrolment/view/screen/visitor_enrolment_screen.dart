import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class VisitorEnrollment extends KFDrawerContent {
  @override
  State<VisitorEnrollment> createState() => _VisitorEnrollmentState();
}

class _VisitorEnrollmentState extends State<VisitorEnrollment> {
  RefreshController refreshController = RefreshController();

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
        title: Text('VISITORS MANAGEMENT',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        actions: [
          CustomIconButton(Icons.search, onPressed: () {
            // NavUtils.navTo(context, const VisitorSearchScreen(), onReturn: (visitor){
            //   if(visitor !=null){
            //     NavUtils.navTo(context, EnrolVisitorScreen(visitor: visitor as VisitorModel,));
            //   }
            // });
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavUtils.navTo(context, const EnrolVisitorScreen(),
              onReturn: (result) {
            if (result != null) {
              refreshController.requestRefresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: BlocProvider<VisitorsListCubit>(
        create: (context) => VisitorsListCubit(VisitorsListState(),
            refreshController: refreshController),
        child: BlocBuilder<VisitorsListCubit, VisitorsListState>(
          builder: (context, state) {
            ScrollController controller = ScrollController();
            controller.addListener(() {
              if (controller.offset >= controller.position.maxScrollExtent) {
                debouncer(
                    const Duration(milliseconds: 500),
                    () =>
                        BlocProvider.of<VisitorsListCubit>(context).nextPage());
              }

              if (controller.offset <= controller.position.minScrollExtent &&
                  !controller.position.outOfRange) {}
            });

            return SmartRefresher(
              enablePullDown: true,
              controller: refreshController,
              onRefresh: () {
                BlocProvider.of<VisitorsListCubit>(context)
                    .getData(refresh: true);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Enrol new users into the system',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    // AppTabHeader(tabsList: const ['Normal users', 'Admins'], selectedTab: _tab, onTabChange: (int t)=> _tab = t,),
                    Expanded(
                      child: state.results == null || state.results!.isEmpty
                          ? (state.error != null
                              ? ErrorPage(
                                  message: state.error!,
                                  onContinue: () {
                                    Navigator.pop(context);
                                  },
                                )
                              : EmptyResult(
                                  message: "No users found",
                                  loading: state.loading ?? false,
                                ))
                          : ListView.builder(
                              itemCount: state.results!.length,
                              controller: controller,
                              itemBuilder: (_, index) => VisitorListItem(
                                state.results![index],
                                trailing: MorePopup(
                                  options: const ['Edit', 'Delete'],
                                  onAction: (int i) {
                                    switch (i) {
                                      case 0:
                                        NavUtils.navTo(
                                            context,
                                            EnrolVisitorScreen(
                                                visitor: state.results![index]),
                                            onReturn: (res) {
                                          refreshController.requestRefresh();
                                        });
                                        break;
                                      case 1:
                                        Alert.caution(context,
                                            title: 'Delete User?',
                                            message:
                                                "This action is not reversible, tap to proceed",
                                            onProceed: () {
                                          // User.deleteUser(state.list![index].id)
                                          //     .then((value) {
                                          //   if (value) {
                                          //     Alert.toast(context,
                                          //         message: "Deleted successfully");
                                          //   }
                                          //   refreshController.requestRefresh();
                                          // }).catchError((err) {
                                          //   Alert.toast(context,
                                          //       message: "Unable to delete user");
                                          //   print("Error deleting user $err");
                                          // });
                                        });
                                        break;
                                    }
                                  },
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
