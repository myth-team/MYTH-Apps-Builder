class TodoModel {
  final String title;
  final String description;
  final String priority;
  final DateTime dueDate;
  bool isCompleted;

  TodoModel({
    required this.title,
    this.description = '',
    this.priority = 'medium',
    DateTime? dueDate,
    this.isCompleted = false,
  }) : dueDate = dueDate ?? DateTime.now();
}