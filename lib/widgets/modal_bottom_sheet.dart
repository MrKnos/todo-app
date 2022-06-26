import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/widgets/task_form.dart';
import 'package:todo_app/widgets/workspace_form.dart';

void showAppModalBottomSheet(
  BuildContext context, {
  required double heightFactor,
  required Widget child,
}) {
  final theme = context.read<ThemeCubit>().state;

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: theme.material.colorScheme.background,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) => FractionallySizedBox(
      heightFactor: heightFactor,
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 0.98,
        builder: (context, controller) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.material.colorScheme.background,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 4,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 32),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    ),
  );
}

void showWorkspaceFormModalSheet(
  BuildContext context, {
  required void Function(Workspace) onSubmitForm,
  void Function()? onDeleteWorkspace,
  Workspace? initialWorkspace,
}) {
  showAppModalBottomSheet(
    context,
    heightFactor: 0.6,
    child: WorkspaceForm(
      initialWorkspace: initialWorkspace,
      onSubmitForm: (workspace) {
        onSubmitForm(workspace);
        Navigator.pop(context);
      },
      onDeleteWorkspace: () {
        onDeleteWorkspace?.call();
        Navigator.pop(context);
      },
    ),
  );
}

void showTaskFormModalSheet(
  BuildContext context, {
  required void Function(Task) onSubmitForm,
  void Function()? onDeleteTask,
  Task? initialTask,
}) {
  showAppModalBottomSheet(
    context,
    heightFactor: 0.68,
    child: TaskForm(
      initialTask: initialTask,
      onDeleteTask: () {
        onDeleteTask?.call();
        Navigator.pop(context);
      },
      onSubmitForm: (task) {
        onSubmitForm(task);
        Navigator.pop(context);
      },
    ),
  );
}
