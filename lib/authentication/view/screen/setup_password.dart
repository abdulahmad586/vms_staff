import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/shared/shared.dart';

class SetupPassword extends StatelessWidget {
  final User user;
  const SetupPassword({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormState> formKey = GlobalKey();
    final TextEditingController pass = TextEditingController();

    return BlocProvider(
      create: (_)=>SetupPasswordCubit(SetupPasswordState()),
      child: BlocBuilder<SetupPasswordCubit, SetupPasswordState>(
        builder: (context, state) {
          return BaseScaffold(
              appBarBackgroundColor: Colors.grey[100],
              textAndIconColors: Colors.black,
              showBack: true,
              body:Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          AssetConstants.logoBig,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "SETUP ",
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGrey),
                              ),
                              TextSpan(
                                text: "PASSWORD",
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor),
                              ),
                            ])),
                        const SizedBox(
                          height: 30,
                        ),
                        Text("Complete your profile by setting up your login password",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 40),
                        AppTextField(
                          validator: (text) => text==null || text.isEmpty ? "Field is required":null,
                          labelText: "Password",
                          controller: pass,
                          hidePassword: true,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          validator:(text) => text==null || text.isEmpty ? "Field is required": ( text != pass.text ? "Password mismatch": null),
                          labelText: "Confirm Password",
                          hidePassword: true,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 35,
                          child: Text(state.error??"", maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: AppTextButton(
                            buttonColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            loading: state.loading??false,
                            width: 280,
                            label: "CONTINUE",
                            onPressed: () {
                              if(!formKey.currentState!.validate()) return;
                              String password  = pass.text;

                              context.read<SetupPasswordCubit>().registerUser(user, password, () {
                                NavUtils.navToReplace(context, SuccessPage( message: "Congratulations! your account has been setup\n\nYou will be able to login now!", onContinue: (context){
                                  NavUtils.navToReplace(context, const LoginPage());
                                },));
                              });

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          );
        }
      ),
    );
  }
}
