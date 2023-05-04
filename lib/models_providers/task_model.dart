import 'package:flutter/foundation.dart';

import '../database/db_helper.dart';

class Task with ChangeNotifier {
  final String id;
  final String heading;
  final String? description;
  final DateTime dateTime;
  bool isFavourite;

  Task(
      {required this.id,
      required this.heading,
      this.description,
      required this.dateTime,
      this.isFavourite = false});

  void toggleFavourite() {
    isFavourite = !isFavourite;
    DBHelper.updateFavouriteStatus(isFavourite ? 1 : 0, id);
    notifyListeners();
  }
}
