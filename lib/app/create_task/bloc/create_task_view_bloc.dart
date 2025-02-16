import 'package:app_task/model/task_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'create_task_view_event.dart';
part 'create_task_view_state.dart';

class CreateTaskViewBloc
    extends Bloc<CreateTaskViewEvent, CreateTaskViewState> {
  CreateTaskViewBloc() : super(CreateTaskViewState()) {
    on<TaskNameChanged>(_onTaskNameChanged);
    on<TaskDescriptionChanged>(_onTaskDescriptionChanged);
    on<TaskDueDateChanged>(_onTaskDueDateChanged);
    on<TaskDueTimeChanged>(_onTaskDueTimeChanged);
    on<TaskPriorityChanged>(_onTaskPriorityChanged);
    on<TaskCategoryToggled>(_onTaskCategoryToggled);
    on<TaskReminderToggled>(_onTaskReminderToggled);
    on<TaskProgressChanged>(_onTaskProgressChanged);
    on<SubtaskAdded>(_onSubtaskAdded);
    on<SubtaskRemoved>(_onSubtaskRemoved);
    on<CreateTaskSubmitted>(_onCreateTaskSubmitted);
  }

  void _onTaskNameChanged(
      TaskNameChanged event, Emitter<CreateTaskViewState> emit) {
    emit(state.copyWith(taskName: event.name));
  }

  void _onTaskDescriptionChanged(
      TaskDescriptionChanged event, Emitter<CreateTaskViewState> emit) {
    emit(state.copyWith(taskDescription: event.description));
  }

  void _onTaskDueDateChanged(
      TaskDueDateChanged event, Emitter<CreateTaskViewState> emit) {
    emit(state.copyWith(dueDate: event.dueDate));
  }

  void _onTaskDueTimeChanged(
      TaskDueTimeChanged event, Emitter<CreateTaskViewState> emit) {
    emit(state.copyWith(dueTime: event.dueTime));
  }

  void _onTaskPriorityChanged(
      TaskPriorityChanged event, Emitter<CreateTaskViewState> emit) {
    emit(state.copyWith(priority: event.priority));
  }

  void _onTaskCategoryToggled(
      TaskCategoryToggled event, Emitter<CreateTaskViewState> emit) {
    final updatedCategories = List<TaskCategory>.from(state.categories);
    final index =
        updatedCategories.indexWhere((c) => c.name == event.category.name);

    if (index != -1) {
      updatedCategories[index] = TaskCategory(
        name: event.category.name,
        icon: event.category.icon,
        isSelected: !event.category.isSelected,
      );
    }

    emit(state.copyWith(categories: updatedCategories));
  }

  void _onTaskReminderToggled(
      TaskReminderToggled event, Emitter<CreateTaskViewState> emit) {
    emit(state.copyWith(hasReminder: event.hasReminder));
  }

  void _onTaskProgressChanged(
      TaskProgressChanged event, Emitter<CreateTaskViewState> emit) {
    emit(state.copyWith(progress: event.progress));
  }

  void _onSubtaskAdded(SubtaskAdded event, Emitter<CreateTaskViewState> emit) {
    final updatedSubtasks = List<String>.from(state.subtasks)
      ..add(event.subtask);
    emit(state.copyWith(subtasks: updatedSubtasks));
  }

  void _onSubtaskRemoved(
      SubtaskRemoved event, Emitter<CreateTaskViewState> emit) {
    final updatedSubtasks = List<String>.from(state.subtasks)
      ..removeAt(event.index);
    emit(state.copyWith(subtasks: updatedSubtasks));
  }

  Future<void> _onCreateTaskSubmitted(
      CreateTaskSubmitted event, Emitter<CreateTaskViewState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(error: 'Please fill in all required fields'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));

    try {
      // TODO: Implement task creation logic (e.g., API call or database operation)

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Success
      emit(CreateTaskViewState());
    } catch (error) {
      emit(state.copyWith(
        isSubmitting: false,
        error: 'Failed to create task: ${error.toString()}',
      ));
    }
  }
}
