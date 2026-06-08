import 'package:flutter/material.dart';
import 'package:fp_apps/screens/forgot_password_screen.dart';
import 'package:fp_apps/screens/register_screen.dart';
import 'package:fp_apps/screens/dashboard_screen.dart';
import 'package:fp_apps/screens/onboarding_screen.dart';
import '../services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final TextEditingController emailController =
    TextEditingController();

  final TextEditingController passwordController =
    TextEditingController();
  
  final AuthService authService = AuthService();

Future<void> login() async {

  try {

    setState(() {
      _isLoading = true;
    });

    await authService.signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );

  } on AuthException catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message),
      ),
    );

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login failed"),
      ),
    );

  } finally {

    setState(() {
      _isLoading = false;
    });
  }
}

@override
void dispose() {

  emailController.dispose();
  passwordController.dispose();

  super.dispose();
}


  //color
  final Color _primaryColor = const Color(0xFF4F46E5);
  final Color _darkTextColor = const Color(0xFF0F172A);
  final Color _bodyTextColor = const Color(0xFF475569);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _bgLight = const Color(0xFFF8FAFC);
 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: Stack(
        children: [
          _BackgroundDecoration(color: _primaryColor),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(children: [
                      Column(
                        children: [
                          // BACK BUTTON
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const OnboardingScreen(),
                                  ),
                                );
                              },
                              
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: _darkTextColor,
                              ),
                            ),
                          ),
                          
                          _LoginHeader(
                            bodyColor: _bodyTextColor,
                            darkColor: _darkTextColor,
                          ),
                        ],
                      ),

                        
                        const SizedBox(height: 48),
                        _LoginFormFields(
                          primaryColor: _primaryColor,
                          darkColor: _darkTextColor,
                          bodyColor: _bodyTextColor,
                          borderColor: _borderColor,
                          isPasswordVisible: _isPasswordVisible,
                          emailController: emailController,
                          passwordController: passwordController,
                          onTogglePassword: () {
                            setState(() {
                              _isPasswordVisible =
                              !_isPasswordVisible;
                            });
                          },
                        ),


                        const SizedBox(height: 30),
                        _LoginButton(
                          btnColor: _darkTextColor,
                          isLoading: _isLoading,
                          onPressed: login,
                        ),

                        const SizedBox(height: 20),
                        

                        const SizedBox(height: 10),
                        _FooterSection(
                          primaryColor: _primaryColor, 
                          bodyColor: _bodyTextColor
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}



// widget box shape circle
class _BackgroundDecoration extends StatelessWidget {
  final Color color;
  const _BackgroundDecoration({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: _blob(280, color.withOpacity(0.08))),

        Positioned(
          bottom: -80,
          right: -60,
          child: _blob(230, color.withOpacity(0.12))),
      ],
    );
  }

  Widget _blob (double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}


// login header

class _LoginHeader extends StatelessWidget {
  final Color darkColor, bodyColor;
  const _LoginHeader({required this.darkColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70,),
        Text(
          "Welcome Back", 
          style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: darkColor,
          letterSpacing: -0.5
          ),
        ),

        const SizedBox(height: 70,),
        Text(
          "Enter your credentials to access your account", 
          style: TextStyle(fontSize: 16, color: bodyColor,height: 1.5),
        ),
      ],
    );
  }
}

class _LoginFormFields extends StatelessWidget {

  final Color primaryColor,
      darkColor,
      bodyColor,
      borderColor;

  final bool isPasswordVisible;

  final VoidCallback onTogglePassword;

  final TextEditingController emailController;

  final TextEditingController passwordController;

  const _LoginFormFields({
    required this.primaryColor,
    required this.darkColor,
    required this.bodyColor,
    required this.borderColor,
    required this.isPasswordVisible,
    required this.onTogglePassword,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        _label("Email Address"), 
        _inputField(
          Icons.mail_outline_rounded, 
          "Enter your email",
          controller: emailController,
          ),

        const SizedBox(height: 24),
        _label("Password"), 
        _inputField(
          Icons.lock_open_rounded, 
          "Enter your password", 
          controller: passwordController,
          
          isPassword: true,

          suffix: IconButton(
            onPressed: onTogglePassword, 

            icon: Icon(
              isPasswordVisible 
                ? Icons.visibility_rounded 
                : Icons.visibility_off_rounded, 
              size: 20, 
              color: bodyColor,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            }, 
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(
      bottom: 10,
      left: 4,
    ), 

    child: Text(
      text, 
      style: TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w700, 
        color: bodyColor.withOpacity(0.8),
      ),
    ),
  );

  Widget _inputField(
  IconData icon,
  String hint, {
  bool isPassword = false,
  Widget? suffix,
  TextEditingController? controller,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: darkColor.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,

      style: TextStyle(
        color: darkColor,
        fontWeight: FontWeight.w600,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          color: bodyColor.withOpacity(0.4),
          fontSize: 15,
        ),

        prefixIcon: Icon(
          icon,
          color: primaryColor,
          size: 22,
        ),

        suffixIcon: suffix,
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

// login button
class _LoginButton extends StatelessWidget {

  final Color btnColor;
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.btnColor,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 60,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),

          elevation: 0,
        ),

        onPressed:
            isLoading ? null : onPressed,

        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )

            : const Text(
                "Sign In",

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _SocialLoginSection extends StatefulWidget {
  final Color bodyColor, darkColor, borderColor;
  const _SocialLoginSection(this.bodyColor, this.darkColor, this.borderColor);

  @override
  State<_SocialLoginSection> createState() => _SocialLoginSectionState();
}

class _SocialLoginSectionState extends State<_SocialLoginSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "or continue with", 
            style: TextStyle(
              color: widget.bodyColor.withOpacity(0.7), 
              fontSize: 15, 
              fontWeight: FontWeight.w500
            ),
          ),
        ),

          const SizedBox(height: 18),
          Row(
            children: [
              _tile(
                "Google",
                "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/960px-Google_%22G%22_logo.svg.png?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=thumbnail"
              ),

              const SizedBox(width: 16),
              _tile(
                "Apple", 
                null, 
                icon: Icons.apple
              ),
            ],
          ),
      ],
    );
  }

  Widget _tile(String label, String? imgUrl, {IconData? icon}){
    return Expanded(
      child: Container(
        height: 58, 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.borderColor, width: 1.5),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imgUrl != null) Image.network(imgUrl, height: 18)
            else Icon(icon, size: 22, color: widget.darkColor),
            const SizedBox(width: 12),
            Text(
              label, 
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: widget.darkColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// widget footer
class _FooterSection extends StatelessWidget {
  final Color primaryColor, bodyColor;
  const _FooterSection({required this.primaryColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "New User?", 
          style: TextStyle(color: bodyColor)),

        TextButton(
          onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          }, 
          child: Text(
            "Create an Account", 
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}