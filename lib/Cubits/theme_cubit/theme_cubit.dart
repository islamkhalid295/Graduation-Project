import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Models/app_config.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeStateSystem());
  String currentTheme = 'system';

  void changeTheme(String themeMode) {
    if (themeMode == 'light') {
      currentTheme = 'light';
      emit(ThemeStateLight());
    } else if (themeMode == 'dark') {
      currentTheme = 'dark';
      emit(ThemeStateDark());
    } else if (themeMode == 'system') {
      currentTheme = 'system';
      emit(ThemeStateSystem());
    }
    UserConfig.setTheme(currentTheme);
  }
}
