import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shevarms_user/shared/shared.dart';

class ErrorPage extends StatefulWidget {
  final Function() onContinue;
  final String? message;
  final bool? showBack;
  const ErrorPage(
      {Key? key, required this.onContinue, this.message, this.showBack})
      : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          SvgPicture.asset(
            'assets/icons/error.svg',
            height: 100,
            width: 100,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "OOPS!",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            widget.message ?? "Operation was not successful",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
          ),
          const Spacer(),
          Center(
            child: AppTextButton(
              buttonColor: AppColors.primaryColor,
              textColor: Colors.white,
              loading: false,
              width: 250,
              label: "RETRY",
              onPressed: widget.onContinue,
            ),
          ),
        ],
      ),
    );
  }
}
