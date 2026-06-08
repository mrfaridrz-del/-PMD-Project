import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class DatabaseService {

  final supabase = Supabase.instance.client;

  Future<List<TaskModel>> getTasks() async {

    final response = await supabase
        .from('tasks')
        .select()
        .order('created_at');

    return response
        .map<TaskModel>((e) => TaskModel.fromJson(e))
        .toList();
  }

  Future<void> addTask(TaskModel task) async {
    await supabase.from('tasks').insert(task.toJson());
  }

  Future<void> updateTask(
    String id,
    Map<String, dynamic> data,
  ) async {

    await supabase
        .from('tasks')
        .update(data)
        .eq('id', id);
  }

  Future<void> deleteTask(String id) async {

    await supabase
        .from('tasks')
        .delete()
        .eq('id', id);
  }
}