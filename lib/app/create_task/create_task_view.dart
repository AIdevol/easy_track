import 'package:app_task/app/create_task/bloc/create_task_view_bloc.dart';
import 'package:app_task/constants/colors.dart';
import 'package:app_task/app/create_task/model/task_model.dart';
import 'package:app_task/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../utilities/custom_container.dart';

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
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Create Task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: appColor,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(30),
            //   topRight: Radius.circular(30),
            // ),
          ),
          child: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(title: "Task Details"),
                  SizedBox(height: 16),
                  _TaskNameField(),
                  SizedBox(height: 16),
                  _TaskDescriptionField(),
                  SizedBox(height: 24),
                  SectionTitle(title: "Schedule"),
                  SizedBox(height: 16),
                  _DateTimeSelector(),
                  SizedBox(height: 24),
                  SectionTitle(title: "Task Properties"),
                  SizedBox(height: 16),
                  _PrioritySelector(),
                  SizedBox(height: 16),
                  _CategorySelector(),
                  SizedBox(height: 16),
                  _ReminderSettings(),
                  SizedBox(height: 16),
                  _ProgressTracker(),
                  SizedBox(height: 24),
                  SectionTitle(title: "Subtasks"),
                  SizedBox(height: 16),
                  _SubtasksList(),
                  SizedBox(height: 24),
                  SectionTitle(title: "Customize"),
                  SizedBox(height: 16),
                  _IconSelector(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const _SaveButton(),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
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
        return CustomTextField(
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
          prefixIcon: const Icon(Icons.title, color: Color(0xFF666666)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
        return CustomTextField(
          hintText: "Task Description",
          initialValue: state.taskDescription,
          maxLines: 3,
          onChanged: (value) {
            context
                .read<CreateTaskViewBloc>()
                .add(TaskDescriptionChanged(value));
          },
          prefixIcon: const Icon(Icons.description, color: Color(0xFF666666)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
        return CustomContainer(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.calendar_today, color: appColor),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Schedule',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: appColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          context
                              .read<CreateTaskViewBloc>()
                              .add(TaskDueDateChanged(picked));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: appColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: appColor.withOpacity(0.2)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 18,
                                color: Color(0xFF666666),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.dueDate == null
                                    ? 'Select Date'
                                    : DateFormat('MMM dd, yyyy').format(state.dueDate!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: state.dueTime ?? TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: appColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          context
                              .read<CreateTaskViewBloc>()
                              .add(TaskDueTimeChanged(picked));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: appColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: appColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18,
                              color: Color(0xFF666666),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.dueTime == null
                                  ? 'Select Time'
                                  : state.dueTime!.format(context),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
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
        return CustomContainer(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.flag, color: appColor),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Priority',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _PriorityOption(
                      label: 'Low',
                      isSelected: state.priority == TaskPriority.low,
                      color: Colors.green,
                      onTap: () {
                        context
                            .read<CreateTaskViewBloc>()
                            .add(TaskPriorityChanged(TaskPriority.low));
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PriorityOption(
                      label: 'Medium',
                      isSelected: state.priority == TaskPriority.medium,
                      color: Colors.orange,
                      onTap: () {
                        context
                            .read<CreateTaskViewBloc>()
                            .add(TaskPriorityChanged(TaskPriority.medium));
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PriorityOption(
                      label: 'High',
                      isSelected: state.priority == TaskPriority.high,
                      color: Colors.red,
                      onTap: () {
                        context
                            .read<CreateTaskViewBloc>()
                            .add(TaskPriorityChanged(TaskPriority.high));
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

class _PriorityOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _PriorityOption({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.flag,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
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
        return CustomContainer(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.category, color: appColor),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.categories.map((category) {
                  return FilterChip(
                    label: Text(
                      category.name,
                      style: TextStyle(
                        color: category.isSelected ? Colors.white : Colors.black,
                        fontWeight: category.isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    showCheckmark: false,
                    selected: category.isSelected,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    selectedColor: appColor,
                    avatar: Icon(
                      category.icon,
                      color: category.isSelected ? Colors.white : Colors.grey.shade700,
                      size: 18,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
        return CustomContainer(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.notifications,
                  color: appColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Reminder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Switch(
                value: state.hasReminder,
                activeColor: appColor,
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
        return CustomContainer(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.trending_up, color: appColor),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${state.progress.round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  activeTrackColor: appColor,
                  inactiveTrackColor: Colors.grey.withOpacity(0.2),
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                    elevation: 4,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: state.progress,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  onChanged: (value) {
                    context
                        .read<CreateTaskViewBloc>()
                        .add(TaskProgressChanged(value));
                  },
                ),
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
        return CustomContainer(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.check_box, color: appColor),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Subtasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: appColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    onPressed: () => _showAddSubtaskDialog(context),
                  ),
                ],
              ),
              if (state.subtasks.isEmpty) ...[
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.checklist,
                        size: 48,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No subtasks yet',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add subtasks to break down your task',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (state.subtasks.isNotEmpty) ...[
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.subtasks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Color(0xFF666666),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.subtasks[index],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            onPressed: () {
                              context
                                  .read<CreateTaskViewBloc>()
                                  .add(SubtaskRemoved(index));
                            },
                          ),
                        ],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter subtask',
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context
                      .read<CreateTaskViewBloc>()
                      .add(SubtaskAdded(controller.text));
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
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
