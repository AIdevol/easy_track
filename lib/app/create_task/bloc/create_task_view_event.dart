// create_task_view_event.dart
part of 'create_task_view_bloc.dart';

@immutable
sealed class CreateTaskViewEvent {}

class TaskNameChanged extends CreateTaskViewEvent {
  final String name;
  TaskNameChanged(this.name);
}

class TaskDescriptionChanged extends CreateTaskViewEvent {
  final String description;
  TaskDescriptionChanged(this.description);
}

class TaskDueDateChanged extends CreateTaskViewEvent {
  final DateTime? dueDate;
  TaskDueDateChanged(this.dueDate);
}

class TaskDueTimeChanged extends CreateTaskViewEvent {
  final TimeOfDay? dueTime;
  TaskDueTimeChanged(this.dueTime);
}

class TaskPriorityChanged extends CreateTaskViewEvent {
  final TaskPriority priority;
  TaskPriorityChanged(this.priority);
}

class TaskCategoryToggled extends CreateTaskViewEvent {
  final TaskCategory category;
  TaskCategoryToggled(this.category);
}

class TaskReminderToggled extends CreateTaskViewEvent {
  final bool hasReminder;
  TaskReminderToggled(this.hasReminder);
}

class TaskProgressChanged extends CreateTaskViewEvent {
  final double progress;
  TaskProgressChanged(this.progress);
}

class SubtaskAdded extends CreateTaskViewEvent {
  final String subtask;
  SubtaskAdded(this.subtask);
}

class SubtaskRemoved extends CreateTaskViewEvent {
  final int index;
  SubtaskRemoved(this.index);
}

class CreateTaskSubmitted extends CreateTaskViewEvent {}
