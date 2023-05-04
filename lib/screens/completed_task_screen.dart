import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models_providers/task_provider.dart';

import '../widgets/app_drawer.dart';

class CompletedTasks extends StatelessWidget {
  static const routeName = "/completed-tasks";

  const CompletedTasks({Key? key}) : super(key: key);

  String _dateTimeFormatter(DateTime date) {
    return DateFormat('dd\'th\' MMMM, EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final taskList = Provider.of<TaskProvider>(context).completed;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Completed Tasks"),
      ),
      body: taskList.isEmpty
          ? const Center(
              child: Text("You have not marked task as completed."),
            )
          : Column(
              children: [
                const SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: IconButton(
                            onPressed: () {
                              Provider.of<TaskProvider>(context, listen: false)
                                  .markIncomplete(taskList[index].id);
                              showSnackBar(context, "Marked as Incomplete");
                            },
                            icon: const Icon(Icons.check_box),
                            tooltip: "Mark Incomplete",
                          ),
                          title: Text(taskList[index].heading),
                          subtitle: Text(
                              "Task Deadline:\n${_dateTimeFormatter(taskList[index].dateTime)}"),
                          trailing: IconButton(
                            onPressed: () {
                              Provider.of<TaskProvider>(context, listen: false)
                                  .deleteTask(taskList[index].id);
                              showSnackBar(
                                  context, "Task Item successfully deleted.");
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                      itemCount: taskList.length),
                ),
              ],
            ),
    );
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
