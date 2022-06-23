import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_form.dart';
import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/pages/page_scaffold.dart';
import 'package:todo_app/pages/tasks/bloc/task_page_bloc.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';
import 'package:todo_app/pages/workspace/bloc/workspace_page_body_bloc.dart'
    as page_body;
import 'package:todo_app/pages/workspace/workspace_page_body.dart';
import 'package:todo_app/widgets/modal_bottom_sheet.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSubmitCreateTask(
    BuildContext context, {
    required String workspaceId,
  }) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final fields = _formKey.currentState?.value;

      if (fields != null) {
        final task = Task.fromFormFields(fields);
        final bloc = context.read<TaskPageBloc>();

        bloc.add(TaskCreatedEvent(workspaceId: workspaceId, task: task));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskPageBloc, TaskPageState>(
      builder: (context, state) {
        if (state is LoadSuccessState) {
          return _buildLoadSuccess(
            context,
            presenter: state.presenter,
            workspaces: state.workspaces,
            workspaceBlocs: state.workspaceBlocs,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadSuccess(
    BuildContext context, {
    required TasksPagePresenter presenter,
    required List<Workspace> workspaces,
    required List<page_body.WorkspacePageBodyBloc> workspaceBlocs,
  }) {
    final theme = context.read<ThemeCubit>().state;
    final textStyle = theme.material.textTheme;

    return DefaultTabController(
      length: presenter.workspaces.length,
      child: Builder(builder: (context) {
        return PageScaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Tasks',
              style: textStyle.headline1?.copyWith(
                height: 2,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black,
                tabs: [
                  ...presenter.workspaces.map(
                    (workspace) => Tab(
                      child: Text(
                        workspace.name,
                        style: textStyle.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showTaskFormModalSheet(
              context,
              workspaces: workspaces,
            ),
            child: const Icon(Icons.add, size: 30),
          ),
          child: TabBarView(
            children: [
              ...workspaceBlocs.map(
                (bloc) => _buildWorkSpacePageBody(
                  context,
                  workspaceBloc: bloc,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWorkSpacePageBody(
    BuildContext context, {
    required page_body.WorkspacePageBodyBloc workspaceBloc,
  }) {
    return BlocProvider<page_body.WorkspacePageBodyBloc>.value(
      value: workspaceBloc,
      child: const WorkspacePageBody(),
    );
  }

  void _showTaskFormModalSheet(
    BuildContext context, {
    required List<Workspace> workspaces,
  }) {
    showAppModalBottomSheet(
      context,
      heightFactor: 0.68,
      child: _buildTaskCreatorForm(context, workspaces: workspaces),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _formKey.currentState?.fields[TaskFormFieldNames.title]?.requestFocus();
    });
  }

  Widget _buildTaskCreatorForm(
    BuildContext context, {
    required List<Workspace> workspaces,
  }) {
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
                onPressed: () {
                  final index = DefaultTabController.of(context)?.index ?? 0;

                  _onSubmitCreateTask(
                    context,
                    workspaceId: workspaces[index].id,
                  );
                },
                child: Text('OK', style: textStyle.button),
              ),
            ],
          )
        ],
      ),
    );
  }
}
