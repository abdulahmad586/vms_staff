import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shevarms_user/authentication/authentication.dart';
import 'package:shevarms_user/shared/shared.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.of(context).size.width > 450;

    return Scaffold(
        appBar: AppBar(
          title: Text('My Profile',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor, fontFamily: 'Iceberg')),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
            final user = state.user!;
            return Column(
              children: [
                _buildNameAndPicture(context, user),
                if (isBigScreen)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPersonalInformation(context, user)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(child: _buildWorkInformation(context, user)),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPersonalInformation(context, user),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildWorkInformation(context, user),
                    ],
                  )
              ],
            );
          }),
        ));
  }

  Widget _buildNameAndPicture(BuildContext context, User user) {
    ValueNotifier<bool> uploadingImage = ValueNotifier(false);

    return Column(
      children: [
        SizedBox(
          child: user.picture.isEmpty
              ? const CardAssetImage(
                  imageString: "assets/images/image_not_found.png",
                  size: Size(150, 150),
                  radius: 100,
                  borderColor: AppColors.primaryColor,
                  showBorder: true,
                )
              : (user.picture.startsWith("http")
                  ? CardImage(
                      imageString: user.picture,
                      size: const Size(150, 150),
                      radius: 100,
                      borderColor: AppColors.primaryColor,
                      showBorder: true,
                    )
                  : CardFileImage(
                      imageString: user.picture,
                      size: const Size(150, 150),
                      radius: 100,
                      borderColor: AppColors.primaryColor,
                      showBorder: true,
                    )),
        ),
        const SizedBox(height: 10),
        Text("${user.fullName ?? "No name"} (${user.userType.name})",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'Iceberg',
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  if (uploadingImage.value) {
                    return;
                  }
                  void pickImage(ImageSource source) async {
                    Navigator.pop(context);
                    try {
                      uploadingImage.value = true;
                      final image =
                          await ImagePickerUtil.pickImage(source: source);
                      if (image != null) {
                        final newPicture = await AuthService().changePicture(
                            userId: user.id, imagePath: image.path);
                        if (context.mounted) {
                          context.read<AppCubit>().updateUserData(
                              user.copyWith(picture: newPicture));
                        }
                      }
                      uploadingImage.value = false;
                    } catch (e) {
                      uploadingImage.value = false;
                      if (context.mounted) {
                        Alert.toast(context, message: e.toString());
                      }
                    }
                  }

                  Alert.showAppDialog(
                      context,
                      "Choose Source",
                      SizedBox(
                        height: 100,
                        width: 300,
                        child: ListView(
                          shrinkWrap: false,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              title: const Text("Camera"),
                              leading: const Icon(Icons.camera_alt),
                              onTap: () => pickImage(ImageSource.camera),
                            ),
                            ListTile(
                              title: const Text("Gallery"),
                              leading: const Icon(Icons.insert_photo_sharp),
                              onTap: () => pickImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                      ));
                },
                child: ValueListenableBuilder<bool>(
                    valueListenable: uploadingImage,
                    builder: (context, uploading, child) {
                      return uploading
                          ? _buildLoader()
                          : const Text('Change Picture');
                    })),
            const SizedBox(width: 10),
            OutlinedButton(
                onPressed: () {
                  NavUtils.navTo(context, const ChangePassword());
                },
                child: const Text('Change Password')),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPersonalInformation(BuildContext context, User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  "Personal Information",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.primaryColor),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 20),
            GenericListItem(
              desc: user.firstName,
              label: "First name",
              verticalPadding: 5,
              leading: const AppIconButton(
                icon: Icons.person,
                height: 40,
                width: 40,
              ),
            ),
            GenericListItem(
              desc: user.lastName,
              label: "Last name",
              leading: const AppIconButton(
                icon: Icons.person,
                height: 40,
                width: 40,
              ),
              verticalPadding: 5,
            ),
            // GenericListItem(
            //   desc: user.phone,
            //   label: "Phone number",
            //   verticalPadding: 5,
            //   leading: const AppIconButton(
            //     icon: Icons.phone,
            //     height: 40,
            //     width: 40,
            //   ),
            // ),
            GenericListItem(
              desc: user.email,
              label: "Email address",
              verticalPadding: 5,
              leading: const AppIconButton(
                icon: Icons.alternate_email,
                height: 40,
                width: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkInformation(BuildContext context, User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  "Work Information",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.primaryColor),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 20),
            GenericListItem(
              desc: user.placeOfWork,
              label: "Place of Work",
              verticalPadding: 5,
              leading: const AppIconButton(
                icon: Icons.work_outline,
                height: 40,
                width: 40,
              ),
            ),
            GenericListItem(
              desc: user.location,
              label: "Location",
              verticalPadding: 5,
              leading: const AppIconButton(
                icon: Icons.location_history,
                height: 40,
                width: 40,
              ),
            ),
            GenericListItem(
              desc: user.designation,
              label: "Designation",
              verticalPadding: 5,
              leading: const AppIconButton(
                icon: Icons.label,
                height: 40,
                width: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return const SizedBox(
        width: 80,
        height: 15,
        child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: [
              AppColors.primaryColorDark,
              Colors.grey,
              AppColors.secondaryColor,
              Colors.white,
              AppColors.primaryColor,
            ],
            strokeWidth: 2,
            pathBackgroundColor: Colors.black));
  }
}
