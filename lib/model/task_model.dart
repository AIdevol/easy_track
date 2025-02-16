// models/task_models.dart

import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high }

class TaskCategory {
  final String name;
  final IconData icon;
  bool isSelected;

  TaskCategory({
    required this.name,
    required this.icon,
    this.isSelected = false,
  });

  // Copy with method for immutability
  TaskCategory copyWith({
    String? name,
    IconData? icon,
    bool? isSelected,
  }) {
    return TaskCategory(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // Equals operator for comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskCategory &&
        other.name == name &&
        other.icon == icon &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode => name.hashCode ^ icon.hashCode ^ isSelected.hashCode;
}

class Task {
  final String id;
  final String name;
  final String description;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final TaskPriority priority;
  final List<TaskCategory> categories;
  final bool hasReminder;
  final double progress;
  final List<String> subtasks;

  Task({
    required this.id,
    required this.name,
    this.description = '',
    this.dueDate,
    this.dueTime,
    this.priority = TaskPriority.medium,
    this.categories = const [],
    this.hasReminder = false,
    this.progress = 0,
    this.subtasks = const [],
  });

  // Copy with method for immutability
  Task copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TaskPriority? priority,
    List<TaskCategory>? categories,
    bool? hasReminder,
    double? progress,
    List<String>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      categories: categories ?? this.categories,
      hasReminder: hasReminder ?? this.hasReminder,
      progress: progress ?? this.progress,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}
