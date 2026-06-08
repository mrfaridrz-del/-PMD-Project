import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/schedule_service.dart';
import '../utils/app_colors.dart';
import '../services/notification_service.dart';
import 'schedule_page.dart';

class HomePage extends StatefulWidget {
  final Color primaryColor;
  final String fullName;

  const HomePage({
    super.key,
    required this.primaryColor,
    required this.fullName,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {

  final supabase =
      Supabase.instance.client;

  List schedules = [];

  List tasks = [];

  List exams = [];

  int totalExams = 0;

  

  // ================= INIT =================

  @override
  void initState() {

    super.initState();

    fetchSchedules();

    fetchTasks();

    fetchExams();
  }

  // ================= MONTH NAME =================

  String _getMonthName(int month) {

    const months = [

      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[month - 1];
  }

  // ================= DAY NAME =================

  String _getDayName(int weekday) {

    const days = [

      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return days[weekday - 1];
  }

  // ================= FETCH SCHEDULES =================

  Future<void> fetchSchedules() async {

    final today =
        DateTime.now();

    final selectedDay =
        _getDayName(
      today.weekday,
    );

    final data =
        await ScheduleService
            .getTodaySchedules(
      day: selectedDay,
    );

    setState(() {

      schedules = data;
    });
  }

  // ================= FETCH TASKS =================

  Future<void> fetchTasks() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('tasks')
          .select()
          .eq('user_id', user.id);

      setState(() {

        tasks = data;
      });

    } catch (e) {

      debugPrint(
        "ERROR TASKS: $e",
      );
    }
  }

  // ================= FETCH EXAMS =================

  Future<void> fetchExams() async {

    try {

      final user =
          supabase.auth.currentUser;

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

        totalExams =
            data.length;
      });

    } catch (e) {

      debugPrint(
        "ERROR FETCH EXAMS: $e",
      );
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    final now =
        DateTime.now();

    final completedTasks =
        tasks.where(
      (task) =>
          task['is_done'] ==
          true,
    ).toList();

    final pendingTasks =
        tasks.where(
      (task) =>
          task['is_done'] ==
          false,
    ).toList();

    final totalTasks =
        tasks.length;

    final progress =
        totalTasks == 0
            ? 0.0
            : completedTasks
                    .length /
                totalTasks;

    return Scaffold(

      backgroundColor:
          AppColors.background(
        isDark,
      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            // ================= HEADER =================

            Container(

              width:
                  double.infinity,

              decoration:
                  const BoxDecoration(

                color:
                    Color(
                  0xFF4F46E5,
                ),

                borderRadius:
                    BorderRadius.only(

                  bottomLeft:
                      Radius.circular(
                    35,
                  ),

                  bottomRight:
                      Radius.circular(
                    35,
                  ),
                ),
              ),

              child: Stack(

                children: [

                  Positioned(

                    right: -20,
                    top: -10,

                    child: Container(

                      width: 120,
                      height: 120,

                      decoration:
                          BoxDecoration(

                        color: Colors
                            .white
                            .withOpacity(
                          0.15,
                        ),

                        shape:
                            BoxShape
                                .circle,
                      ),
                    ),
                  ),

                  Padding(

                    padding:
                        const EdgeInsets
                            .fromLTRB(
                      24,
                      20,
                      24,
                      30,
                    ),

                    child: Column(

                      children: [

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  "Good Morning, ${widget.fullName.isEmpty ? 'Student' : widget.fullName}!",

                                  style:
                                      const TextStyle(

                                    fontSize:
                                        24,

                                    fontWeight:
                                        FontWeight
                                            .w700,

                                    color:
                                        Colors
                                            .white,
                                  ),
                                ),

                                const SizedBox(
                                  height: 6,
                                ),

                                const Text(

                                  "Ready to study today?",

                                  style:
                                      TextStyle(

                                    fontSize:
                                        14,

                                    color:
                                        Colors
                                            .white,
                                  ),
                                ),
                              ],
                            ),

                            CircleAvatar(

                              radius: 24,

                              backgroundColor:
                                  Colors
                                      .white,

                              child: Icon(

                                Icons
                                    .notifications_none,

                                color: widget
                                    .primaryColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 50,
                        ),

                        // ================= PROGRESS CARD =================

                        Container(

                          width:
                              double.infinity,

                          constraints:
                              const BoxConstraints(
                            minHeight:
                                150,
                          ),

                          decoration:
                              BoxDecoration(

                            color:
                                AppColors.card(
                              isDark,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              28,
                            ),
                          ),

                          child: Padding(

                            padding:
                                const EdgeInsets
                                    .all(
                              18,
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  "Today's Progress",

                                  style:
                                      TextStyle(

                                    fontSize:
                                        14,

                                    color:
                                        AppColors
                                            .subtitle(
                                      isDark,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 14,
                                ),

                                Text(

                                  "${(progress * 100).toInt()}%",

                                  style:
                                      TextStyle(

                                    fontSize:
                                        34,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    color:
                                        AppColors
                                            .text(
                                      isDark,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Text(

                                  "${completedTasks.length} of $totalTasks tasks completed",

                                  style:
                                      TextStyle(

                                    fontSize:
                                        18,

                                    fontWeight:
                                        FontWeight
                                            .w600,

                                    color:
                                        AppColors
                                            .text(
                                      isDark,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                ClipRRect(

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    20,
                                  ),

                                  child:
                                      LinearProgressIndicator(

                                    value:
                                        progress,

                                    minHeight:
                                        8,

                                    backgroundColor:
                                        Colors.grey
                                            .shade300,

                                    valueColor:
                                        AlwaysStoppedAnimation(
                                      widget
                                          .primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= BODY =================

            Padding(

              padding:
                  const EdgeInsets.all(
                24,
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  // ================= DATE =================

                  Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(

                        "${now.day} ${_getMonthName(now.month)} ${now.year}",

                        style: TextStyle(

                          fontSize: 28,

                          fontWeight:
                              FontWeight
                                  .bold,

                          color:
                              AppColors.text(
                            isDark,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(

                        _getDayName(
                          now.weekday,
                        ),

                        style: TextStyle(

                          fontSize: 16,

                          fontWeight:
                              FontWeight
                                  .w500,

                          color:
                              AppColors
                                  .subtitle(
                            isDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ================= TODAY OVERVIEW =================

                  Text(

                    "Today Overview",

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
                    height: 18,
                  ),

                  Row(

                    children: [

                      Expanded(

                        child:
                            _buildOverviewCard(

                          icon: Icons
                              .menu_book_rounded,

                          total:
                              schedules.length
                                  .toString(),

                          label:
                              "Classes",

                          color:
                              Colors.blue,

                          isDark:
                              isDark,
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(

                        child:
                            _buildOverviewCard(

                          icon: Icons
                              .task_alt_rounded,

                          total:
                              pendingTasks
                                  .length
                                  .toString(),

                          label:
                              "Tasks",

                          color:
                              Colors.green,

                          isDark:
                              isDark,
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(

                        child:
                            _buildOverviewCard(

                          icon: Icons
                              .notifications_active_rounded,

                          total:
                              totalExams
                                  .toString(),

                          label:
                              "Exams",

                          color:
                              Colors.red,

                          isDark:
                              isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  // ================= TODAY SCHEDULE =================

                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [

                      Text(

                        "Today's Schedule",

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

                      GestureDetector(

                        onTap: () async {

                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  const SchedulePage(),
                            ),
                          );

                          fetchSchedules();

                          fetchTasks();

                          fetchExams();
                        },

                        child: Text(

                          "View all",

                          style: TextStyle(

                            color: widget
                                .primaryColor,

                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  schedules.isEmpty

                      ? Center(

                          child: Padding(

                            padding:
                                const EdgeInsets
                                    .all(
                              20,
                            ),

                            child: Text(

                              "No schedule for today",

                              style:
                                  TextStyle(

                                color:
                                    AppColors
                                        .subtitle(
                                  isDark,
                                ),
                              ),
                            ),
                          ),
                        )

                      : Column(

                          children:
                              schedules.map(
                            (schedule) {

                              return Padding(

                                padding:
                                    const EdgeInsets
                                        .only(
                                  bottom: 14,
                                ),

                                child:
                                    _buildScheduleCard(

                                  title:
                                      schedule[
                                          'subject'],

                                  time:
                                      "${schedule['start_time']} - ${schedule['end_time']}",

                                  color:
                                      widget
                                          .primaryColor,

                                  isDark:
                                      isDark,
                                ),
                              );
                            },
                          ).toList(),
                        ),

                  const SizedBox(
                    height: 32,
                  ),

                  // ================= UPCOMING EXAMS =================

                  Text(

                    "Upcoming Exams",

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
                    height: 18,
                  ),

                  SizedBox(

                    height: 170,

                    child: exams.isEmpty

                        ? Center(

                            child: Text(

                              "No upcoming exams",

                              style:
                                  TextStyle(

                                color:
                                    AppColors
                                        .subtitle(
                                  isDark,
                                ),
                              ),
                            ),
                          )

                        : ListView.builder(

                            scrollDirection:
                                Axis.horizontal,

                            itemCount:
                                exams.length,

                            itemBuilder:
                                (
                              context,
                              index,
                            ) {

                              final exam =
                                  exams[index];

                              return Container(

                                width: 240,

                                margin:
                                    const EdgeInsets
                                        .only(
                                  right: 16,
                                ),

                                padding:
                                    const EdgeInsets
                                        .all(
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

                                  boxShadow: [

                                    BoxShadow(

                                      color: Colors
                                          .black
                                          .withOpacity(
                                        0.04,
                                      ),

                                      blurRadius:
                                          10,
                                    ),
                                  ],
                                ),

                                child: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(

                                      exam['subject'] ??
                                          "-",

                                      style:
                                          TextStyle(

                                        fontSize:
                                            20,

                                        fontWeight:
                                            FontWeight.bold,

                                        color:
                                            AppColors.text(
                                          isDark,
                                        ),
                                      ),
                                    ),

                                    const Spacer(),

                                    Row(

                                      children: [

                                        Icon(

                                          Icons
                                              .calendar_month,

                                          size: 18,

                                          color: widget
                                              .primaryColor,
                                        ),

                                        const SizedBox(
                                          width: 6,
                                        ),

                                        Text(
                                          exam[
                                                  'exam_date']
                                              .toString(),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Text(

                                      exam['room'] ??
                                          "-",

                                      style:
                                          TextStyle(

                                        color:
                                            AppColors.subtitle(
                                          isDark,
                                        ),
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
          ],
        ),
      ),
    );
  }

  // ================= OVERVIEW CARD =================

  Widget _buildOverviewCard({

    required IconData icon,

    required String total,

    required String label,

    required Color color,

    required bool isDark,
  }) {

    return Container(

      padding:
          const EdgeInsets.symmetric(
        vertical: 18,
      ),

      decoration: BoxDecoration(

        color:
            AppColors.card(
          isDark,
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: [

          BoxShadow(

            color: Colors.black
                .withOpacity(
              0.04,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(

        children: [

          Icon(
            icon,
            color: color,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            total,

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
            height: 4,
          ),

          Text(

            label,

            style: TextStyle(

              fontSize: 13,

              color:
                  AppColors.subtitle(
                isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SCHEDULE CARD =================

  Widget _buildScheduleCard({

    required String title,

    required String time,

    required Color color,

    required bool isDark,
  }) {

    return Container(

      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        18,
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

        boxShadow: [

          BoxShadow(

            color: Colors.black
                .withOpacity(
              0.04,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Row(

        children: [

          Container(

            width: 10,
            height: 52,

            decoration:
                BoxDecoration(

              color: color,

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  title,

                  style: TextStyle(

                    fontSize: 16,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        AppColors.text(
                      isDark,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(

                  time,

                  style: TextStyle(

                    fontSize: 13,

                    color:
                        AppColors
                            .subtitle(
                      isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}