import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_colors.dart';
import 'home_page.dart';
import 'schedule_page.dart';
import 'task_page.dart';
import 'profile_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int currentIndex = 0;

  final supabase =
      Supabase.instance.client;

  String fullName = '';

  final Color primaryColor =
      const Color(0xFF4F46E5);

  @override
  void initState() {

    super.initState();

    loadUserProfile();
  }

  // ================= LOAD USER =================

  Future<void> loadUserProfile() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {

        setState(() {

          fullName =
              data['full_name'] ?? '';
        });
      }

    } catch (e) {

      debugPrint(
        "ERROR LOAD PROFILE: $e",
      );
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {

    await supabase.auth.signOut();

    if (!mounted) return;

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {

    final pages = [

      HomePage(
        primaryColor: primaryColor,
        fullName: fullName,
      ),

      const SchedulePage(),
      const TaskPage(),

      ProfilePage(
        onLogout: logout,
      ),
    ];

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;
          });
        },

        selectedItemColor:
            primaryColor,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Schedule",
          ),

        

          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Task",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}