// ================= HEADER =================
import 'package:flutter/material.dart';
import 'stat_card.dart';

class ProfileHeader extends StatelessWidget {

  final String name;
  final String email;
  final int totalTasks;
  final int completedTasks;
  final double gpa;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.totalTasks,
    required this.completedTasks,
    required this.gpa,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(

        gradient: const LinearGradient(

          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(32),

        boxShadow: [

          BoxShadow(

            color:
                Colors.deepPurple
                    .withOpacity(0.25),

            blurRadius: 30,

            offset:
                const Offset(0, 12),
          ),
        ],
      ),

      child: Column(

        children: [

          // AVATAR

          Container(

            padding:
                const EdgeInsets.all(5),

            decoration: BoxDecoration(

              shape: BoxShape.circle,

              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),

            child: const CircleAvatar(

              radius: 50,

              backgroundColor:
                  Colors.white,

              child: Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF4F46E5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(

            name.isEmpty
                ? "Student Name"
                : name,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 28,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(

            email,

            style: const TextStyle(

              color: Colors.white70,

              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

          // STATS

          Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

            children: [

              StatCard(
                value: totalTasks.toString(),
                label: "Tasks",
              ),

              StatCard(
                value: completedTasks.toString(),
                label: "Done",
              ),

              StatCard(
                value: gpa.toString(),
                label: "GPA",
              ),
            ],
          ),
        ],
      ),
    );
  }
}