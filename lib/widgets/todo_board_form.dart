import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/form/todo_board_form_field_names.dart';
import 'package:todo_app/pages/todo_board/todo_board_page_presenter.dart';

class TodoBoardForm extends StatefulWidget {
  const TodoBoardForm({
    required this.onSubmitForm,
    this.initialTodoBoard,
    this.onDeleteTodoBoard,
    Key? key,
  }) : super(key: key);

  final void Function(TodoBoardPagePresenter) onSubmitForm;
  final void Function()? onDeleteTodoBoard;
  final TodoBoardPagePresenter? initialTodoBoard;

  @override
  State<TodoBoardForm> createState() => _TodoBoardFormState();
}

class _TodoBoardFormState extends State<TodoBoardForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    _focusTodoBoardNameFieldWhenBuilt();
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
                  initialValue: widget.initialTodoBoard?.name,
                  style: textStyle.bodyText1,
                  name: TodoBoardFormFieldNames.name,
                  decoration: InputDecoration(
                    label: Text('Todo Board', style: textStyle.headline3),
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
              if (widget.initialTodoBoard != null) ...[
                ElevatedButton(
                  onPressed: widget.onDeleteTodoBoard,
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
                onPressed: () => _onSubmitTodoBoardForm(context),
                child: Text('OK', style: textStyle.button),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onSubmitTodoBoardForm(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final fields = _formKey.currentState?.value;

      if (fields != null) {
        final newBoard = TodoBoardPagePresenter.fromFormFields(fields);
        final updatedBoard = widget.initialTodoBoard?.copyWith(
          name: newBoard.name,
        );

        widget.onSubmitForm(updatedBoard ?? newBoard);
      }
    }
  }

  void _focusTodoBoardNameFieldWhenBuilt() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _formKey.currentState?.fields[TodoBoardFormFieldNames.name]
          ?.requestFocus();
    });
  }
}
