import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final TextEditingController
      emailController =
      TextEditingController();

  final supabase =
      Supabase.instance.client;

  bool isLoading = false;

  Future<void> resetPassword() async {

  try {

    setState(() {
      isLoading = true;
    });

    await supabase.auth
        .resetPasswordForEmail(

      emailController.text.trim(),
    );

    if (context.mounted) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Password reset email sent",
          ),
        ),
      );
    }

  } catch (e) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(e.toString()),
      ),
    );

  } finally {

    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Forgot Password",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(24),

        child: Column(

          children: [

            TextField(

              controller:
                  emailController,

              decoration:
                  const InputDecoration(

                labelText: "Email",
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed:
                    isLoading
                        ? null
                        : resetPassword,

                child: isLoading

                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )

                    : const Text(
                        "Send Reset Email",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}