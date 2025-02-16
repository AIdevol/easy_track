part of 'create_task_view_bloc.dart';

@immutable
class CreateTaskViewState {
  final String taskName;
  final String taskDescription;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final TaskPriority priority;
  final List<TaskCategory> categories;
  final bool hasReminder;
  final double progress;
  final List<String> subtasks;
  final bool isSubmitting;
  final String? error;

  const CreateTaskViewState({
    this.taskName = '',
    this.taskDescription = '',
    this.dueDate,
    this.dueTime,
    this.priority = TaskPriority.medium,
    this.categories = const [],
    this.hasReminder = false,
    this.progress = 0,
    this.subtasks = const [],
    this.isSubmitting = false,
    this.error,
  });

  CreateTaskViewState copyWith({
    String? taskName,
    String? taskDescription,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TaskPriority? priority,
    List<TaskCategory>? categories,
    bool? hasReminder,
    double? progress,
    List<String>? subtasks,
    bool? isSubmitting,
    String? error,
  }) {
    return CreateTaskViewState(
      taskName: taskName ?? this.taskName,
      taskDescription: taskDescription ?? this.taskDescription,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      categories: categories ?? this.categories,
      hasReminder: hasReminder ?? this.hasReminder,
      progress: progress ?? this.progress,
      subtasks: subtasks ?? this.subtasks,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  bool get isValid => taskName.isNotEmpty;
}
