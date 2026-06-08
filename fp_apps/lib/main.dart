import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/theme_provider.dart';
import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(

    url: 'https://ejwkjdsqnerfxzweoryc.supabase.co',
    anonKey: 'sb_publishable_QchuDqnKXtAkQIMMNOHKCw_pg1XR0SB',
  );

  await NotificationService.initialize();

  runApp(

    ChangeNotifierProvider(

      create: (_) => ThemeProvider(),

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      themeMode:
          Provider.of<ThemeProvider>(context)
              .themeMode,

      // ================= LIGHT THEME =================

      theme: ThemeData(

        brightness: Brightness.light,

        scaffoldBackgroundColor:
            const Color(0xFFF6F7FB),

        fontFamily: 'Poppins',

        appBarTheme: const AppBarTheme(

          backgroundColor: Colors.transparent,

          elevation: 0,

          centerTitle: true,

          foregroundColor: Colors.black,
        ),
      ),

      // ================= DARK THEME =================

      darkTheme: ThemeData(

        brightness: Brightness.dark,

        scaffoldBackgroundColor:
            const Color(0xFF0F172A),

        fontFamily: 'Poppins',

        appBarTheme: const AppBarTheme(

          backgroundColor: Colors.transparent,

          elevation: 0,

          centerTitle: true,

          foregroundColor: Colors.white,
        ),
      ),

      home: const OnboardingScreen(),
    );
  }
}