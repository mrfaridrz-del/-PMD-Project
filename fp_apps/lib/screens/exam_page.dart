import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_colors.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {

  final supabase = Supabase.instance.client;

  final Color primaryColor = AppColors.primary;

  List exams = [];

  List<String> schedules = [];

  // ================= FETCH SUBJECTS =================

  Future<void> fetchSubjects() async {

    try {

      final user = supabase.auth.currentUser;

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
            (subject) => subject.trim().isNotEmpty,
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

  // ================= FETCH EXAMS =================

  Future<void> fetchExams() async {

    try {

      final user = supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('exams')
          .select()
          .eq('user_id', user.id)
          .order(
            'exam_date',
            ascending: true,
          );

      setState(() {

        exams = data;
      });

    } catch (e) {

      debugPrint(
        "ERROR EXAMS: $e",
      );
    }
  }

  // ================= DELETE EXAM =================

  Future<void> deleteExam(
    String id,
  ) async {

    try {

      await supabase
          .from('exams')
          .delete()
          .eq('id', id);

      fetchExams();

    } catch (e) {

      debugPrint(
        "ERROR DELETE EXAM: $e",
      );
    }
  }

  // ================= ADD / EDIT EXAM =================

  Future<void> showExamModal({
    Map? exam,
  }) async {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final roomController =
        TextEditingController(
      text: exam?['room'] ?? '',
    );

    final notesController =
        TextEditingController(
      text: exam?['notes'] ?? '',
    );

    final examDateController =
        TextEditingController(
      text: exam?['exam_date'] ?? '',
    );

    String? selectedSubject =
        exam?['subject'];

    final isEdit = exam != null;

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

                isEdit
                    ? "Edit Exam"
                    : "Add Exam",

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

                    // ================= SUBJECT =================

                    DropdownButtonFormField<String>(

                      value:
                          selectedSubject,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Subject",
                      ),

                      items:
                          schedules.map((subject) {

                        return DropdownMenuItem<String>(

                          value: subject,

                          child: Text(subject),
                        );

                      }).toList(),

                      onChanged: (value) {

                        setModalState(() {

                          selectedSubject =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ================= DATE =================

                    TextField(

                      controller:
                          examDateController,

                      readOnly: true,

                      decoration:
                          InputDecoration(

                        labelText:
                            "Exam Date",

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

                          examDateController.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        }
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ================= ROOM =================

                    TextField(

                      controller:
                          roomController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Room",
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ================= NOTES =================

                    TextField(

                      controller:
                          notesController,

                      maxLines: 4,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Notes",
                      ),
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(context);
                  },

                  child:
                      const Text(
                    "Cancel",
                  ),
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
                          supabase
                              .auth
                              .currentUser;

                      if (user == null) return;

                      if (isEdit) {

                        await supabase
                            .from('exams')
                            .update({

                          'subject':
                              selectedSubject,

                          'exam_date':
                              examDateController
                                  .text,

                          'room':
                              roomController.text,

                          'notes':
                              notesController.text,
                        })
                            .eq(
                          'id',
                          exam['id'],
                        );

                      } else {

                        await supabase
                            .from('exams')
                            .insert({

                          'user_id':
                              user.id,

                          'subject':
                              selectedSubject,

                          'exam_date':
                              examDateController
                                  .text,

                          'room':
                              roomController.text,

                          'notes':
                              notesController.text,
                        });
                      }

                      if (context.mounted) {

                        Navigator.pop(context);
                      }

                      fetchExams();

                    } catch (e) {

                      debugPrint(
                        "ERROR SAVE EXAM: $e",
                      );
                    }
                  },

                  child: Text(

                    isEdit
                        ? "Update"
                        : "Save",

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
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

    fetchExams();
    fetchSubjects();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
          AppColors.background(isDark),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            primaryColor,

        onPressed: () async {

          await fetchSubjects();

          showExamModal();
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

              Row(

                children: [

                  IconButton(

                    onPressed: () {

                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(

                    "Exams",

                    style: TextStyle(

                      fontSize: 32,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors.text(isDark),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              Expanded(

                child: exams.isEmpty

                    ? Center(

                        child: Text(

                          "No Exams",

                          style: TextStyle(

                            color:
                                AppColors.subText(
                              isDark,
                            ),
                          ),
                        ),
                      )

                    : ListView.builder(

                        itemCount:
                            exams.length,

                        itemBuilder:
                            (context, index) {

                          final exam =
                              exams[index];

                          return Container(

                            margin:
                                const EdgeInsets.only(
                              bottom: 18,
                            ),

                            padding:
                                const EdgeInsets.all(
                              20,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  AppColors.card(
                                isDark,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                24,
                              ),
                            ),

                            child: Row(

                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Container(

                                  width: 8,
                                  height: 120,

                                  decoration:
                                      BoxDecoration(

                                    color:
                                        primaryColor,

                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 18,
                                ),

                                Expanded(

                                  child: Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [

                                      Text(

                                        exam['subject'] ??
                                            "-",

                                        style: TextStyle(

                                          fontSize: 22,

                                          fontWeight:
                                              FontWeight.bold,

                                          color:
                                              AppColors.text(
                                            isDark,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      Row(

                                        children: [

                                          Icon(

                                            Icons.calendar_month,

                                            size: 18,

                                            color:
                                                AppColors.subText(
                                              isDark,
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 6,
                                          ),

                                          Text(

                                            exam['exam_date']
                                                .toString(),

                                            style: TextStyle(

                                              color:
                                                  AppColors.subText(
                                                isDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 8,
                                      ),

                                      Row(

                                        children: [

                                          Icon(

                                            Icons.location_on,

                                            size: 18,

                                            color:
                                                AppColors.subText(
                                              isDark,
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 6,
                                          ),

                                          Text(

                                            exam['room'] ??
                                                "-",

                                            style: TextStyle(

                                              color:
                                                  AppColors.subText(
                                                isDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 12,
                                      ),

                                      Text(

                                        exam['notes'] ??
                                            "-",

                                        style: TextStyle(

                                          color:
                                              AppColors.text(
                                            isDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Column(

                                  children: [

                                    IconButton(

                                      onPressed: () async {

                                        await fetchSubjects();

                                        showExamModal(
                                          exam: exam,
                                        );
                                      },

                                      icon: Icon(

                                        Icons.edit,

                                        color:
                                            primaryColor,
                                      ),
                                    ),

                                    IconButton(

                                      onPressed: () {

                                        deleteExam(
                                          exam['id']
                                              .toString(),
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
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}