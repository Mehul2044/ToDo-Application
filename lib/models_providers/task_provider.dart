import 'package:flutter/foundation.dart';

import '../database/db_helper.dart';

import 'task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _list = [];
  List<Task> _completed = [];

  List<Task> get list {
    return [..._list];
  }

  List<Task> get completed {
    return [..._completed];
  }

  List<Task> get favouriteList {
    return [..._list.where((element) => element.isFavourite).toList()];
  }

  void addTask(String title, String? description, DateTime dateTime) {
    String currentDate = DateTime.now().toString();
    _list.add(Task(
        id: currentDate,
        heading: title,
        dateTime: dateTime,
        description: description));
    DBHelper.insert("currentTasks", {
      "id": currentDate,
      "heading": title,
      "description": description,
      "date": dateTime.toIso8601String(),
      "isFavourite": 0
    });
    notifyListeners();
  }

  void markComplete(String id) {
    final taskItem = _list.firstWhere((element) => element.id == id);
    _list.remove(taskItem);
    DBHelper.delete("currentTasks", id);
    _completed.add(taskItem);
    DBHelper.insert("completedTasks", {
      "id": taskItem.id,
      "heading": taskItem.heading,
      "description": taskItem.description,
      "date": taskItem.dateTime.toIso8601String(),
      "isFavourite": taskItem.isFavourite ? 1 : 0
    });
    notifyListeners();
  }

  void markIncomplete(String id) {
    final taskItem = _completed.firstWhere((element) => element.id == id);
    _completed.remove(taskItem);
    DBHelper.delete("completedTasks", id);
    _list.add(taskItem);
    DBHelper.insert("currentTasks", {
      "id": taskItem.id,
      "heading": taskItem.heading,
      "description": taskItem.description,
      "date": taskItem.dateTime.toIso8601String(),
      "isFavourite": taskItem.isFavourite ? 1 : 0
    });
    notifyListeners();
  }

  void deleteTask(String id) {
    _completed.removeWhere((element) => element.id == id);
    DBHelper.delete("completedTasks", id);
    notifyListeners();
  }

  Future<void> setAndFetchTasks() async {
    final completedData = await DBHelper.getData("completedTasks");
    _completed = completedData
        .map((e) => Task(
            id: e["id"],
            heading: e["heading"],
            dateTime: DateTime.parse(e["date"]),
            description: e["description"],
            isFavourite: e["isFavourite"] == 1 ? true : false))
        .toList();
    final currentData = await DBHelper.getData("currentTasks");
    _list = currentData
        .map((e) => Task(
            id: e["id"],
            heading: e["heading"],
            dateTime: DateTime.parse(e["date"]),
            description: e["description"],
            isFavourite: e["isFavourite"] == 1 ? true : false))
        .toList();
  }
}
