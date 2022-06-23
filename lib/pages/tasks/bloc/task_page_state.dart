part of 'task_page_bloc.dart';

@immutable
abstract class TaskPageState {}

class InitialState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({
    required this.workspaces,
  }) : presenter = TasksPagePresenter.fromModel(workspaces: workspaces);

  final List<Workspace> workspaces;
  final TasksPagePresenter presenter;
}
