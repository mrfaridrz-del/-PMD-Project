import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleService {

  static final supabase =
      Supabase.instance.client;

  static Future<List<dynamic>>
      getTodaySchedules({
    required String day,
  }) async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return [];

      final data = await supabase
          .from('schedules')
          .select()
          .eq('user_id', user.id)
          .eq('day', day)
          .order('start_time');

      return data;

    } catch (e) {

      print(
        "ERRORSCHEDULES: $e",
      );

      return [];
    }
  }
}