// app_state.dart
part of 'app_cubit.dart';

class AppState {
  final bool isDarkMode;
  final bool isEnglish;
  final int selectedPageIndex;

  AppState({
    required this.isDarkMode,
    required this.isEnglish,
    required this.selectedPageIndex,
  });

  factory AppState.initial() => AppState(
    isDarkMode:
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark,
    isEnglish: true,
    selectedPageIndex: 0,
  );

  AppState copyWith({
    bool? isDarkMode,
    bool? isEnglish,
    int? selectedPageIndex,
  }) {
    return AppState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isEnglish: isEnglish ?? this.isEnglish,
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
    );
  }
}
