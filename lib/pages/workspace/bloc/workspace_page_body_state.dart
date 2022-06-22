part of 'workspace_page_body_bloc.dart';

@immutable
abstract class WorkspacePageBodyState {}

class InitialState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({
    required this.workspace,
  }) : presenter = WorkspacePagePresenter.fromModel(workspace);

  final Workspace workspace;
  final WorkspacePagePresenter presenter;
}
