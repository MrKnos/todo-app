import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/pages/workspace/workspace_page_presenter.dart';

class TasksPagePresenter {
  TasksPagePresenter({
    required this.workspaces,
  });

  factory TasksPagePresenter.fromModel({
    required List<Workspace> workspaces,
  }) {
    return TasksPagePresenter(
      workspaces: workspaces.map(WorkspacePagePresenter.fromModel).toList(),
    );
  }

  final List<WorkspacePagePresenter> workspaces;
}
