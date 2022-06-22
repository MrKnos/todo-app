import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/pages/tasks/bloc/task_page_bloc.dart';
import 'package:todo_app/pages/tasks/tasks_page.dart';
import 'package:todo_app/themes/app_theme.dart';
import 'package:todo_app/themes/light_theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(theme: LightTheme()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'Todo App',
            themeMode: theme.mode,
            theme: theme.material,
            debugShowCheckedModeBanner: false,
            home: Container(
              color: Colors.amber,
              child: SafeArea(
                child: BlocProvider(
                  create: (context) => TaskPageBloc()..add(StartedEvent()),
                  child: const TasksPage(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
