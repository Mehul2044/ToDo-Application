import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models_providers/task_provider.dart';

class AddTask extends StatefulWidget {
  static const routeName = "/add-task";

  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime? chosenDate;
  final _form = GlobalKey<FormState>();
  late String title;
  String? description;

  void _saveForm() {
    bool? isValidate = _form.currentState?.validate();
    if (isValidate == null || !isValidate) {
    } else if (chosenDate == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("No Date Chosen"),
              content: const Text("Choose a date for the deadline of the task."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Okay!"),
                ),
              ],
            );
          });
    } else {
      _form.currentState?.save();
      Provider.of<TaskProvider>(context, listen: false)
          .addTask(title, description, chosenDate as DateTime);
      Navigator.of(context).pop();
    }
  }

  void _selectDate(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        chosenDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Task"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a heading!";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(labelText: "Title"),
                      onSaved: (value) {
                        title = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Description(optional)"),
                      onSaved: (value) {
                        description = value;
                      },
                    ),
                    const SizedBox(height: 70),
                    const Text("Choose deadline for the task:"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(chosenDate == null
                            ? "Date Picked: No date chosen!"
                            : "Date Chosen:${DateFormat('dd/MM/yyyy').format(chosenDate as DateTime)}"),
                        IconButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
            TextButton(
              onPressed: _saveForm,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(15.0),
                backgroundColor: Colors.grey.withOpacity(0.05),
              ),
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
