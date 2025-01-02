import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shevarms_user/shared/shared.dart';

class UserCode extends StatelessWidget{
  final User user;
  const UserCode(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .5,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text('User Code', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontFamily: 'Iceberg'),),
          const SizedBox(height: 10),
          Text('scan code',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey) ),
          const SizedBox(height: 20),
          Text([user.firstName, user.lastName].join(" "), style: Theme.of(context).textTheme.labelMedium?.copyWith(fontFamily: 'Iceberg'),),
          const SizedBox(height: 20),
          PrettyQr(
            image: const AssetImage(AssetConstants.logoSmall),
            typeNumber: 3,
            size: 180,
            data: user.id,
            errorCorrectLevel: QrErrorCorrectLevel.M,
            roundEdges: true,
          ),
          const Expanded(child: SizedBox()),
          AppTextButton(
            buttonColor: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            label: 'CLOSE',
          ),
        ],
      ),
    );
  }

}