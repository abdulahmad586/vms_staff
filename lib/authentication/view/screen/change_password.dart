import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/authentication/state/state.dart';
import 'package:shevarms_user/shared/shared.dart';

class ChangePassword extends StatelessWidget {
  final String resetCode;
  const ChangePassword({super.key, this.resetCode = ""});

  @override
  Widget build(BuildContext context) {
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey();

    return BlocProvider(
      create: (_) => ChangePasswordCubit(ChangePasswordState()),
      child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Card(
                          child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.lock,
                          size: 70,
                        ),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Change Password",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (resetCode.isEmpty)
                        AppTextField(
                          labelText: "Old password",
                          hintText: "Enter your old password",
                          controller: oldPassword,
                          hidePassword: true,
                          validator: (s) {
                            if (s == null || s.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                      SizedBox(
                        height: resetCode.isNotEmpty ? 0 : 15,
                      ),
                      AppTextField(
                        labelText: "New password",
                        hintText: "Enter new password",
                        controller: newPassword,
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
                        labelText: "Confirm password",
                        hintText: "Confirm new password",
                        controller: confirmPassword,
                        hidePassword: true,
                        validator: (s) {
                          if (s == null || s.isEmpty || newPassword.text != s) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        state.error ?? "",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextButton(
                        label: "CHANGE PASSWORD",
                        width: MediaQuery.of(context).size.width - 100,
                        buttonColor: AppColors.primaryColor,
                        textColor: Colors.white,
                        loading: state.loading ?? false,
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          context.read<ChangePasswordCubit>().changePassword(
                              context.read<AppCubit>().user!.id,
                              oldPassword.text,
                              newPassword.text, () {
                            Alert.message(context,
                                message: "Password changed successfully",
                                title: "Success!",
                                error: false, close: () {
                              Navigator.pop(context);
                            });
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
