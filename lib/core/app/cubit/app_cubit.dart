import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  static AppCubit of(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  /// 🔹 Toggle between light and dark
  void toggleTheme(bool isDark) => emit(state.copyWith(isDarkMode: isDark));

  /// 🔹 Toggle between English and Arabic
  void toggleLanguage(bool isEnglish) =>
      emit(state.copyWith(isEnglish: isEnglish));

  /// 🔹 Set theme manually
  void setTheme(bool darkMode) => emit(state.copyWith(isDarkMode: darkMode));

  /// 🔹 Set language manually
  void setLanguage(bool english) => emit(state.copyWith(isEnglish: english));

  /// 🔹 Change current page index
  void changePage(int index) => emit(state.copyWith(selectedPageIndex: index));
}
