import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/form/task_form_field_names.dart';
import 'package:todo_app/pages/todo_board/todo_board_page_presenter.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({
    required this.onSubmitForm,
    this.onDeleteTask,
    this.initialTask,
    Key? key,
  }) : super(key: key);

  final void Function(TaskPresenter) onSubmitForm;
  final void Function()? onDeleteTask;
  final TaskPresenter? initialTask;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    _focusTaskTitleFieldWhenBuilt();
    final theme = context.read<ThemeCubit>().state;
    final textStyle = theme.material.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                FormBuilderTextField(
                  initialValue: widget.initialTask?.title,
                  style: textStyle.bodyText1,
                  name: TaskFormFieldNames.title,
                  decoration: InputDecoration(
                    label: Text('Task', style: textStyle.headline3),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  initialValue: widget.initialTask?.description,
                  style: textStyle.bodyText1,
                  autovalidateMode: AutovalidateMode.always,
                  name: TaskFormFieldNames.description,
                  decoration: InputDecoration(
                    label: Text('Description', style: textStyle.headline3),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (widget.initialTask != null) ...[
                ElevatedButton(
                  onPressed: widget.onDeleteTask,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text(
                    'Delete',
                    style: textStyle.button?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: () => _onSubmitTask(context),
                child: Text('OK', style: textStyle.button),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onSubmitTask(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final fields = _formKey.currentState?.value;

      if (fields != null) {
        final newTask = TaskPresenter.fromFormFields(fields);
        final updatedTask = widget.initialTask?.copyWith(
          title: newTask.title,
          description: newTask.description,
        );

        widget.onSubmitForm(updatedTask ?? newTask);
      }
    }
  }

  void _focusTaskTitleFieldWhenBuilt() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _formKey.currentState?.fields[TaskFormFieldNames.title]?.requestFocus();
    });
  }
}
