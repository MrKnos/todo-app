import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/form/workspace_form_field_names.dart';
import 'package:todo_app/models/workspace.dart';

class WorkspaceForm extends StatefulWidget {
  const WorkspaceForm({
    required this.onSubmitForm,
    this.initialWorkspace,
    this.onDeleteWorkspace,
    Key? key,
  }) : super(key: key);

  final void Function(Workspace) onSubmitForm;
  final void Function()? onDeleteWorkspace;
  final Workspace? initialWorkspace;

  @override
  State<WorkspaceForm> createState() => _WorkspaceFormState();
}

class _WorkspaceFormState extends State<WorkspaceForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSubmitWorkspaceForm(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final fields = _formKey.currentState?.value;

      if (fields != null) {
        final newWorkspace = Workspace.fromFormFields(fields);
        final updatedWorkspace = widget.initialWorkspace?.copyWith(
          name: newWorkspace.name,
        );

        widget.onSubmitForm(updatedWorkspace ?? newWorkspace);
      }
    }
  }

  void _focusWorkspaceNameFieldWhenBuilt() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _formKey.currentState?.fields[WorkspaceFormFieldNames.name]
          ?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    _focusWorkspaceNameFieldWhenBuilt();
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
                  initialValue: widget.initialWorkspace?.name,
                  style: textStyle.bodyText1,
                  name: WorkspaceFormFieldNames.name,
                  decoration: InputDecoration(
                    label: Text('Workspace', style: textStyle.headline3),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.required(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (widget.initialWorkspace != null) ...[
                ElevatedButton(
                  onPressed: widget.onDeleteWorkspace,
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
                onPressed: () => _onSubmitWorkspaceForm(context),
                child: Text('OK', style: textStyle.button),
              ),
            ],
          )
        ],
      ),
    );
  }
}
