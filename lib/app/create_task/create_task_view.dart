import 'package:app_task/app/create_task/bloc/create_task_view_bloc.dart';
import 'package:app_task/constants/colors.dart';
import 'package:app_task/model/task_model.dart';
import 'package:app_task/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateTaskView extends StatelessWidget {
  const CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateTaskViewBloc(),
      child: const CreateTaskViewContent(),
    );
  }
}

class CreateTaskViewContent extends StatelessWidget {
  const CreateTaskViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTaskViewBloc, CreateTaskViewState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting != current.isSubmitting ||
          previous.error != current.error,
      listener: (context, state) {
        if (!state.isSubmitting && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        } else if (!state.isSubmitting && state.taskName.isEmpty) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: appColor,
        appBar: AppBar(
          backgroundColor: appColor,
          title: const Text("Create Task"),
          leading: IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TaskNameField(),
                SizedBox(height: 16),
                _TaskDescriptionField(),
                SizedBox(height: 16),
                _DateTimeSelector(),
                SizedBox(height: 16),
                _PrioritySelector(),
                SizedBox(height: 16),
                _CategorySelector(),
                SizedBox(height: 16),
                _ReminderSettings(),
                SizedBox(height: 16),
                _ProgressTracker(),
                SizedBox(height: 16),
                _SubtasksList(),
                SizedBox(height: 16),
                _IconSelector(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const _SaveButton(),
      ),
    );
  }
}

class _TaskNameField extends StatelessWidget {
  const _TaskNameField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) => previous.taskName != current.taskName,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomTextField(
            hintText: "Task Name",
            initialValue: state.taskName,
            onChanged: (value) {
              context.read<CreateTaskViewBloc>().add(TaskNameChanged(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a task name';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}

class _TaskDescriptionField extends StatelessWidget {
  const _TaskDescriptionField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) =>
          previous.taskDescription != current.taskDescription,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomTextField(
            hintText: "Task Description",
            initialValue: state.taskDescription,
            maxLines: 3,
            onChanged: (value) {
              context
                  .read<CreateTaskViewBloc>()
                  .add(TaskDescriptionChanged(value));
            },
          ),
        );
      },
    );
  }
}

class _DateTimeSelector extends StatelessWidget {
  const _DateTimeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) =>
          previous.dueDate != current.dueDate ||
          previous.dueTime != current.dueTime,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Due Date & Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        state.dueDate == null
                            ? 'Select Date'
                            : DateFormat('MMM dd, yyyy').format(state.dueDate!),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          context
                              .read<CreateTaskViewBloc>()
                              .add(TaskDueDateChanged(picked));
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        state.dueTime == null
                            ? 'Select Time'
                            : state.dueTime!.format(context),
                      ),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: state.dueTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          context
                              .read<CreateTaskViewBloc>()
                              .add(TaskDueTimeChanged(picked));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) => previous.priority != current.priority,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Priority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SegmentedButton<TaskPriority>(
                segments: const [
                  ButtonSegment(
                    value: TaskPriority.low,
                    label: Text('Low'),
                    icon: Icon(Icons.flag, color: Colors.green),
                  ),
                  ButtonSegment(
                    value: TaskPriority.medium,
                    label: Text('Medium'),
                    icon: Icon(Icons.flag, color: Colors.orange),
                  ),
                  ButtonSegment(
                    value: TaskPriority.high,
                    label: Text('High'),
                    icon: Icon(Icons.flag, color: Colors.red),
                  ),
                ],
                selected: {state.priority},
                onSelectionChanged: (selection) {
                  context
                      .read<CreateTaskViewBloc>()
                      .add(TaskPriorityChanged(selection.first));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.categories.map((category) {
                  return FilterChip(
                    label: Text(category.name),
                    selected: category.isSelected,
                    avatar: Icon(category.icon),
                    onSelected: (selected) {
                      context
                          .read<CreateTaskViewBloc>()
                          .add(TaskCategoryToggled(category));
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReminderSettings extends StatelessWidget {
  const _ReminderSettings();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) =>
          previous.hasReminder != current.hasReminder,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications),
              const SizedBox(width: 8),
              const Text(
                'Reminder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Switch(
                value: state.hasReminder,
                onChanged: (value) {
                  context
                      .read<CreateTaskViewBloc>()
                      .add(TaskReminderToggled(value));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressTracker extends StatelessWidget {
  const _ProgressTracker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) => previous.progress != current.progress,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: state.progress,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: '${state.progress.round()}%',
                      onChanged: (value) {
                        context
                            .read<CreateTaskViewBloc>()
                            .add(TaskProgressChanged(value));
                      },
                    ),
                  ),
                  Text('${state.progress.round()}%'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubtasksList extends StatelessWidget {
  const _SubtasksList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) => previous.subtasks != current.subtasks,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Subtasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddSubtaskDialog(context),
                  ),
                ],
              ),
              if (state.subtasks.isNotEmpty) ...[
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.subtasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.subtasks[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<CreateTaskViewBloc>()
                              .add(SubtaskRemoved(index));
                        },
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showAddSubtaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Subtask'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter subtask',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context
                      .read<CreateTaskViewBloc>()
                      .add(SubtaskAdded(controller.text));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _IconSelector extends StatelessWidget {
  const _IconSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Icon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 32,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // TODO: Implement icon selection in BLoC
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.star),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskViewBloc, CreateTaskViewState>(
      buildWhen: (previous, current) =>
          previous.isSubmitting != current.isSubmitting ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: state.isSubmitting || !state.isValid
                ? null
                : () {
                    context
                        .read<CreateTaskViewBloc>()
                        .add(CreateTaskSubmitted());
                  },
            child: state.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Create Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }
}
