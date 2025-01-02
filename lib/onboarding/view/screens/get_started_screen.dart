import 'package:flutter/material.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/shared/shared.dart';

class GetStartedScreen extends StatefulWidget {
  static const String routeKey = "get-started";
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {

  @override
  void initState() {
    super.initState();
  }

  String message = "Welcome to VMS  Your onboarding process to this app starts after you have been profiled by a security personnel.";

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              AssetConstants.logoBig,
              height: 120,
              width: 120,
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(text: TextSpan(children: [
              TextSpan(text: "GET ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.darkGrey),),
              TextSpan(text: "STARTED", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryColor),),
            ])),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey)),
            ),
            const Spacer(),

            AppTextButton(
              buttonColor: AppColors.primaryColor,
              textColor: Colors.white,
              loading: false,
              width: MediaQuery.of(context).size.width-90,
              label: "LOGIN",
              onPressed: (){
                NavUtils.navTo(context, const LoginPage());
              },
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
