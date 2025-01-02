import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/tags_assignment/tags_assignment.dart';
import 'package:shevarms_user/tags_assignment/view/screen/assign_tag_screen.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class TagsAssignment extends KFDrawerContent {
  @override
  State<TagsAssignment> createState() => _TagsAssignmentState();
}

class _TagsAssignmentState extends State<TagsAssignment> {
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
        title: Text('CARDS MANAGEMENT',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor, fontFamily: 'Iceberg')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.new_label),
        onPressed: () {
          NavUtils.navTo(context, const VisitorSearchScreen(),
              onReturn: (visitor) {
            if (visitor != null) {
              NavUtils.navTo(
                  context, AssignTagScreen(visitor: visitor as VisitorModel),
                  onReturn: (_) {
                refreshController.requestRefresh();
              });
            }
          });
        },
      ),
      body: BlocProvider<TagsListCubit>(
        create: (context) => TagsListCubit(TagsListState(),
            refreshController: refreshController),
        child: BlocBuilder<TagsListCubit, TagsListState>(
          builder: (context, state) {
            ScrollController controller = ScrollController();
            controller.addListener(() {
              if (controller.offset >= controller.position.maxScrollExtent) {
                debouncer(const Duration(milliseconds: 500),
                    () => BlocProvider.of<TagsListCubit>(context).nextPage());
              }

              if (controller.offset <= controller.position.minScrollExtent &&
                  !controller.position.outOfRange) {}
            });

            return SmartRefresher(
              enablePullDown: true,
              controller: refreshController,
              onRefresh: () {
                BlocProvider.of<TagsListCubit>(context).getData(refresh: true);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StatWidget(
                          icon: Icons.assignment_ind_outlined,
                          showShadow: false,
                          onClick: () {
                            // NavUtils.navTo(context, AppointmentLoggerScreen());
                          },
                          display: "0",
                          backgroundColor:
                              AppColors.secondaryColor.withOpacity(0.5),
                          iconBackgroundColor: AppColors.secondaryColor,
                          label: "Assigned",
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                        ),
                        StatWidget(
                          icon: Icons.assignment_late_outlined,
                          showShadow: false,
                          iconBackgroundColor: Colors.grey[600],
                          onClick: () {
                            // NavUtils.navTo(context, AppointmentCheckoutScreen());
                          },
                          label: "Unassigned",
                          display: "0",
                          backgroundColor: Colors.grey[300],
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                        ),
                        // StatWidget(icon: Icons.location_history, showShadow: false, iconBackgroundColor:Colors.yellow, onClick: (){
                        //   NavUtils.navTo(context, const AppointmentCheckpointScreen());
                        // }, label: "Check-point", backgroundColor: Colors.yellow.withOpacity(0.5), width: (MediaQuery.of(context).size.width/3)-20, iconColor:Colors.grey[600],),
                      ],
                    ),
                    // const SizedBox(height: 5,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     _buildVisitorCard(VisitorModel(id: 'id', firstName: '', lastName: '', phone: '', userType: VisitorType.vip), Random().nextInt(10)),
                    //     _buildVisitorCard(VisitorModel(id: 'id', firstName: '', lastName: '', phone: '', userType: VisitorType.vvip), Random().nextInt(10)),
                    //     _buildVisitorCard(VisitorModel(id: 'id', firstName: '', lastName: '', phone: '', userType: VisitorType.vvvip), Random().nextInt(10)),
                    //
                    //   ],
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Manage your cards"),
                        TextPopup(
                            list: const ["ALL", "VIP", "VVIP", "VVVIP"],
                            active: state.view ?? 0,
                            onSelected: (int i) {
                              BlocProvider.of<TagsListCubit>(context)
                                  .updateView(i);
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                                  message: "No cards found",
                                  loading: state.loading ?? false,
                                ))
                          : ListView.builder(
                              itemCount: state.results!.length,
                              controller: controller,
                              itemBuilder: (_, index) => TagListItem(
                                tag: state.results![index],
                                trailing: MorePopup(
                                  options: const ['Revoke access', 'Delete'],
                                  onAction: (int i) {
                                    switch (i) {
                                      case 0:
                                        // NavUtils.navTo(
                                        //     context, RegisterPage(state.list![index]), onReturn: (){
                                        //   refreshController.requestRefresh();
                                        // });
                                        break;
                                      case 1:
                                        Alert.caution(context,
                                            title: 'Delete Card?',
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

  _buildVisitorCard(VisitorModel model, int value) {
    return Container(
      height: 75,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[200]),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: model.getColor(),
              ),
              child: Text(
                "VIP ${model.getVisitorLabel()}",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              )),
          Expanded(
              child: Center(
                  child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ))),
        ],
      ),
    );
  }
}
