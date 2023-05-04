import 'package:flutter/material.dart';

import 'add_task_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Center(
            child: Text("TASKS"),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "My Tasks",
              ),
              Tab(
                icon: Icon(Icons.star),
              ),
            ],
          ),
        ),
        floatingActionButton: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddTask.routeName);
          },
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(0.2),
          ),
          icon: const Icon(Icons.add, size: 50),
        ),
        body: const TabBarView(
          children: [Tasks(showFavourites: false), Tasks(showFavourites: true)],
        ),
      ),
    );
  }
}
