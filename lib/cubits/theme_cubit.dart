import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/themes/app_theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit({
    required AppTheme theme,
  }) : super(theme);

  void changeTheme(AppTheme theme) {
    emit(theme);
  }
}
