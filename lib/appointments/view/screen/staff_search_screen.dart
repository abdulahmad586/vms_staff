import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/appointments/service/appointment_service.dart';
import 'package:shevarms_user/shared/shared.dart';

import '../widget/user_list_item.dart';

class StaffSearchScreen extends StatefulWidget {
  const StaffSearchScreen({super.key});

  @override
  State<StaffSearchScreen> createState() => _StaffSearchScreenState();
}

class _StaffSearchScreenState extends State<StaffSearchScreen> {
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: AppIconButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    icon: Icons.clear,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    // child: Hero(
                    //   tag: 'phoneSearch',
                    child: AppTextField(
                      itemsColor: AppColors.primaryColor,
                      keyboardType: TextInputType.phone,
                      autoFocus: true,
                      onChange: (s) {
                        if (s.length > 4) {
                          debouncer(
                              const Duration(milliseconds: 250),
                              () => searchUsers(s,
                                  deptAdminLocation:
                                      context.read<AppCubit>().user?.location));
                        } else {
                          setState(() {
                            users = [];
                          });
                        }
                      },
                      hintText: "Phone number",
                      widthPercentage: double.infinity,
                    ),
                  ),
                  // ),
                ),
              ],
            ),
            Expanded(
              child: users.isEmpty
                  ? EmptyResult(
                      message: "No records found",
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return UserListItem(users[index],
                                showPhone: true,
                                onTap: () =>
                                    Navigator.pop(context, users[index]));
                          }),
                    ),
            ),
          ],
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

  searchUsers(String s, {String? deptAdminLocation}) async {
    try {
      final results = await AppointmentService()
          .searchUsersByPhone(s, deptAdminLocation: deptAdminLocation);
      setState(() {
        users = results;
      });
    } catch (e) {}
  }
}
