import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_colors.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() =>
      _NotesPageState();
}

class _NotesPageState
    extends State<NotesPage> {

  final supabase =
      Supabase.instance.client;

  final Color primaryColor =
      AppColors.primary;

  List notes = [];
  List<String> subjects = [];

  // ================= FETCH NOTES =================

  Future<void> fetchNotes() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('notes')
          .select()
          .eq('user_id', user.id)
          .order(
            'created_at',
            ascending: false,
          );

      setState(() {

        notes = data;
      });

    } catch (e) {

      debugPrint(
        "ERROR NOTES: $e",
      );
    }
  }

  // ================= FETCH SUBJECTS =================

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
      (subject) => subject.trim().isNotEmpty,
    )
    .toSet()
    .toList();
      setState(() {

        subjects = uniqueSubjects;
      });

    } catch (e) {

      debugPrint(
        "ERROR SUBJECTS: $e",
      );
    }
  }

  // ================= DELETE NOTE =================

  Future<void> deleteNote(
    String id,
  ) async {

    try {

      await supabase
          .from('notes')
          .delete()
          .eq('id', id);

      fetchNotes();

    } catch (e) {

      debugPrint(
        "ERROR DELETE NOTE: $e",
      );
    }
  }

  // ================= EDIT NOTE =================

  Future<void> editNote(
    Map note,
  ) async {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final titleController =
        TextEditingController(
      text: note['title'],
    );

    final contentController =
        TextEditingController(
      text: note['content'],
    );

    String? selectedSubject =
        note['subject'];

    await showModalBottomSheet(

      context: context,

      isScrollControlled: true,

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

        return StatefulBuilder(

          builder:
              (context, setModalState) {

            return Padding(

              padding: EdgeInsets.only(

                left: 24,
                right: 24,
                top: 24,

                bottom:
                    MediaQuery.of(context)
                        .viewInsets
                        .bottom + 24,
              ),

              child: SingleChildScrollView(

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Edit Note",

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors.text(isDark),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(

                      controller:
                          titleController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Title",
                      ),
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<String>(

  value: subjects.contains(selectedSubject)
      ? selectedSubject
      : null,

  decoration:
      const InputDecoration(
    labelText: "Subject",
  ),

  items:
      subjects.map((subject) {

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

                    const SizedBox(height: 18),

                    TextField(

                      controller:
                          contentController,

                      maxLines: 8,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Content",

                        alignLabelWithHint:
                            true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(

                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              primaryColor,
                        ),

                        onPressed: () async {

                          try {

                            await supabase
                                .from('notes')
                                .update({

                              'title':
                                  titleController.text,

                              'subject':
                                  selectedSubject,

                              'content':
                                  contentController.text,

                            }).eq(
                              'id',
                              note['id'],
                            );

                            if (context.mounted) {

                              Navigator.pop(
                                context,
                              );
                            }

                            fetchNotes();

                          } catch (e) {

                            debugPrint(
                              "ERROR EDIT NOTE: $e",
                            );
                          }
                        },

                        child: const Text(

                          "Update Note",

                          style: TextStyle(
                            color:
                                Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= ADD NOTE =================

  Future<void> showAddNoteModal() async {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final titleController =
        TextEditingController();

    final contentController =
        TextEditingController();

    String? selectedSubject;

    await showModalBottomSheet(

      context: context,

      isScrollControlled: true,

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

        return StatefulBuilder(

          builder:
              (context, setModalState) {

            return Padding(

              padding: EdgeInsets.only(

                left: 24,
                right: 24,
                top: 24,

                bottom:
                    MediaQuery.of(context)
                        .viewInsets
                        .bottom + 24,
              ),

              child: SingleChildScrollView(

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Add Note",

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors.text(isDark),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(

                      controller:
                          titleController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Title",
                      ),
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<String>(

  value: subjects.contains(selectedSubject)
      ? selectedSubject
      : null,

  decoration:
      const InputDecoration(
    labelText: "Subject",
  ),

  items:
      subjects.map((subject) {

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

                    const SizedBox(height: 18),

                    TextField(

                      controller:
                          contentController,

                      maxLines: 8,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Content",

                        alignLabelWithHint:
                            true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(

                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(

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

                            if (user == null) {
                              return;
                            }

                            await supabase
                                .from('notes')
                                .insert({

                              'user_id':
                                  user.id,

                              'title':
                                  titleController
                                      .text,

                              'subject':
                                  selectedSubject,

                              'content':
                                  contentController
                                      .text,
                            });

                            if (context.mounted) {

                              Navigator.pop(
                                context,
                              );
                            }

                            fetchNotes();

                          } catch (e) {

                            debugPrint(
                              "ERROR ADD NOTE: $e",
                            );
                          }
                        },

                        child: const Text(

                          "Save Note",

                          style: TextStyle(
                            color:
                                Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

    fetchNotes();
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
            showAddNoteModal();
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
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, 
                  
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                ],
              ),

              const SizedBox(width: 8),

              Text(

                "Notes",

                style: TextStyle(

                  fontSize: 32,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.text(isDark),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(

                child: notes.isEmpty

                    ? Center(

                        child: Text(

                          "No notes yet",

                          style: TextStyle(

                            color:
                                AppColors.subtitle(
                              isDark,
                            ),
                          ),
                        ),
                      )

                    : ListView.builder(

                        itemCount:
                            notes.length,

                        itemBuilder:
                            (context, index) {

                          final note =
                              notes[index];

                          return Container(

                            margin:
                                const EdgeInsets.only(
                              bottom: 18,
                            ),

                            padding:
                                const EdgeInsets.all(20),

                            decoration:
                                BoxDecoration(

                              color:
                                  AppColors.card(isDark),

                              borderRadius:
                                  BorderRadius.circular(24),
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Row(

                                  children: [

                                    Expanded(

                                      child: Text(

                                        note['title'] ??
                                            "-",

                                        style: TextStyle(

                                          fontSize: 20,

                                          fontWeight:
                                              FontWeight.bold,

                                          color:
                                              AppColors.text(isDark),
                                        ),
                                      ),
                                    ),

                                    IconButton(

                                      onPressed: () async {

                                        await fetchSubjects();

                                        editNote(
                                          note,
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

                                        deleteNote(
                                          note['id']
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

                                const SizedBox(height: 6),

                                Text(

                                  note['subject'] ??
                                      "-",

                                  style: TextStyle(

                                    color:
                                        primaryColor,

                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Text(

                                  note['content'] ??
                                      "-",

                                  style: TextStyle(

                                    color:
                                        AppColors.text(isDark),

                                    height: 1.5,
                                  ),
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