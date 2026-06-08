import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  final TextEditingController _nameController =
    TextEditingController();
    
  final TextEditingController _emailController =
    TextEditingController();

  final TextEditingController _passwordController =
    TextEditingController();

  bool _isPasswordVisible = false;

  final AuthService authService = AuthService();

  // colors
  final Color _primaryColor = const Color(0xFF4F46E5);
  final Color _darkTextColor = const Color(0xFF0F172A);
  final Color _bodyTextColor = const Color(0xFF475569);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _bgLight = const Color(0xFFF8FAFC);


  Future<void> registerUser() async {

  try {

    await authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      fullName: _nameController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Verification email sent. Your account will be usable after email verification.",
        ),
      ),
    );

     await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;
    Navigator.pop(context);


  } on AuthException catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message),
      ),
    );

  } catch (e) {

    debugPrint(e.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkTextColor),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            Text(
              "Create an Account",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: _darkTextColor,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Register to continue",
              style: TextStyle(
                color: _bodyTextColor,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            _label("Full Name"),
            _inputField(
              Icons.person_outline,
              "Enter your full name",
              controller: _nameController,
            ),

            const SizedBox(height: 24),

            _label("Email Address"),
            _inputField(
              Icons.email_outlined,
              "Enter your email",
              controller: _emailController,
            ),

            const SizedBox(height: 24),

            _label("Password"),
            _inputField(
              Icons.lock_outline,
              "Enter your password",
              isPassword: true,
              controller: _passwordController,
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: (){
                  registerUser();
                },

                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "Already have an account?",
                  style: TextStyle(color: _bodyTextColor),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),

      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _bodyTextColor,
        ),
      ),
    );
  }

  Widget _inputField(
  IconData icon,
  String hint, {
  bool isPassword = false,
  TextEditingController? controller,
}) {

  return Container(

    decoration: BoxDecoration(

      color: Colors.white,

      borderRadius:
          BorderRadius.circular(16),

      border: Border.all(

        color: _borderColor,
        width: 1.5,
      ),
    ),

    child: TextField(

      controller: controller,

      obscureText:
          isPassword && !_isPasswordVisible,

      style: TextStyle(
        color: _darkTextColor,
        fontSize: 15,
      ),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),

        prefixIcon: Icon(
          icon,
          color: _primaryColor,
        ),

        suffixIcon: isPassword

            ? IconButton(

                onPressed: () {

                  setState(() {

                    _isPasswordVisible =
                        !_isPasswordVisible;
                  });
                },

                icon: Icon(

                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,

                  color: Colors.grey,
                ),
              )

            : null,

        border: InputBorder.none,

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 18,
        ),
      ),
    ),
  );
}
}