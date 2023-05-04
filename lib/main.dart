import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models_providers/task_provider.dart';

import '../screens/completed_task_screen.dart';
import '../screens/add_task_screen.dart';
import '../screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ToDo List",
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const LoadingScreen(),
        routes: {
          AddTask.routeName: (context) => const AddTask(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          CompletedTasks.routeName: (context) => const CompletedTasks(),
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: UniqueKey(),
      future: Provider.of<TaskProvider>(context, listen: false).setAndFetchTasks(),
      builder: (context, snapshot) {
        if (ConnectionState.waiting == snapshot.connectionState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
