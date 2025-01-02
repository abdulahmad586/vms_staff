import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/shared/shared.dart';

class NewDashboardTVScreen extends StatelessWidget {
  const NewDashboardTVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();

    return BlocProvider(
      create: (_) => NewDashboardTVCubit(NewDashboardTVState()),
      child: BlocBuilder<NewDashboardTVCubit, NewDashboardTVState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  const Card(
                      child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.desktop_mac_rounded,
                      size: 70,
                    ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create My Dashboard",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Expanded(child: SizedBox()),
                  AppTextField(
                    labelText: "Dashboard Name",
                    hintText: "Enter dashboard name",
                    hidePassword: true,
                    onChange: (s) =>
                        context.read<NewDashboardTVCubit>().updateName(s),
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AppTextField(
                    labelText: "Location",
                    hintText: "Enter dashboard location",
                    onChange: (s) =>
                        context.read<NewDashboardTVCubit>().updateLocation(s),
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppTextField(
                    labelText: "Username",
                    hintText: "Enter username",
                    onChange: (s) =>
                        context.read<NewDashboardTVCubit>().updateUsername(s),
                    hidePassword: true,
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppTextField(
                    labelText: "Password",
                    hintText: "Enter dashboard password",
                    onChange: (s) =>
                        context.read<NewDashboardTVCubit>().updatePassword(s),
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    state.error ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextButton(
                    label: "CREATE DASHBOARD",
                    width: MediaQuery.of(context).size.width - 100,
                    buttonColor: AppColors.primaryColor,
                    textColor: Colors.white,
                    loading: state.loading ?? false,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      try {
                        await context
                            .read<NewDashboardTVCubit>()
                            .createDashboard((newTv) {
                          Alert.toast(context,
                              message: "Dashboard created successfully!");
                          Navigator.pop(context, newTv);
                        });
                      } catch (e) {
                        if (context.mounted) {
                          Alert.toast(context, message: e.toString());
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
