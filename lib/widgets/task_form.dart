import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_form.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({
    required this.onFormSubmitted,
    Key? key,
  }) : super(key: key);

  final void Function(Task) onFormSubmitted;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSubmitTask(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final fields = _formKey.currentState?.value;

      if (fields != null) {
        widget.onFormSubmitted(Task.fromFormFields(fields));
      }
    }
  }

  void _focusTaskFieldWhenBuilt() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _formKey.currentState?.fields[TaskFormFieldNames.title]?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    _focusTaskFieldWhenBuilt();
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
}
