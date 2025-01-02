import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shevarms_user/shared/shared.dart';

class SuccessPage extends StatefulWidget {
  final Function(BuildContext) onContinue;
  final String? message;
  const SuccessPage({Key? key, required this.onContinue, this.message}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(
            padding: const EdgeInsets.all(10),

              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SvgPicture.asset(
                    AssetConstants.successIllustration,
                    height: 150,
                    width: 150,
                    // color: Colors.green,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "SUCCESS!",
                    style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(widget.message??"Operation was successful",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),

                  Center(
                    child: AppTextButton(
                      buttonColor: AppColors.primaryColor,
                      textColor: Colors.white,
                      loading: false,
                      width: MediaQuery.of(context).size.width-90,
                      label: "CONTINUE",
                      onPressed:()=> widget.onContinue(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
