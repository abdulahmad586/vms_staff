import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/onboarding/view/view.dart';
import 'package:shevarms_user/shared/shared.dart';

class AppIntroductionScreen extends StatelessWidget{
  const AppIntroductionScreen({super.key});


  @override
  Widget build(BuildContext context) {

    List<PageViewModel> listPagesViewModel = [
      PageViewModel(
        title: "VMS - User",
        body: "State House Electronic Visitors Attendance Register Management System\n\nYour key to a seamless and empowered visiting experience within our government hub!",
        image: Center(
          child: Image.asset(AssetConstants.logoBig, height: 150.0),
        ),
        decoration: PageDecoration(
          titleTextStyle: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700, fontSize:20),
          bodyTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color:Colors.grey[700], fontSize: 15) ?? const TextStyle(),
        ),
      ),
      PageViewModel(
        title: "Effortless Appointment Mastery",
        body: "Say goodbye to appointment chaos! With VMS, booking meetings with the governor or any state office is as easy as a tap on your screen. Need to reschedule? No problem! Cancel? Done in seconds! You're in control",
        image: Center(
          child: SvgPicture.asset(AssetConstants.appointmentIllustration, height: 150.0),
        ),
        decoration: PageDecoration(
          titleTextStyle: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700, fontSize:20),
          bodyTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700], fontSize: 15) ?? const TextStyle(),
        ),
      ),
      PageViewModel(
        title: "Exclusive Access, Tailored for You",
        body: "Get ready for VIP treatment! Your unique ID and access code open the doors to specific areas based on your meetings and clearance level. Navigate with ease, knowing you have access where it matters",
        image: Center(
          child: SvgPicture.asset(AssetConstants.securityOnIllustration, height: 150.0),
        ),
        decoration: PageDecoration(
          titleTextStyle: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700, fontSize:20),
          bodyTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color:Colors.grey[700], fontSize: 15) ?? const TextStyle(),
        ),
      ),
      PageViewModel(
        title: "Ready to Begin?",
        body: "let's get you enrolled into the platform!",
        image: Center(
          child: Image.asset(AssetConstants.logoBig, height: 120.0),
        ),
        decoration: PageDecoration(
          titleTextStyle: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700, fontSize:20),
          bodyTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700], fontSize: 15) ?? const TextStyle(),
        ),
        footer: Column(
          children: [
            AppTextButton(
              width: 200,
              onPressed: () {
                NavUtils.navToReplaceNamed(context, GetStartedScreen.routeKey);
              },
              label: "Get started!",
              buttonColor: AppColors.primaryColor,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    ];

    return BaseScaffold(
      assetBackgroundImage: AssetConstants.hexBackground,
      backgroundImageAlignment: Alignment.center,
      backgroundImageOpacity: 1.0,
      body: IntroductionScreen(
        pages: listPagesViewModel,
        showSkipButton: true,
        globalBackgroundColor: Colors.transparent,
        skip: const Text("Skip"),
        next: const Text("Next"),
        done: const Text("Done"),
        onDone: () {
          NavUtils.navToReplaceNamed(context, GetStartedScreen.routeKey);
        },
        onSkip: (){
          NavUtils.navToReplaceNamed(context, GetStartedScreen.routeKey);
        },
        baseBtnStyle: TextButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
        ),
        skipStyle: TextButton.styleFrom(foregroundColor: Colors.black),
        doneStyle: TextButton.styleFrom(foregroundColor: Colors.green),
        nextStyle: TextButton.styleFrom(foregroundColor: AppColors.primaryColor, backgroundColor: AppColors.primaryColor),
      ),
    );
  }

}