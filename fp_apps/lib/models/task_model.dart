class TaskModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String dueDate;
  final String priority;
  final bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isDone,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      description: json['description'],
      dueDate: json['due_date'],
      priority: json['priority'],
      isDone: json['is_done'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subject': subject,
      'description': description,
      'due_date': dueDate,
      'priority': priority,
      'is_done': isDone,
    };
  }
}