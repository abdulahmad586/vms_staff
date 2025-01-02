import 'package:shevarms_user/tutorial-videos/tutorial-videos.dart';

class Videos {
  static const List<TutorialVideoModel> tutorialVideos = [
    // TutorialVideoModel(
    //   id: "v-1",
    //   title: "User onboarding",
    //   description:
    //       "Different categories of users and how they are registered on the platform",
    //   videoAssetPath: VideoAssetConstants.userOnboarding,
    // ),
    TutorialVideoModel(
      id: "v-2",
      title: "Login and App Overview",
      description:
          "How to login with your credentials, then we glance through different sections of the app",
      videoAssetPath: VideoAssetConstants.loginAndOverview,
    ),
    TutorialVideoModel(
      id: "v-3",
      title: "App Notifications",
      description: "Access in-app notifications",
      videoAssetPath: VideoAssetConstants.appNotifications,
    ),
    TutorialVideoModel(
      id: "v-4",
      title: "Appointments",
      description: "Viewing and creating appointments",
      videoAssetPath: VideoAssetConstants.appointments,
    ),
    TutorialVideoModel(
      id: "v-5",
      title: "Reminders",
      description: "Viewing and creating reminders",
      videoAssetPath: VideoAssetConstants.reminders,
    ),
  ];
}
