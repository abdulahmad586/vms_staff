import 'package:flutter/material.dart';

class DashboardOfflineWidget extends StatelessWidget {
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
              Icons.desktop_mac_rounded,
              size: 90,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Dashboard is Offline",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Your dashboard is currently offline, please turn on your device",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
