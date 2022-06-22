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
            dueDate: DateTime.now().add(const Duration(days: 1)),
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design wireframe for todo app',
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design Tasks page',
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design Task details modal sheet',
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isCompleted: true,
          ),
          TaskPresenter(
            title: 'Design Input form',
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isCompleted: true,
            description: 'Input for create a new todo',
          ),
          TaskPresenter(
            title: 'Create todo app',
            description: 'Use Flutter',
            dueDate: DateTime.now().add(const Duration(days: 2)),
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
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isCompleted: false,
          ),
        ],
      ),
    ],
  );
}
