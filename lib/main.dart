import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/home/home.dart';
import 'package:shevarms_user/onboarding/onboarding.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

void main() async {
  await AppConfig.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (ctx) => AppCubit(AppState(
              isLoggedIn: false,
              user: null,
              isFirstTimeLoad: AppSettings().isFirstTimeLoad)),
        ),
        BlocProvider<SettingsCubit>(
          create: (ctx) => SettingsCubit(),
        ),
        BlocProvider<DashboardControlCubit>(
          create: (ctx) => DashboardControlCubit(
              DashboardControlState(state: DashboardTvState.offline)),
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            color: AppColors.primaryColor,
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              LoginPage.routeKey: (context) => const LoginPage(),
              GetStartedScreen.routeKey: (context) => const GetStartedScreen(),
            },
            theme: ThemeData(
              primaryColor: AppColors.primaryColor,
            ),
            home: SplashScreenView(
              navigateWhere: true,
              backgroundColor: Colors.white,
              navigateRoute: ((state.isFirstTimeLoad ?? false)
                  ? const AppIntroductionScreen()
                  : (state.isLoggedIn ?? false)
                      ? const HomePage()
                      : const LoginPage(showBack: false)),
              text: WavyAnimatedText(
                "VMS",
                textStyle: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              imageSrc: AssetConstants.logoBig,
            ),
          );
        },
      ),
    );
  }
}
