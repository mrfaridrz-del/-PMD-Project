import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({
    super.key,
  });

  @override
  State<AppearancePage> createState() =>
      _AppearancePageState();
}

class _AppearancePageState
    extends State<AppearancePage> {

  final Color primaryColor =
      const Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:

          isDark
              ? const Color(0xFF0F172A)
              : const Color(0xFFF6F7FB),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor: Colors.transparent,

        iconTheme: IconThemeData(

          color:
              isDark
                  ? Colors.white
                  : Colors.black,
        ),

        title: Text(

          "Appearance",

          style: TextStyle(

            fontWeight: FontWeight.bold,

            color:
                isDark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(22),

        child: Column(

          children: [

            buildThemeTile(
              title: "Light Mode",
              subtitle:
                  "Bright and clean appearance",
              icon: Icons.light_mode_rounded,
              index: 0,
            ),

            buildThemeTile(
              title: "Dark Mode",
              subtitle:
                  "Comfortable for night usage",
              icon: Icons.dark_mode_rounded,
              index: 1,
            ),

            buildThemeTile(
              title: "System Default",
              subtitle:
                  "Follow device appearance",
              icon: Icons.phone_android_rounded,
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  // ================= THEME TILE =================

  Widget buildThemeTile({

    required String title,
    required String subtitle,
    required IconData icon,
    required int index,

  }) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final currentTheme =
        Provider.of<ThemeProvider>(
          context,
        ).themeMode;

    final isSelected =

        (index == 0 &&
            currentTheme ==
                ThemeMode.light)

        ||

        (index == 1 &&
            currentTheme ==
                ThemeMode.dark)

        ||

        (index == 2 &&
            currentTheme ==
                ThemeMode.system);

    return GestureDetector(

      onTap: () {

        if (index == 0) {

          Provider.of<ThemeProvider>(
            context,
            listen: false,
          ).setTheme(
            ThemeMode.light,
          );

        } else if (index == 1) {

          Provider.of<ThemeProvider>(
            context,
            listen: false,
          ).setTheme(
            ThemeMode.dark,
          );

        } else {

          Provider.of<ThemeProvider>(
            context,
            listen: false,
          ).setTheme(
            ThemeMode.system,
          );
        }
      },

      child: AnimatedContainer(

        duration:
            const Duration(milliseconds: 250),

        margin:
            const EdgeInsets.only(
          bottom: 18,
        ),

        padding:
            const EdgeInsets.all(20),

        decoration: BoxDecoration(

          color:

              isDark
                  ? const Color(0xFF1E293B)
                  : Colors.white,

          borderRadius:
              BorderRadius.circular(28),

          border: Border.all(

            color:

                isSelected
                    ? primaryColor
                    : isDark
                        ? Colors.white10
                        : Colors.grey.shade200,

            width:
                isSelected ? 2 : 1,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black.withOpacity(
                isDark ? 0.20 : 0.05,
              ),

              blurRadius: 16,

              offset:
                  const Offset(0, 8),
            ),
          ],
        ),

        child: Row(

          children: [

            // ================= ICON =================

            Container(

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color:

                    isSelected
                        ? primaryColor
                            .withOpacity(0.15)
                        : isDark
                            ? Colors.white10
                            : const Color(
                                0xFFEEF2FF,
                              ),

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Icon(

                icon,

                size: 28,

                color:

                    isSelected
                        ? primaryColor
                        : isDark
                            ? Colors.white70
                            : Colors.black87,
              ),
            ),

            const SizedBox(width: 18),

            // ================= TEXT =================

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style: TextStyle(

                      fontSize: 17,

                      fontWeight:
                          FontWeight.bold,

                      color:

                          isDark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(

                    subtitle,

                    style: TextStyle(

                      fontSize: 13,

                      color:

                          isDark
                              ? Colors.white60
                              : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // ================= CHECK =================

            AnimatedSwitcher(

              duration:
                  const Duration(
                milliseconds: 250,
              ),

              child: isSelected

                  ? Container(

                      key:
                          const ValueKey(true),

                      padding:
                          const EdgeInsets.all(
                        6,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            primaryColor,

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(

                        Icons.check,

                        color: Colors.white,

                        size: 18,
                      ),
                    )

                  : const SizedBox(
                      key:
                          ValueKey(false),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}