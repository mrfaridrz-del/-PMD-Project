import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {

  final Map<String, dynamic> task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() =>
      _EditTaskScreenState();
}



// LETAK CODE INI DI BAWAH
class _EditTaskScreenState
    extends State<EditTaskScreen> {

  late TextEditingController titleController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.task["title"],
    );

    dateController = TextEditingController(
      text: widget.task["date"],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            TextField(
              controller: titleController,

              decoration: const InputDecoration(
                labelText: "Task Title",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: dateController,

              decoration: const InputDecoration(
                labelText: "Due Date",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {

                Navigator.pop(context, {
                  "id": widget.task["id"],
                  "title": titleController.text,
                  "date": dateController.text,
                  "done": widget.task["done"],
                });
              },

              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}