import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';

class UserInformation extends StatelessWidget {
  const UserInformation(this.user, {super.key});

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CardImage(
                imageString: user.picture,
                size: const Size(150, 150),
                radius: 100,
              ),
              const SizedBox(height: 10),
              Text(
                "Profile Picture",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Text("${user.firstName} ${user.lastName}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Iceberg',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  const SizedBox(width: 10),
                  Text(
                    "Personal Information",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.primaryColor),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 10),
              GenericListItem(
                desc: "${user.firstName} ${user.lastName}",
                label: "Name",
                verticalPadding: 5,
                leading: const AppIconButton(
                  icon: Icons.person,
                  height: 40,
                  width: 40,
                ),
              ),
              GenericListItem(
                desc: user.phone,
                label: "Phone number",
                verticalPadding: 5,
                leading: const AppIconButton(
                  icon: Icons.phone,
                  height: 40,
                  width: 40,
                ),
              ),
              GenericListItem(
                desc: user.email,
                label: "Email address",
                verticalPadding: 5,
                leading: const AppIconButton(
                  icon: Icons.email,
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  const SizedBox(width: 10),
                  Text(
                    "Location",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.primaryColor),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 10),
              GenericListItem(
                desc: user.placeOfWork,
                label: "Place of Work",
                verticalPadding: 5,
                trailing: const AppIconButton(
                  icon: Icons.location_city,
                  height: 40,
                  width: 40,
                ),
              ),
              GenericListItem(
                desc: user.location,
                label: "Location",
                verticalPadding: 5,
                trailing: const AppIconButton(
                  icon: Icons.location_on,
                  height: 40,
                  width: 40,
                ),
              ),
              GenericListItem(
                desc: CalendarUtils.timeToString(user.createdAt,
                    includeTime: true),
                label: "Profile creation",
                verticalPadding: 5,
                trailing: const AppIconButton(
                  icon: Icons.calendar_month,
                  height: 40,
                  width: 40,
                ),
              ),
            ],
          ),
        ));
  }
}
