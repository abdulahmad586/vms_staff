import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';
import 'package:shevarms_user/visitor_enrolment/visitor_enrolment.dart';

class UserListItem extends StatelessWidget {
  const UserListItem(this.user,
      {Key? key, this.onTap, this.trailing, this.showPhone = false})
      : super(key: key);
  final User user;
  final Widget? trailing;
  final bool showPhone;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      child: InkWell(
        onTap: onTap,
        child: GenericListItem(
            verticalPadding: 5,
            label: [user.firstName, user.lastName].join(" ").trim(),
            desc: user.designation == null || user.designation!.isEmpty
                ? "No designation"
                : "${user.designation}, ${user.placeOfWork}",
            desc2: showPhone ? user.phone : user.userType.name.toUpperCase(),
            leading: CardImage(
              imageString: VisitorModel.getPicture(user.picture),
              size: const Size(40, 40),
              radius: 5,
            ),
            trailing: trailing),
      ),
    );
  }
}
