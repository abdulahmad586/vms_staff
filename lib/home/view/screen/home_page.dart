import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shevarms_user/account_info/view/screen/settings_screen.dart';
import 'package:shevarms_user/appointments/appointments.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/card_registration/card_registration.dart';
import 'package:shevarms_user/dashboard/dashboard.dart';
import 'package:shevarms_user/dashboard_control/dashboard_control.dart';
import 'package:shevarms_user/notifications/notifications.dart';
import 'package:shevarms_user/reminder/reminder.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/sip_communication/sip_communication.dart';
import 'package:shevarms_user/tags_assignment/tags_assignment.dart';
import 'package:shevarms_user/video_conference/video_conference.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "home";
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserType userType = UserType.staff;

  static List<UserType> staffLike = [
    UserType.seniorStaff,
    UserType.staff,
    UserType.paGovernor,
    UserType.pps,
    UserType.firstLady,
    UserType.paFirstLady,
    UserType.COS,
    UserType.DCOS,
    UserType.he,
  ];

  List<NavItem> navItems = [
    NavItem(
        icon: Icons.dashboard,
        name: 'Dashboard',
        title: 'Dashboard',
        body: Dashboard(),
        allowedUsers: [
          ...staffLike,
          UserType.seniorStaff,
          UserType.he,
          UserType.staff,
          UserType.admin,
          UserType.superUser,
          UserType.paGovernor,
          UserType.chiefDetail,
          UserType.deptAdmin,
        ]),
    NavItem(
        icon: Icons.calendar_month,
        name: 'Appointments',
        title: 'Appointments',
        body: AppointmentsScreen(),
        allowedUsers: [
          ...staffLike,
          UserType.he,
          UserType.seniorStaff,
          UserType.staff,
          UserType.admin,
          UserType.superUser,
          UserType.paGovernor,
          UserType.chiefDetail,
          UserType.deptAdmin,
        ]),
    NavItem(
        icon: Icons.alarm,
        name: 'Reminders',
        title: 'Reminders',
        body: RemindersScreen(),
        allowedUsers: [
          ...staffLike,
          UserType.he,
          UserType.seniorStaff,
          UserType.staff,
          UserType.admin,
          UserType.superUser,
          UserType.paGovernor,
          UserType.chiefDetail,
        ]),
    NavItem(
        icon: Icons.credit_card,
        name: 'Card Registration',
        title: 'Card Registration',
        body: CardRegistrationHome(),
        allowedUsers: [UserType.admin]),
    NavItem(
        icon: Icons.credit_card_outlined,
        name: 'Card Generation',
        title: 'Card Generation',
        body: TagsAssignment(),
        allowedUsers: [
          UserType.admin,
        ]),
    // NavItem(
    //     icon: Icons.meeting_room_outlined,
    //     name: 'Waiting Rooms',
    //     title: 'Waiting Rooms',
    //     body: WaitingRoomListScreen(),
    //     allowedUsers: [
    //       UserType.seniorStaff,
    //       UserType.admin,
    //       UserType.superUser,
    //     ]),
    NavItem(
        icon: Icons.control_camera_sharp,
        name: 'Dashboard Control',
        title: 'Dashboard Control',
        body: DashboardTVsListScreen() /*DashboardControlScreen()*/,
        allowedUsers: [
          ...staffLike,
          UserType.seniorStaff,
          UserType.he,
          UserType.admin,
          UserType.paGovernor,
          UserType.chiefDetail,
        ]),
    NavItem(
        icon: Icons.notifications,
        name: 'Notifications',
        title: 'Notifications',
        body: NotificationsPage(),
        allowedUsers: [
          ...staffLike,
          UserType.he,
          UserType.seniorStaff,
          UserType.staff,
          UserType.admin,
          UserType.superUser,
          UserType.paGovernor,
          UserType.chiefDetail,
          UserType.deptAdmin,
        ]),
    NavItem(
        icon: Icons.video_camera_back,
        name: 'Meetings',
        title: 'Meetings',
        body: VideoConferenceScreen(),
        allowedUsers: [
          ...staffLike,
          UserType.staff,
          UserType.seniorStaff,
          UserType.he
        ]),
    NavItem(
        icon: Icons.call,
        name: 'Phone Sys',
        title: 'Phone Sys',
        body: DialPadWidget(),
        allowedUsers: [
          ...staffLike,
          UserType.staff,
          UserType.seniorStaff,
          UserType.he,
          UserType.paGovernor,
          UserType.chiefDetail,
        ]),
  ];

  late KFDrawerController _drawerController;
  final String _appName = dotenv.env['app_name'] as String;
  final String _appFullName = (dotenv.env['full_name'] as String);
  @override
  void initState() {
    userType =
        BlocProvider.of<AppCubit>(context).user?.userType ?? UserType.staff;
    setupSideNav();
    context.read<DashboardControlCubit>();
    super.initState();
  }

  void setupSideNav() {
    navItems = navItems
        .where((element) => element.allowedUsers.contains(userType))
        .toList();
    _drawerController = KFDrawerController(
      initialPage: Dashboard(),
      items: List.generate(navItems.length, (index) {
        KFDrawerContent page = navItems[index].body;

        return KFDrawerItem.initWithPage(
          text: Text(navItems[index].name,
              style: const TextStyle(fontFamily: 'Iceberg')),
          icon: Icon(
            navItems[index].icon,
          ),
          page: page,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool popped) {
        // if (popped) return;
        // if (Navigator.of(context).canPop()) {
        //   Navigator.of(context).pop();
        // } else {
        //   FlutterAppMinimizer.minimize();
        // }
        if (_drawerController.page.toString() != navItems.first.name) {
          _drawerController.items.first.onPressed?.call();
        }
      },
      child: Scaffold(
        body: KFDrawer(
          controller: _drawerController,
          header: Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                width: MediaQuery.of(context).size.width * 0.63,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: Image.asset(
                        AssetConstants.logoBig,
                        height: 100,
                        width: 100,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _appName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryColor,
                          fontFamily: 'Iceberg',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Shimmer.fromColors(
                      baseColor: AppColors.primaryColor,
                      highlightColor: Colors.black,
                      enabled: false,
                      child: Row(
                        children: [
                          Text(
                            _appFullName,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: null,
                                    fontFamily: 'Iceberg',
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          footer: Column(
            children: [
              KFDrawerItem(
                text: Text('Settings',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Iceberg')),
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  NavUtils.navTo(context, SettingsScreen());
                },
              ),
              KFDrawerItem(
                text: Text('Logout',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Iceberg')),
                icon: Icon(Icons.logout, color: Theme.of(context).primaryColor),
                onPressed: () {
                  NavUtils.navToReplace(context, const LoginPage());
                  Future.delayed(const Duration(milliseconds: 500), () {
                    BlocProvider.of<AppCubit>(context).logoutUser(context);
                  });
                },
              )
            ],
          ),
          decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: Image.asset(
            //       'assets/images/icon_big.png',
            //       height: 120,
            //       width: 120,
            //       alignment: Alignment.centerLeft,
            //     ).image,
            //     alignment: Alignment.bottomLeft,
            //     opacity: 0.2),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.4, 1.0],
              colors: [
                const Color.fromRGBO(255, 255, 255, 1.0),
                const Color.fromRGBO(255, 255, 255, 1.0),
                AppColors.primaryColor.withOpacity(0.3)
              ],
              // colors: [Color.fromRGBO(255, 255, 255, 1.0), Color.fromRGBO(44, 72, 171, 1.0)],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  String name, title;
  KFDrawerContent body;
  IconData icon;
  List<UserType> allowedUsers;
  NavItem(
      {required this.name,
      required this.title,
      required this.icon,
      required this.body,
      required this.allowedUsers});
}
