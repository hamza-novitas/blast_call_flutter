import 'dart:async';

import 'package:flutter/material.dart';

void showLaunchConfirmationDialog(BuildContext context, VoidCallback onLaunch) {
  int countdown = 3;
  Timer? timer;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Start countdown timer
          timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
            if (countdown == 1) {
              t.cancel();
              Navigator.of(context).pop(); // Close the dialog
              onLaunch(); // Run your callback
            } else {
              setState(() {
                countdown--;
              });
            }
          });

          return AlertDialog(
            title: const Text('Confirm Launch'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Do you want to launch the notification?'),
                const SizedBox(height: 12),
                Text(
                  'Launching in $countdown...',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center, // 👈 Center buttons
            actions: [
              TextButton(
                onPressed: () {
                  timer?.cancel();
                  Navigator.of(context).pop();
                  onLaunch(); // Run immediately
                },
                child: const Text('Yes'),
              ),
              const SizedBox(width: 16), // 👈 Optional spacing between buttons
              TextButton(
                onPressed: () {
                  timer?.cancel();
                  Navigator.of(context).pop();

                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
    },
  );
}
