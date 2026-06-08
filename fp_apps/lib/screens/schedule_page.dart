import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/app_colors.dart';
import 'exam_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() =>
      _SchedulePageState();
}

class _SchedulePageState
    extends State<SchedulePage> {

  final supabase =
      Supabase.instance.client;

  final Color primaryColor =
      AppColors.primary;

  final TextEditingController
      subjectController =
      TextEditingController();

  final TextEditingController
      roomController =
      TextEditingController();

  final TextEditingController
      lecturerController =
      TextEditingController();

  String selectedScheduleDay =
      "Monday";

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List exams = [];
  List schedules = [];

  DateTime selectedDay =
      DateTime.now();

  final List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  // ================= FETCH =================

  Future<void> fetchSchedules() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('schedules')
          .select()
          .eq('user_id', user.id)
          .order('created_at');

      setState(() {
        schedules = data;
      });

    } catch (e) {

      debugPrint(
        "ERROR SCHEDULES: $e",
      );
    }
  }

  Future<void> fetchExams() async {

  try {

    final user =
        supabase.auth.currentUser;

    if (user == null) return;

    final data = await supabase
        .from('exams')
        .select()
        .eq('user_id', user.id);

    setState(() {

      exams = data;
    });

  } catch (e) {

    debugPrint(
      "ERROR EXAMS: $e",
    );
  }
}

  // ================= ADD =================

  Future<void> addSchedule() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      if (startTime == null ||
          endTime == null) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
                Text("Select time first"),
          ),
        );

        return;
      }

      await supabase
          .from('schedules')
          .insert({

        'user_id': user.id,

        'subject':
            subjectController.text,

        'day':
            selectedScheduleDay,

        'date':
            selectedDay.toIso8601String(),

        'start_time':
            startTime!.format(context),

        'end_time':
            endTime!.format(context),

        'room':
            roomController.text,

        'lecturer':
            lecturerController.text,
      });

      subjectController.clear();
      roomController.clear();
      lecturerController.clear();

      setState(() {

        startTime = null;
        endTime = null;
      });

      fetchSchedules();

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("Schedule Added"),
        ),
      );

    } catch (e) {

      debugPrint(
        "ERROR ADD SCHEDULE: $e",
      );
    }
  }

  // ================= DELETE =================

  Future<void> deleteSchedule(
    String id,
    String subject,
  ) async {

    try {

      // SCHEDULE
      await supabase
          .from('schedules')
          .delete()
          .eq('id', id);

      fetchSchedules();

      // TASKS
      await supabase
        .from('tasks')
        .update({
          'subject': null,
        })
        .eq('subject', subject);

      
      // EXAMS
    await supabase
        .from('exams')
        .update({
          'subject': null,
        })
        .eq('subject', subject);

    // NOTES
    await supabase
        .from('notes')
        .update({
          'subject': null,
        })
        .eq('subject', subject);

    fetchSchedules();

    } catch (e) {

      debugPrint(
        "ERROR DELETE: $e",
      );
    }
  }

  // ================= UPDATE =================

Future<void> updateSchedule(
  String id,
) async {

  try {

    await supabase
        .from('schedules')
        .update({

      'subject':
          subjectController.text,

      'day':
          selectedScheduleDay,

      'start_time':
          startTime!.format(context),

      'end_time':
          endTime!.format(context),

      'room':
          roomController.text,

      'lecturer':
          lecturerController.text,
    })
        .eq('id', id);

    fetchSchedules();

    if (mounted) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text("Schedule Updated"),
        ),
      );
    }

  } catch (e) {

    debugPrint(
      "ERROR UPDATE: $e",
    );
  }
}

// ================= EDIT MODAL =================

