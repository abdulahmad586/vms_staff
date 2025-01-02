import 'package:flutter/material.dart';

class DashboardMessage extends StatelessWidget {
  final String title;
  final String message;
  final Widget? action;
  const DashboardMessage(
      {required this.title, required this.message, this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.info,
              size: 90,
              color: Colors.blue,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            if (action != null)
              const SizedBox(
                height: 20,
              ),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}
