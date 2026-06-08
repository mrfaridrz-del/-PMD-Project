import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_colors.dart';

class ManageProfilePage extends StatefulWidget {
  const ManageProfilePage({
    super.key,
  });

  @override
  State<ManageProfilePage> createState() =>
      _ManageProfilePageState();
}

class _ManageProfilePageState
    extends State<ManageProfilePage> {
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

  late TextEditingController
      passwordController;

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

    passwordController =
        TextEditingController();

    loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    universityController.dispose();
    majorController.dispose();
    semesterController.dispose();
    phoneController.dispose();
    bioController.dispose();
    passwordController.dispose();

    super.dispose();
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
          .single();

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

  // ================= UPDATE PROFILE =================

  Future<void> updateProfile() async {
    try {
      final user =
          supabase.auth.currentUser;

      if (user == null) return;

      await supabase
          .from('profiles')
          .upsert({
        'id': user.id,

        'full_name':
            nameController.text,

        'email':
            emailController.text,

        'university':
            universityController.text,

        'major':
            majorController.text,

        'semester':
            semesterController.text,

        'phone':
            phoneController.text,

        'bio':
            bioController.text,
      });

      // ================= UPDATE PASSWORD =================

      if (passwordController
          .text
          .trim()
          .isNotEmpty) {
        await supabase.auth
            .updateUser(
          UserAttributes(
            password:
                passwordController
                    .text
                    .trim(),
          ),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Profile Updated"),
        ),
      );

      passwordController.clear();
    } catch (e) {
      debugPrint(
        "ERROR UPDATE PROFILE: $e",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // ================= TEXT FIELD =================

  Widget buildTextField({
    required bool isDark,
    required String label,
    required IconData icon,
    required TextEditingController
        controller,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),

      child: TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,

        style: TextStyle(
          color:
              AppColors.text(
            isDark,
          ),
        ),

        decoration: InputDecoration(
          labelText: label,

          labelStyle: TextStyle(
            color:
                AppColors.subText(
              isDark,
            ),
          ),

          prefixIcon: Icon(
            icon,
            color:
                const Color(
              0xFF6366F1,
            ),
          ),

          filled: true,

          fillColor:
              AppColors.card(
            isDark,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            borderSide: BorderSide(
              color: isDark
                  ? Colors.white10
                  : Colors.grey
                      .shade200,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),

            borderSide:
                const BorderSide(
              color:
                  Color(0xFF6366F1),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor:
          AppColors.background(
        isDark,
      ),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            Colors.transparent,

        centerTitle: true,

        iconTheme: IconThemeData(
          color:
              AppColors.text(
            isDark,
          ),
        ),

        title: Text(
          "Manage Profile",

          style: TextStyle(
            color:
                AppColors.text(
              isDark,
            ),

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          22,
        ),

        child: Column(
          children: [
            
            // ================= FORM =================

            buildTextField(
              isDark: isDark,
              label: "Full Name",
              icon:
                  Icons.person_outline,
              controller:
                  nameController,
            ),

            buildTextField(
              isDark: isDark,
              label: "Email",
              icon:
                  Icons.email_outlined,
              controller:
                  emailController,
            ),

            buildTextField(
              isDark: isDark,
              label: "University",
              icon:
                  Icons.school_outlined,
              controller:
                  universityController,
            ),

            buildTextField(
              isDark: isDark,
              label: "Major",
              icon:
                  Icons.menu_book_outlined,
              controller:
                  majorController,
            ),

            buildTextField(
              isDark: isDark,
              label: "Semester",
              icon: Icons
                  .calendar_month_outlined,
              controller:
                  semesterController,
            ),

            buildTextField(
              isDark: isDark,
              label: "Phone",
              icon:
                  Icons.phone_outlined,
              controller:
                  phoneController,
            ),

            buildTextField(
              isDark: isDark,
              label: "Bio",
              icon: Icons
                  .edit_note_outlined,
              controller:
                  bioController,
              maxLines: 3,
            ),

            buildTextField(
              isDark: isDark,
              label: "Change Password",
              icon:
                  Icons.lock_outline,
              controller:
                  passwordController,
              obscureText: true,
            ),

            const SizedBox(height: 24),

            // ================= SAVE BUTTON =================

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF6366F1,
                  ),

                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                onPressed: () async {
                  await updateProfile();
                },

                child: const Text(
                  "Save Profile",

                  style: TextStyle(
                    color:
                        Colors.white,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}