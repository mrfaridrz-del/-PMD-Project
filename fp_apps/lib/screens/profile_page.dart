// ================= PROFILE PAGE =================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_colors.dart';
import 'appearance_page.dart';
import 'manage_profile_page.dart';

class ProfilePage extends StatefulWidget {

  final VoidCallback? onLogout;

  const ProfilePage({
    super.key,
    required this.onLogout,
  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  final supabase =
      Supabase.instance.client;

  late TextEditingController
      nameController;

  late TextEditingController
      emailController;

  late TextEditingController
      universityController;

  late TextEditingController
      majorController;

  late TextEditingController
      semesterController;

  late TextEditingController
      phoneController;

  late TextEditingController
      bioController;

  final Color primaryColor =
      AppColors.primary;

  // ================= INIT =================

  @override
  void initState() {

    super.initState();

    nameController =
        TextEditingController();

    emailController =
        TextEditingController();

    universityController =
        TextEditingController();

    majorController =
        TextEditingController();

    semesterController =
        TextEditingController();

    phoneController =
        TextEditingController();

    bioController =
        TextEditingController();

    loadProfile();
  }

  // ================= LOAD PROFILE =================

  Future<void> loadProfile() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) return;

      nameController.text =
          data['full_name'] ?? '';

      emailController.text =
          data['email'] ?? '';

      universityController.text =
          data['university'] ?? '';

      majorController.text =
          data['major'] ?? '';

      semesterController.text =
          data['semester'] ?? '';

      phoneController.text =
          data['phone'] ?? '';

      bioController.text =
          data['bio'] ?? '';

      setState(() {});

    } catch (e) {

      debugPrint(
        "ERROR LOAD PROFILE: $e",
      );
    }
  }

  // ================= CONTACT US =================

  Future<void> contactUs() async {

    final Uri emailUri = Uri(

      scheme: 'mailto',

      path: 'jmonsterkill@gmail.com',

      queryParameters: {

        'subject':
            'Student Study Planner Apps Support',

        'body':
            'Hello Admin,',
      },
    );

    if (await canLaunchUrl(emailUri)) {

      await launchUrl(emailUri);

    } else {

      debugPrint(
        "Could not launch email",
      );
    }
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

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // ================= TOP BAR =================

              Row(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.pop(context);
                    },

                    child: Container(

                      padding:
                          const EdgeInsets.all(10),

                      decoration: BoxDecoration(

                        color:
                            AppColors.card(isDark),

                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: Icon(

                        Icons.arrow_back_ios_new,

                        size: 18,

                        color:
                            AppColors.text(isDark),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(

                    "Profile",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors.text(isDark),
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(
                    width: 38,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // ================= PROFILE =================

              Center(

                child: Column(

                  children: [

                    Container(

                      padding:
                          const EdgeInsets.all(4),

                      decoration:
                          const BoxDecoration(

                        shape: BoxShape.circle,

                        gradient: LinearGradient(

                          colors: [

                            Color(0xFF8B5CF6),

                            Color(0xFF6366F1),
                          ],
                        ),
                      ),

                      child: CircleAvatar(

                        radius: 45,

                        backgroundColor:
                            AppColors.card(isDark),

                        child: const Icon(

                          Icons.person,

                          size: 50,

                          color:
                              Color(0xFF6366F1),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(

                      nameController.text.isEmpty
                          ? "Student Name"
                          : nameController.text,

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors.text(isDark),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(

                      emailController.text,

                      style: TextStyle(

                        color:
                            AppColors.subText(isDark),

                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (majorController
                        .text
                        .isNotEmpty)

                      Container(

                        padding:
                            const EdgeInsets.symmetric(

                          horizontal: 14,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(

                          color:
                              const Color(0xFF6366F1)
                                  .withOpacity(0.12),

                          borderRadius:
                              BorderRadius.circular(20),
                        ),

                        child: Text(

                          majorController.text,

                          style: const TextStyle(

                            color:
                                Color(0xFF6366F1),

                            fontWeight:
                                FontWeight.w600,

                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ================= MENU =================

              buildMenuTile(

                isDark: isDark,

                icon:
                    Icons.person_outline,

                title:
                    "Manage Profile",

                onTap: () async {

                  await Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          const ManageProfilePage(),
                    ),
                  );

                  await loadProfile();
                },
              ),

              buildMenuTile(

                isDark: isDark,

                icon:
                    Icons.dark_mode_outlined,

                title:
                    "Appearance",

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          const AppearancePage(),
                    ),
                  );
                },
              ),

              buildMenuTile(

                isDark: isDark,

                icon:
                    Icons.mail_outline_rounded,

                title:
                    "Contact Us",

                onTap: () {

                  contactUs();
                },
              ),

              const SizedBox(height: 25),

              // ================= LOGOUT =================

              SizedBox(

                width: double.infinity,

                child: OutlinedButton.icon(

                  style:
                      OutlinedButton.styleFrom(

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    side: const BorderSide(
                      color: Colors.red,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),

                  onPressed:
                      widget.onLogout ?? () {},

                  icon: const Icon(

                    Icons.logout,

                    color: Colors.red,
                  ),

                  label: const Text(

                    "Logout",

                    style: TextStyle(

                      color: Colors.red,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= MENU TILE =================

  Widget buildMenuTile({

    required bool isDark,

    required IconData icon,

    required String title,

    VoidCallback? onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),

        decoration: BoxDecoration(

          color:
              AppColors.card(isDark),

          borderRadius:
              BorderRadius.circular(22),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black.withOpacity(0.04),

              blurRadius: 10,
            ),
          ],
        ),

        child: ListTile(

          onTap: onTap,

          leading: Icon(

            icon,

            color:
                const Color(0xFF6366F1),
          ),

          title: Text(

            title,

            style: TextStyle(

              fontWeight:
                  FontWeight.w600,

              color:
                  AppColors.text(isDark),
            ),
          ),

          trailing: Icon(

            Icons.arrow_forward_ios,

            size: 16,

            color:
                AppColors.subText(isDark),
          ),
        ),
      ),
    );
  }
}