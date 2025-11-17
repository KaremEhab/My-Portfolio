import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_portfolio/core/app/constants.dart';
import 'package:my_portfolio/core/app/cubit/app_cubit.dart';
import 'package:my_portfolio/core/widgets.dart';
import 'package:my_portfolio/screens/naviagtion/widgets/sidebar_items.dart';
import 'package:my_portfolio/screens/naviagtion/widgets/theme_language_switcher.dart';
import 'package:my_portfolio/screens/naviagtion/widgets/hire_me_card.dart';

class Sidebar extends StatefulWidget {
  // 🔥 FIX: Add required callback parameter
  const Sidebar({super.key, required this.onPageSelected});

  final void Function(int) onPageSelected;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final bool cmdOrCtrlPressed =
        HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;
    if (cmdOrCtrlPressed && event.logicalKey == LogicalKeyboardKey.keyF) {
      _searchFocusNode.requestFocus();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
      child: Container(
        width: sidebarWidth,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.3),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.2),
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/my-logo.svg',
                      color: theme.colorScheme.onSurface,
                      height: 35,
                      width: 35,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kareem Ehab", style: theme.textTheme.titleMedium),
                        Text(
                          "Design Driven Development",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 40,
                  child: CustomTextField(
                    controller: searchController,
                    hint: "Search",
                    icon: IconlyLight.search,
                    focusNode: _searchFocusNode,
                  ),
                ),
                const SizedBox(height: 15),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    // final cubit = AppCubit.of(context); // Not needed here
                    return SidebarItems(
                      selectedIndex: state.selectedPageIndex,
                      // 🔥 FIX: Call widget.onPageSelected instead of cubit.changePage
                      onItemSelected: widget.onPageSelected,
                    );
                  },
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HireMeCard(),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    final cubit = AppCubit.of(context);
                    return ThemeLanguageSwitcher(
                      isDarkMode: state.isDarkMode,
                      isEnglish: state.isEnglish,
                      onThemeChanged: cubit.toggleTheme,
                      onLanguageChanged: cubit.toggleLanguage,
                    );
                  },
                ),
                Text(
                  "© 2025 Kareem Ehab, All rights reserved.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
