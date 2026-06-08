import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final supabase =
      Supabase.instance.client;

  // ================= LOGIN =================

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {

    final response =
        await supabase.auth
            .signInWithPassword(
      email: email,
      password: password,
    );

    final user =
        response.user;

    // CHECK EMAIL VERIFICATION
    if (user != null &&
        user.emailConfirmedAt ==
            null) {

      await supabase.auth
          .signOut();

      throw AuthException(
        'Please verify your email first',
      );
    }

    return response;
  }

  // ================= REGISTER =================

  Future<AuthResponse> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {

    // AUTH REGISTER
    final response =
        await supabase.auth
            .signUp(
      email: email,
      password: password,

      // SAVE TO AUTH METADATA
      data: {
        'full_name': fullName,
      },
    );

    // TAKE USER
    final user =
        response.user;

    // INSERT / UPDATE profiles TABLE
    if (user != null) {

      await supabase
          .from('profiles')
          .upsert({
        'id': user.id,
        'full_name':
            fullName,
        'email':
            email,
      });
    }

    return response;
  }

  // ================= LOGOUT =================

  Future<void> signOut() async {
    await supabase.auth
        .signOut();
  }
}