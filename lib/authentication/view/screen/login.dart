import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/authentication/view/screen/server_settings_screen.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/home/view/screen/home_page.dart';
import 'package:shevarms_user/shared/shared.dart';

import '../../../tutorial-videos/tutorial-videos.dart';

class LoginPage extends StatefulWidget {
  static const String routeKey = "login";
  final bool showBack;
  const LoginPage({this.showBack = true, Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController email = TextEditingController.fromValue(
      TextEditingValue(text: AppStorage().userEmail ?? ""));
  TextEditingController password =
      TextEditingController.fromValue(const TextEditingValue(text: ""));

  bool loading = false;
  String stat = "";
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(LoginState(loading: false)),
      child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
        return BaseScaffold(
          appBarBackgroundColor: Colors.white,
          textAndIconColors: Colors.black,
          showBack: widget.showBack,
          noGradient: true,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height - 50,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardAssetImage(
                      imageString: AssetConstants.logoBig,
                      size: const Size(120, 120),
                      borderColor: Colors.grey.shade200,
                      radius: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "LOG",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey),
                      ),
                      TextSpan(
                        text: "IN",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor),
                      ),
                    ])),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Welcome back, please enter your details to login",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 20),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Email address",
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Password",
                      controller: password,
                      hidePassword: true,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 25,
                      child: Text(
                        state.error ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: AppTextButton(
                        buttonColor: AppColors.primaryColor,
                        textColor: Colors.white,
                        loading: state.loading ?? false,
                        width: MediaQuery.of(context).size.width - 100,
                        label: "CONTINUE",
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          context
                              .read<LoginCubit>()
                              .signIn(email.text, password.text, (User user) {
                            BlocProvider.of<DashboardControlCubit>(context)
                                .updateUserDashboards(
                                    user.dashboards ?? <String>[]);
                            BlocProvider.of<AppCubit>(context)
                                .updateUserData(user);
                            BlocProvider.of<AppCubit>(context)
                                .updateLoginStatus(true);
                            BlocProvider.of<AppCubit>(context)
                                .toggleFirstTimeLoad(false);
                            NavUtils.navToReplace(context, const HomePage());
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            NavUtils.navTo(context, const ServerSettingsPage());
                          },
                          child: Text(
                            "Settings",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot password?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        NavUtils.navTo(context, VideosListScreen());
                      },
                      child: Text(
                        "Video Tutorials",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
