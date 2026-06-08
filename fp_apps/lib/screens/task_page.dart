// =================TASK PAGE==============
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_colors.dart';
import 'notes_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  final supabase = Supabase.instance.client;

  final Color primaryColor =
      const Color(0xFF4F46E5);

  List tasks = [];
  List schedules = [];

  String selectedFilter = "All";

  // ==================================

  Future<void> fetchTasks() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('tasks')
          .select()
          .eq('user_id', user.id)
          .order('created_at');

      setState(() {
        tasks = data;
      });

    } catch (e) {

      debugPrint(
        "ERROR TASKS: $e",
      );
    }
  }

  Future<void> fetchSubjects() async {

  try {

    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    final data = await supabase
        .from('schedules')
        .select('subject')
        .eq('user_id', user.id);

    final uniqueSubjects = data
        .map<String>(
          (e) => e['subject'].toString(),
        )
        .where(
          (subject) =>
              subject.trim().isNotEmpty,
        )
        .toSet()
        .toList();

    setState(() {

      schedules = uniqueSubjects;
    });

  } catch (e) {

    debugPrint(
      "ERROR SUBJECTS: $e",
    );
  }
}

  // ================= UPDATE =================

  Future<void> updateTaskStatus(
    String id,
    bool currentStatus,
  ) async {

    try {

      await supabase
          .from('tasks')
          .update({
        'is_done': !currentStatus,
      })
          .eq('id', id);

      fetchTasks();

    } catch (e) {

      debugPrint(
        "ERROR UPDATE TASK: $e",
      );
    }
  }

  Future<void> updateTask(
  String id,
  String title,
  String subject,
  String dueDate,
  String priority,
) async {

  try {

    await supabase
        .from('tasks')
        .update({

      'title': title,

      'subject': subject,

      'due_date': dueDate,

      'priority': priority,
    })
        .eq('id', id);

    fetchTasks();

  } catch (e) {

    debugPrint(
      "ERROR UPDATE TASK: $e",
    );
  }
}

  

  // ================= DELETE =================

  Future<void> deleteTask(
    String id,
  ) async {

    try {

      await supabase
          .from('tasks')
          .delete()
          .eq('id', id);

      fetchTasks();

    } catch (e) {

      debugPrint(
        "ERROR DELETE TASK: $e",
      );
    }
  }

  Future<void> showEditTask(
  dynamic task,
) async {

  final isDark =
      Theme.of(context).brightness ==
          Brightness.dark;

  final titleController =
      TextEditingController(
    text: task['title'],
  );

  final dueDateController =
      TextEditingController(
    text: task['due_date'],
  );

  String priority =
      task['priority'];

  String? selectedSubject =
      task['subject'];

  await showDialog(

    context: context,

    builder: (context) {

      return StatefulBuilder(

        builder:
            (context, setModalState) {

          return AlertDialog(

            backgroundColor:
                AppColors.card(isDark),

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(24),
            ),

            title: Text(

              "Edit Task",

              style: TextStyle(

                color:
                    AppColors.text(isDark),

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            content:
                SingleChildScrollView(

              child: Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  TextField(

                    controller:
                        titleController,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Task Title",
                    ),
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(

  value: schedules.contains(selectedSubject)
      ? selectedSubject
      : null,

  decoration:
      const InputDecoration(
    labelText: "Subject",
  ),

  items:
      schedules.map<DropdownMenuItem<String>>((subject) {

    return DropdownMenuItem<String>(

      value: subject,

      child: Text(subject),
    );

  }).toList(),

  onChanged: (value) {

    setModalState(() {

      selectedSubject = value;
    });
  },
),

                  const SizedBox(height: 14),

                  TextField(

                    controller:
                        dueDateController,

                    readOnly: true,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Due Date",

                      suffixIcon:
                          Icon(
                        Icons.calendar_month,
                        color:
                            primaryColor,
                      ),
                    ),

                    onTap: () async {

                      DateTime? pickedDate =
                          await showDatePicker(

                        context: context,

                        initialDate:
                            DateTime.now(),

                        firstDate:
                            DateTime(2020),

                        lastDate:
                            DateTime(2035),
                      );

                      if (pickedDate != null) {

                        dueDateController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(

                    value: priority,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Priority",
                    ),

                    items: [

                      "Low",
                      "Medium",
                      "High",

                    ].map((e) {

                      return DropdownMenuItem(

                        value: e,
                        child: Text(e),
                      );

                    }).toList(),

                    onChanged: (value) {

                      setModalState(() {

                        priority = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            actions: [

              TextButton(

                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Cancel"),
              ),

              ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryColor,
                ),

                onPressed: () async {

                  await supabase
                      .from('tasks')
                      .update({

                    'title':
                        titleController.text,

                    'subject':
                        selectedSubject,

                    'due_date':
                        dueDateController.text,

                    'priority':
                        priority,
                  })
                      .eq(
                    'id',
                    task['id'],
                  );

                  fetchTasks();

                  if (context.mounted) {

                    Navigator.pop(context);
                  }
                },

                child: const Text(

                  "Update",

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
// ================= ADD TASK =================

Future<void> addTask() async {

  final isDark =
      Theme.of(context).brightness ==
          Brightness.dark;

  final titleController =
      TextEditingController();

  final dueDateController =
      TextEditingController();

  String priority = "Low";

  String? selectedSubject;

  await showDialog(

    context: context,

    builder: (context) {

      return StatefulBuilder(

        builder:
            (context, setModalState) {

          return AlertDialog(

            backgroundColor:
                AppColors.card(isDark),

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(24),
            ),

            title: Text(

              "Add Task",

              style: TextStyle(

                color:
                    AppColors.text(isDark),

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            content:
                SingleChildScrollView(

              child: Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  TextField(

                    controller:
                        titleController,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Task Title",
                    ),
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(

  value: schedules.contains(selectedSubject)
      ? selectedSubject
      : null,

  decoration:
      const InputDecoration(
    labelText: "Subject",
  ),

  items:
      schedules.map<DropdownMenuItem<String>>((subject) {

    return DropdownMenuItem<String>(

      value: subject,

      child: Text(subject),
    );

  }).toList(),

  onChanged: (value) {

    setModalState(() {

      selectedSubject = value;
    });
  },
),

                  const SizedBox(height: 14),

                  TextField(

                    controller:
                        dueDateController,

                    readOnly: true,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Due Date",

                      suffixIcon:
                          Icon(
                        Icons.calendar_month,
                        color:
                            primaryColor,
                      ),
                    ),

                    onTap: () async {

                      DateTime? pickedDate =
                          await showDatePicker(

                        context: context,

                        initialDate:
                            DateTime.now(),

                        firstDate:
                            DateTime(2020),

                        lastDate:
                            DateTime(2035),
                      );

                      if (pickedDate != null) {

                        dueDateController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(

                    value: priority,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Priority",
                    ),

                    items: [

                      "Low",
                      "Medium",
                      "High",

                    ].map((e) {

                      return DropdownMenuItem(

                        value: e,
                        child: Text(e),
                      );

                    }).toList(),

                    onChanged: (value) {

                      setModalState(() {

                        priority = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            actions: [

              TextButton(

                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Cancel"),
              ),

              ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryColor,
                ),

                onPressed: () async {

                  try {

                    final user =
                        supabase.auth.currentUser;

                    if (user == null) return;

                    await supabase
                        .from('tasks')
                        .insert({

                      'user_id':
                          user.id,

                      'title':
                          titleController.text,

                      'subject':
                          selectedSubject,

                      'due_date':
                          dueDateController.text,

                      'priority':
                          priority,

                      'is_done':
                          false,
                    });

                    if (context.mounted) {

                      Navigator.pop(context);
                    }

                    fetchTasks();

                  } catch (e) {

                    debugPrint(
                      "ERROR ADD TASK: $e",
                    );
                  }
                },

                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

// ================= INIT =================

@override
void initState() {
  super.initState();

  fetchTasks();
  fetchSubjects();
}

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    // ================= FILTER =================

    List filteredTasks = tasks;

    if (selectedFilter == "To Do") {

      filteredTasks = tasks.where(
        (task) => task['is_done'] == false,
      ).toList();

    } else if (selectedFilter ==
        "Completed") {

      filteredTasks = tasks.where(
        (task) => task['is_done'] == true,
      ).toList();
    }

    // ================= TODAY =================

    final todayTasks =
        filteredTasks.where((task) {

      if (task['due_date'] == null) {
        return false;
      }

      final dueDate =
          DateTime.parse(task['due_date']);

      final now = DateTime.now();

      return dueDate.year == now.year &&
          dueDate.month == now.month &&
          dueDate.day == now.day;

    }).toList();

    // ================= UPCOMING =================

    final upcomingTasks =
        filteredTasks.where((task) {

      if (task['due_date'] == null) {
        return false;
      }

      final dueDate =
          DateTime.parse(task['due_date']);

      return dueDate.isAfter(
        DateTime.now(),
      );

    }).toList();

    return Scaffold(

      backgroundColor:
          AppColors.background(isDark),

      floatingActionButton:
    FloatingActionButton(

  backgroundColor:
      primaryColor,

  onPressed: () {

    showModalBottomSheet(

      context: context,

      backgroundColor:
          AppColors.card(isDark),

      shape:
          const RoundedRectangleBorder(

        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      builder: (context) {

        return Padding(

          padding:
              const EdgeInsets.all(24),

          child: Column(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              ListTile(

                leading: Icon(
                  Icons.task_alt_rounded,
                  color: primaryColor,
                ),

                title:
                    const Text("Add Task"),

                onTap: () async {

                  Navigator.pop(context);

                  await fetchSubjects();

                  addTask();
                },
              ),

              ListTile(

                leading: Icon(
                  Icons.note_alt_rounded,
                  color: primaryColor,
                ),

                title:
                    const Text("Add Notes"),

                onTap: () {

                  Navigator.pop(context);

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const NotesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  },

  child: const Icon(
    Icons.add,
    color: Colors.white,
  ),
),

      body: SafeArea(

        child: Padding(

          padding:
              const EdgeInsets.all(24),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(

                "Tasks",

                style: TextStyle(

                  fontSize: 32,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.text(isDark),
                ),
              ),

              const SizedBox(height: 24),

              // ================= FILTER BUTTON =================

              SingleChildScrollView(

                scrollDirection:
                    Axis.horizontal,

                child: Row(

                  children: [

                    buildFilterButton(
                      "All",
                      isDark,
                    ),

                    buildFilterButton(
                      "To Do",
                      isDark,
                    ),

                    buildFilterButton(
                      "Completed",
                      isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Expanded(

                child: ListView(

                  children: [

                    // ================= TODAY =================

                    Text(

                      "Today",

                      style: TextStyle(

                        fontSize: 20,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors.text(isDark),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...todayTasks.map(
                      (task) =>
                          buildTaskCard(
                        task,
                        isDark,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= UPCOMING =================

                    Text(

                      "Upcoming",

                      style: TextStyle(

                        fontSize: 20,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors.text(isDark),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...upcomingTasks.map(
                      (task) =>
                          buildTaskCard(
                        task,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= FILTER BUTTON =================

  Widget buildFilterButton(
    String title,
    bool isDark,
  ) {

    final isSelected =
        selectedFilter == title;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedFilter = title;
        });
      },

      child: Container(

        margin:
            const EdgeInsets.only(
          right: 10,
        ),

        padding:
            const EdgeInsets.symmetric(

          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? primaryColor
              : AppColors.card(isDark),

          borderRadius:
              BorderRadius.circular(20),
        ),

        child: Text(

          title,

          style: TextStyle(

            color: isSelected
                ? Colors.white
                : AppColors.text(isDark),

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ================= TASK CARD =================

  Widget buildTaskCard(
    dynamic task,
    bool isDark,
  ) {

    Color priorityColor =
        Colors.green;

    if (task["priority"] == "High") {

      priorityColor = Colors.red;

    } else if (task["priority"] ==
        "Medium") {

      priorityColor = Colors.orange;
    }

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
            AppColors.card(isDark),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Checkbox(

            value:
                task["is_done"] ?? false,

            activeColor:
                primaryColor,

            onChanged: (_) {

              updateTaskStatus(

                task["id"],

                task["is_done"] ?? false,
              );
            },
          ),

          const SizedBox(width: 10),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  task["title"] ??
                      "No Title",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        AppColors.text(isDark),

                    decoration:
                        task["is_done"] == true
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),

                const SizedBox(height: 6),

                Text(

                  task["subject"] ?? "-",

                  style: TextStyle(

                    color:
                        AppColors.subText(isDark),
                  ),
                ),
              ],
            ),
          ),

          Column(

  crossAxisAlignment:
      CrossAxisAlignment.end,

  children: [

    Text(

      task["due_date"] == null
          ? "-"
          : task["due_date"]
              .toString()
              .substring(5, 10),

      style: TextStyle(

        color:
            AppColors.subText(isDark),
      ),
    ),

    const SizedBox(height: 12),

    Row(

      mainAxisSize: MainAxisSize.min,

      children: [

        IconButton(

          onPressed: () async {

            await fetchSubjects();

            showEditTask(task);
          },

          icon: Icon(

            Icons.edit,

            color: primaryColor,
          ),
        ),

        IconButton(

          onPressed: () {

            deleteTask(
              task["id"],
            );
          },

          icon: const Icon(

            Icons.delete,

            color: Colors.red,
          ),
        ),
      ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}