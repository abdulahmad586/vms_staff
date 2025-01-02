import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shevarms_user/shared/shared.dart';

class CautionPage extends StatefulWidget {
  final Function() onContinue;
  final String? message;
  const CautionPage({Key? key, required this.onContinue, this.message}) : super(key: key);

  @override
  State<CautionPage> createState() => _CautionPageState();
}

class _CautionPageState extends State<CautionPage> {

  TextEditingController nin = TextEditingController();



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),

        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SvgPicture.asset(
              'assets/icons/warning.svg',
              height: 100,
              width: 100,
              // color: Colors.orange,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "CAUTION",
              style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Text("By clicking the button below, you will be submitting an emergency incident report. Please note that prank reports will not be tolerated.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),

            Center(
              child: AppTextButton(
                buttonColor: AppColors.primaryColor,
                textColor: Colors.white,
                loading: false,
                width: 280,
                label: "SUBMIT",
                onPressed: widget.onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
