import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models_providers/task_model.dart';
import '../models_providers/task_provider.dart';

import '../screens/add_task_screen.dart';

class Tasks extends StatelessWidget {
  final bool showFavourites;

  const Tasks({Key? key, required this.showFavourites}) : super(key: key);

  String _dateTimeFormatter(DateTime date) {
    return DateFormat('dd\'th\' MMMM, EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final taskList = showFavourites
        ? Provider.of<TaskProvider>(context).favouriteList
        : Provider.of<TaskProvider>(context).list;
    if (taskList.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: taskList[index],
            child: taskList[index].description == null ||
                    taskList[index].description!.isEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            Provider.of<TaskProvider>(context, listen: false)
                                .markComplete(taskList[index].id);
                            showSnackBar(context, "Marked as Completed");
                          },
                        ),
                        title: Text(taskList[index].heading),
                        subtitle:
                            Text(_dateTimeFormatter(taskList[index].dateTime)),
                        trailing: Consumer<Task>(
                          builder: (context, task, child) => IconButton(
                            onPressed: () {
                              task.toggleFavourite();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 1000),
                                  content: task.isFavourite
                                      ? const Text("Added as a Favourite!")
                                      : const Text("Removed from Favourite!"),
                                ),
                              );
                            },
                            icon: task.isFavourite
                                ? const Icon(Icons.star)
                                : const Icon(Icons.star_border),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(taskList[index].heading),
                                  content: Text(
                                      taskList[index].description as String),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Okay")),
                                  ],
                                );
                              });
                        },
                        leading: IconButton(
                          icon: const Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            Provider.of<TaskProvider>(context, listen: false)
                                .markComplete(taskList[index].id);
                            showSnackBar(context, "Marked as Completed");
                          },
                        ),
                        title: Text(taskList[index].heading),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(taskList[index].description as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _dateTimeFormatter(taskList[index].dateTime),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        trailing: Consumer<Task>(
                          builder: (context, task, child) => IconButton(
                            onPressed: () {
                              task.toggleFavourite();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 1000),
                                  content: task.isFavourite
                                      ? const Text("Added as a Favourite!")
                                      : const Text("Removed from Favourite!"),
                                ),
                              );
                            },
                            icon: task.isFavourite
                                ? const Icon(Icons.star)
                                : const Icon(Icons.star_border),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
        itemCount: taskList.length,
      );
    } else {
      if (showFavourites) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Text(
                "You do not have any favourite tasks. Once you favourite a task, it will be shown here."),
          ),
        );
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child:
                  Text("Your ToDo List is empty.\nStart by adding some tasks."),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AddTask.routeName);
              },
              icon: const Icon(Icons.add),
              label: const Text("Add"),
            ),
          ],
        ),
      );
    }
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        duration: const Duration(milliseconds: 1000),
        content: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
