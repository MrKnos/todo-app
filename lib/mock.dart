import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo_board.dart';

class Mock {
  static final todoBoards = [
    TodoBoard(
      id: '0',
      name: 'Work',
      tasks: [
        Task(
          id: '0',
          title: 'Research todo apps',
          description: 'Minimum 4 applications',
          isCompleted: true,
        ),
        Task(
          id: '1',
          title: 'Design wireframe for todo app',
          isCompleted: true,
        ),
        Task(
          id: '2',
          title: 'Design Tasks page',
          isCompleted: true,
        ),
        Task(
          id: '3',
          title: 'Design Task details modal sheet',
          isCompleted: true,
        ),
        Task(
          id: '4',
          title: 'Design Input form',
          isCompleted: true,
          description: 'For create a new todo',
        ),
        Task(
          id: '5',
          title: 'Create todo app',
          description: 'Use Flutter',
          isCompleted: false,
        ),
      ],
    ),
    TodoBoard(
      id: '1',
      name: 'Personally',
      tasks: [
        Task(
          id: '0',
          title: 'Buy more foods',
          description: 'Buy eggs, fish and salad',
          isCompleted: false,
        ),
      ],
    ),
  ];
}
