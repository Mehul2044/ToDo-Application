import 'package:flutter/material.dart';

import '../screens/completed_task_screen.dart';
import '../screens/home_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
              },
              child: const Text("View ToDo List"),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 200,
              child: Divider(),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(CompletedTasks.routeName);
              },
              child: const Text("View Completed Tasks"),
            ),
          ],
        ),
      ),
    );
  }
}
