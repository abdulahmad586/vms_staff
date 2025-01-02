import 'package:flutter/material.dart';

class SocketConnectionProblem extends StatelessWidget {
  const SocketConnectionProblem({super.key});

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
              Icons.signal_wifi_connected_no_internet_4,
              size: 90,
              color: Colors.orange,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "You are offline",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Please check your internet connection",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