void showEditScheduleModal(
  dynamic schedule,
  bool isDark,
) {


  subjectController.text =
      schedule['subject'];

  roomController.text =
      schedule['room'];

  lecturerController.text =
      schedule['lecturer'];

  selectedScheduleDay =
      schedule['day'];
  
  startTime = TimeOfDay.now();
  endTime = TimeOfDay.now();

  showModalBottomSheet(

    context: context,

    isScrollControlled: true,

    backgroundColor:
        AppColors.background(isDark),

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

                    "Edit Schedule",

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
                        subjectController,

                    decoration:
                        inputStyle(
                      "Subject",
                      isDark,
                    ),
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(

                    value:
                        selectedScheduleDay,

                    decoration:
                        inputStyle(
                      "Day",
                      isDark,
                    ),

                    items:
                        weekDays.map((day) {

                      return DropdownMenuItem(

                        value: day,

                        child: Text(day),
                      );

                    }).toList(),

                    onChanged: (value) {

                      setModalState(() {

                        selectedScheduleDay =
                            value!;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  TextField(

                    controller:
                        roomController,

                    decoration:
                        inputStyle(
                      "Room",
                      isDark,
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(

                    controller:
                        lecturerController,

                    decoration:
                        inputStyle(
                      "Lecturer",
                      isDark,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(

                    width: double.infinity,
                    height: 56,

                    child: ElevatedButton(

                      onPressed: () async {

                        await updateSchedule(
                          schedule['id'],
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            primaryColor,

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(

                        "Update Schedule",

                        style: TextStyle(

                          color: Colors.white,

                          fontWeight:
                              FontWeight.bold,
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

  // ================= INPUT STYLE =================

  InputDecoration inputStyle(
    String label,
    bool isDark,
  ) {

    return InputDecoration(

      labelText: label,

      labelStyle: TextStyle(
        color:
            AppColors.subText(isDark),
      ),

      filled: true,

      fillColor:
          AppColors.card(isDark),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),

      border: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(20),

        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(20),

        borderSide:
            BorderSide.none,
      ),

      focusedBorder:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(20),

        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
    );
  }

  // ================= ADD SCHEDULE =================

  void showAddScheduleModal(bool isDark) {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor:
          AppColors.background(isDark),

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

                      "Add Schedule",

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
                          subjectController,

                      decoration:
                          inputStyle(
                        "Subject",
                        isDark,
                      ),
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<String>(

                      value:
                          selectedScheduleDay,

                      decoration:
                          inputStyle(
                        "Day",
                        isDark,
                      ),

                      items:
                          weekDays.map((day) {

                        return DropdownMenuItem(

                          value: day,

                          child: Text(day),
                        );

                      }).toList(),

                      onChanged: (value) {

                        setModalState(() {

                          selectedScheduleDay =
                              value!;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    Row(

                      children: [

                        Expanded(

                          child: GestureDetector(

                            onTap: () async {

                              final picked =
                                  await showTimePicker(

                                context: context,

                                initialTime:
                                    TimeOfDay.now(),
                              );

                              if (picked != null) {

                                setModalState(() {

                                  startTime =
                                      picked;
                                });
                              }
                            },

                            child: Container(

                              padding:
                                  const EdgeInsets.all(18),

                              decoration:
                                  BoxDecoration(

                                color:
                                    AppColors.card(isDark),

                                borderRadius:
                                    BorderRadius.circular(20),
                              ),

                              child: Text(

                                startTime == null
                                    ? "Start Time"
                                    : startTime!.format(context),

                                style: TextStyle(
                                  color:
                                      AppColors.text(isDark),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(

                          child: GestureDetector(

                            onTap: () async {

                              final picked =
                                  await showTimePicker(

                                context: context,

                                initialTime:
                                    TimeOfDay.now(),
                              );

                              if (picked != null) {

                                setModalState(() {

                                  endTime =
                                      picked;
                                });
                              }
                            },

                            child: Container(

                              padding:
                                  const EdgeInsets.all(18),

                              decoration:
                                  BoxDecoration(

                                color:
                                    AppColors.card(isDark),

                                borderRadius:
                                    BorderRadius.circular(20),
                              ),

                              child: Text(

                                endTime == null
                                    ? "End Time"
                                    : endTime!.format(context),

                                style: TextStyle(
                                  color:
                                      AppColors.text(isDark),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    TextField(

                      controller:
                          roomController,

                      decoration:
                          inputStyle(
                        "Room",
                        isDark,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(

                      controller:
                          lecturerController,

                      decoration:
                          inputStyle(
                        "Lecturer",
                        isDark,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(

                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(

                        onPressed: () async {

                          await addSchedule();

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              primaryColor,

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),

                        child: const Text(

                          "Save Schedule",

                          style: TextStyle(

                            color: Colors.white,

                            fontWeight:
                                FontWeight.bold,
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

    fetchSchedules();
    fetchExams();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
          AppColors.background(
        isDark,
      ),

      floatingActionButton: FloatingActionButton(

  backgroundColor: primaryColor,

  child: const Icon(
    Icons.add,
    color: Colors.white,
  ),

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
                  Icons.calendar_today,
                  color: primaryColor,
                ),

                title:
                    const Text(
                  "Add Schedule",
                ),

                onTap: () {

                  Navigator.pop(context);

                  showAddScheduleModal(
                    isDark,
                  );
                },
              ),

              ListTile(

                leading: Icon(
                  Icons.menu_book_rounded,
                  color: primaryColor,
                ),

                title:
                    const Text(
                  "Add Exam",
                ),

                onTap: () {

                  Navigator.pop(context);

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          const ExamPage(),
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

                "Schedule",

                style: TextStyle(

                  fontSize: 32,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.text(isDark),
                ),
              ),

              const SizedBox(height: 24),

              // ================= CALENDAR =================

              TableCalendar(

                firstDay:
                    DateTime.utc(
                  2020,
                  1,
                  1,
                ),

                lastDay:
                    DateTime.utc(
                  2035,
                  12,
                  31,
                ),

                focusedDay:
                    selectedDay,

                selectedDayPredicate:
                    (day) {

                  return isSameDay(
                    selectedDay,
                    day,
                  );
                },

                calendarFormat:
                    CalendarFormat.month,

                headerVisible: true,

                headerStyle: HeaderStyle(
                  titleCentered: true,

                  formatButtonVisible: false,

                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.text(isDark),
                  ),

                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.text(isDark),
                  ),

                  titleTextStyle: TextStyle(

                    color: AppColors.text(isDark),

                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                availableGestures:
                    AvailableGestures.horizontalSwipe,

                onDaySelected:
                    (selected, focused) {

                  setState(() {

                    selectedDay =
                        selected;
                  });
                },

                calendarStyle:
                    CalendarStyle(

                  todayDecoration:
                      BoxDecoration(

                    color:
                        primaryColor.withValues(
                      alpha: 0.4,
                    ),

                    shape:
                        BoxShape.circle,
                  ),

                  selectedDecoration:
                      BoxDecoration(

                    color:
                        primaryColor,

                    shape:
                        BoxShape.circle,
                  ),

                  markerDecoration:
                      const BoxDecoration(

                    color: Colors.red,

                    shape:
                        BoxShape.circle,
                  ),

                  markersMaxCount: 1,

                  defaultTextStyle:
                      TextStyle(
                    color:
                        AppColors.text(isDark),
                  ),

                  weekendTextStyle:
                      TextStyle(
                    color:
                        AppColors.text(isDark),
                  ),

                  todayTextStyle:
                      const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),

                  selectedTextStyle:
                      const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                daysOfWeekStyle:
                    DaysOfWeekStyle(

                  weekdayStyle:
                      TextStyle(
                    color:
                        AppColors.subText(isDark),
                  ),

                  weekendStyle:
                      TextStyle(
                    color:
                        AppColors.subText(isDark),
                  ),
                ),

                eventLoader: (day) {
                  final events =
                  exams.where((exam) {
                    final examDate = 
                    DateTime.parse(
                      exam['exam_date'],
                    );
                    
                    return isSameDay(
                      examDate,
                      day,
                    );
                  }).toList();
                  
                  return events;
                },
              ),

              const SizedBox(height: 28),

              Expanded(

                child: Builder(

                  builder: (context) {

                    final filteredSchedules =
                        schedules.where((schedule) {

                      return schedule['day'] ==

                          weekDays[
                              selectedDay.weekday - 1
                          ];

                    }).toList();

                    if (filteredSchedules.isEmpty) {

                      return Center(

                        child: Text(

                          "No schedules",

                          style: TextStyle(

                            color:
                                AppColors.subText(isDark),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(

                      itemCount:
                          filteredSchedules.length,

                      itemBuilder:
                          (context, index) {

                        final schedule =
                            filteredSchedules[index];

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

                          child: Row(

                            children: [

                              Container(

                                width: 8,
                                height: 100,

                                decoration:
                                    BoxDecoration(

                                  color:
                                      primaryColor,

                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      schedule['subject'],

                                      style: TextStyle(

                                        fontSize: 20,

                                        fontWeight:
                                            FontWeight.bold,

                                        color:
                                            AppColors.text(isDark),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(

                                      "${schedule['start_time']} - ${schedule['end_time']}",

                                      style: TextStyle(
                                        color:
                                            AppColors.subText(isDark),
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(

                                      "Room ${schedule['room']}",

                                      style: TextStyle(
                                        color:
                                            AppColors.subText(isDark),
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(

                                      schedule['lecturer'],

                                      style: TextStyle(
                                        color:
                                            AppColors.subText(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      
                                      showEditScheduleModal(
                                        schedule,
                                        isDark,
                                      );
                                    },
                                    
                                    icon: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                    ),
                                  ),

                                  IconButton(

                                    onPressed: () {
                                      deleteSchedule(
                                        schedule['id'],
                                        schedule['subject'],
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