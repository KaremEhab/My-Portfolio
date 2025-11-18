// lib/screens/naviagtion/presentation/sidebar.dart
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
  const Sidebar({super.key, required this.onPageSelected});

  final void Function(int) onPageSelected;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearchOpen = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // listen to the small sidebar search field:
    searchController.addListener(_onSmallSearchTyped);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    searchController.removeListener(_onSmallSearchTyped);
    searchController.dispose();
    _searchFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSmallSearchTyped() {
    final text = searchController.text;
    if (text.length == 1 && !_isSearchOpen) {
      final firstChar = text;
      // clear the small input so it doesn't remain there
      searchController.clear();
      // open the spotlight with initial query
      _openSpotlight(initialQuery: firstChar);
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final bool cmdOrCtrlPressed =
        HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;
    if (cmdOrCtrlPressed && event.logicalKey == LogicalKeyboardKey.keyF) {
      _openSpotlight();
      return true;
    }
    return false;
  }

  Future<void> _openSpotlight({String initialQuery = ''}) async {
    if (_isSearchOpen) return;
    _isSearchOpen = true;
    await showSpotlightSearch(context, initialQuery: initialQuery);
    _isSearchOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isMobile = screenWidth < mobileBreakpoint;
    final isTablet =
        screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint;

    // Animation Trigger Logic
    if (isMobile) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    final beginOffset = isRtl
        ? const Offset(1.0, 0.0)
        : const Offset(-1.0, 0.0);

    _offsetAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    double sidebarW;
    if (isMobile) {
      sidebarW = 0;
    } else if (isTablet) {
      sidebarW = 80;
    } else {
      sidebarW = sidebarWidth;
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          width: sidebarW,
          height: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.3),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.2),
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: ClipRect(
            child: OverflowBox(
              minWidth: sidebarW,
              maxWidth: sidebarW,
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: isTablet
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/my-logo.svg',
                              color: theme.colorScheme.onSurface,
                              height: 35,
                              width: 35,
                            ),
                            if (!isTablet) const SizedBox(width: 8),
                            if (!isTablet)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kareem Ehab",
                                    style: theme.textTheme.titleMedium,
                                  ),
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
                          width: double.infinity,
                          child: isTablet
                              ? IconButton(
                                  onPressed: () {
                                    // On tablet pressing the icon opens the spotlight
                                    _openSpotlight();
                                  },
                                  icon: Icon(IconlyLight.search),
                                  style: IconButton.styleFrom(
                                    side: BorderSide(
                                      color: lightPrimaryColor.withOpacity(0.4),
                                    ),
                                    backgroundColor: lightPrimaryColor
                                        .withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                              : CustomTextField(
                                  controller: searchController,
                                  hint: "Search",
                                  icon: IconlyLight.search,
                                  focusNode: _searchFocusNode,
                                  onChanged: (typed) {
                                    if (typed.isNotEmpty) {
                                      _openSpotlight(initialQuery: typed);
                                    }
                                  },
                                ),
                        ),
                        const SizedBox(height: 15),
                        BlocBuilder<AppCubit, AppState>(
                          builder: (context, state) {
                            return SidebarItems(
                              selectedIndex: state.selectedPageIndex,
                              onItemSelected: widget.onPageSelected,
                              isShrunk: isTablet,
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isTablet) const HireMeCard(),
                        BlocBuilder<AppCubit, AppState>(
                          builder: (context, state) {
                            final cubit = AppCubit.of(context);
                            return ThemeLanguageSwitcher(
                              isDarkMode: state.isDarkMode,
                              isEnglish: state.isEnglish,
                              onThemeChanged: cubit.toggleTheme,
                              onLanguageChanged: cubit.toggleLanguage,
                              isShrunk: isTablet,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isTablet
                              ? "© Karem"
                              : "© 2025 Kareem Ehab, All rights reserved.",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: theme.hintColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
