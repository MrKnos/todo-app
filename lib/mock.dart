import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';

class Mock {
  static final tasksPagePresenter = TasksPagePresenter(
    workspaces: [
      WorkspacePresenter(
        title: 'Work',
        tasks: [
          TaskPresenter(
            title: 'Research todo apps',
            description: 'Minimum 4 applications',
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design wireframe for todo app',
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design Tasks page',
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design Task details modal sheet',
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design Input form',
            isCompleted: true,
            description: 'Input for create a new todo',
          ),
          TaskPresenter(
            title: 'Create todo app',
            description: 'Use Flutter',
            isCompleted: false,
          ),
        ],
      ),
      WorkspacePresenter(
        title: 'Personally',
        tasks: [
          TaskPresenter(
            title: 'Buy more foods',
            description: 'Buy eggs, fish and salad',
            isCompleted: false,
          ),
        ],
      ),
    ],
  );
}
