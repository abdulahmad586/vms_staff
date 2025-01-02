import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/authentication/view/screen/user_profile_screen.dart';
import 'package:shevarms_user/shared/shared.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('SETTINGS',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "${state.user?.firstName}, ".capitalize(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                            TextSpan(
                              text: state.user?.lastName.capitalize(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[600]),
                            ),
                          ])),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Account Information",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),
                  Card(
                      surfaceTintColor: Colors.white,
                      elevation: 0.5,
                      child: GenericListItem(
                        verticalPadding: 15,
                        leading: const AppIconButton(
                          height: 35,
                          width: 35,
                          borderColor: AppColors.primaryColor,
                          iconColor: AppColors.primaryColor,
                          icon: Icons.person,
                        ),
                        label: "Personal information",
                        desc: "View your personal information",
                        onPressed: editPersonalInfo,
                      )),
                  // Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: AppColors.primaryColor, iconColor: AppColors.primaryColor, icon: Icons.account_balance,), label: "View your personal information", desc:"Link your bank accounts to your wallet", onPressed: manageBankAccounts,)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Security",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),
                  // Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: AppColors.primaryColor, iconColor: AppColors.primaryColor, icon: Icons.pin,), label: "Transaction PIN", desc:"Change app transaction PIN", onPressed: changeTransactionPIN,)),
                  Card(
                      surfaceTintColor: Colors.white,
                      elevation: 0.5,
                      child: GenericListItem(
                        verticalPadding: 15,
                        leading: const AppIconButton(
                          height: 35,
                          width: 35,
                          borderColor: AppColors.primaryColor,
                          iconColor: AppColors.primaryColor,
                          icon: Icons.password,
                        ),
                        label: "Account password",
                        desc: "Change your account password",
                        onPressed: changeAccountPassword,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Legal",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),
                  Card(
                      surfaceTintColor: Colors.white,
                      elevation: 0.5,
                      child: GenericListItem(
                        verticalPadding: 15,
                        leading: const AppIconButton(
                            height: 35,
                            width: 35,
                            borderColor: AppColors.primaryColor,
                            iconColor: AppColors.primaryColor,
                            icon: Icons.warning_amber),
                        label: "Terms and conditions",
                        desc: "Read our terms and conditions",
                        onPressed: termsAndConditions,
                      )),
                  Card(
                      surfaceTintColor: Colors.white,
                      elevation: 0.5,
                      child: GenericListItem(
                        verticalPadding: 15,
                        leading: const AppIconButton(
                          height: 35,
                          width: 35,
                          borderColor: AppColors.primaryColor,
                          iconColor: AppColors.primaryColor,
                          icon: Icons.privacy_tip_outlined,
                        ),
                        label: "Privacy policy",
                        desc: "Read our data policy",
                        onPressed: privacyPolicy,
                      )),
                  Card(
                      surfaceTintColor: Colors.white,
                      elevation: 0.5,
                      child: GenericListItem(
                        verticalPadding: 15,
                        leading: const AppIconButton(
                          height: 35,
                          width: 35,
                          borderColor: AppColors.primaryColor,
                          iconColor: AppColors.primaryColor,
                          icon: Icons.contact_support_outlined,
                        ),
                        label: "Contact us",
                        desc: "Got any complaints, issues, or suggestions?",
                        onPressed: contactUs,
                      )),
                  const SizedBox(height: 30),
                  AppTextButton(
                    label: "Delete Account",
                    textColor: Colors.red,
                    onPressed: deleteAccount,
                  ),
                  const SizedBox(height: 40),
                ],
              )),
        ));
  }

  void editPersonalInfo() {
    NavUtils.navTo(context, const UserProfileScreen());
  }

  void changeAccountPassword() {
    NavUtils.navTo(context, const ChangePassword());
  }

  void termsAndConditions() {}

  void privacyPolicy() {}

  void contactUs() {}

  void deleteAccount() {
    // NavUtils.navTo(context, const DeleteAccount());
  }
}
