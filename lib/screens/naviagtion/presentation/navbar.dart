import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_portfolio/core/app/constants.dart';
import 'package:my_portfolio/core/app/cubit/app_cubit.dart';
import 'package:my_portfolio/core/widgets.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.onPageSelected});

  final void Function(int) onPageSelected;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  int selectedPageIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // Smooth duration
      vsync: this,
    );

    // Define the movement:
    // Begin: Offset(0, 2.0) means "200% down" (hidden below screen)
    // End: Offset.zero means "natural position"
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 2.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic, // Use a smooth curve for "bouncy" feel
            reverseCurve: Curves.easeInCubic,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    // -----------------------------------------------------------
    // 🛠️ ANIMATION LOGIC
    // -----------------------------------------------------------
    // If screen is small (Mobile), show the bottom nav (animate UP).
    // If screen is large (Desktop/Web), hide it (animate DOWN) to show sidebar.
    if (screenWidth < mobileBreakpoint) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    double navbarWidth = screenWidth >= 300 ? 400 : 300;

    final items = [
      {
        'outlined-icon': IconlyLight.home,
        'filled-icon': IconlyBold.home,
        'index': 0,
      },
      {
        'outlined-icon': IconlyLight.folder,
        'filled-icon': IconlyBold.folder,
        'index': 1,
      },
      {
        'outlined-icon': IconlyLight.work,
        'filled-icon': IconlyBold.work,
        'index': 2,
      },
      {
        'outlined-icon': IconlyLight.profile,
        'filled-icon': IconlyBold.profile,
        'index': 3,
      },
      {
        'outlined-icon': IconlyLight.user,
        'filled-icon': IconlyBold.user_2,
        'index': 4,
      },
      {
        'outlined-icon': IconlyLight.message,
        'filled-icon': IconlyBold.message,
        'index': 5,
      },
    ];

    final pages = [
      {'title': 'Home', 'index': 0},
      {'title': 'Projects', 'index': 1},
      {'title': 'Skills', 'index': 2},
      {'title': 'About Me', 'index': 3},
      {'title': 'Testimonials', 'index': 4},
      {'title': 'Contact Me', 'index': 5},
    ];

    // Wrap everything in SlideTransition
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              width: navbarWidth,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(200),
                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/images/my-logo.svg',
                    color: theme.colorScheme.onSurface,
                    height: 25,
                    width: 25,
                  ),
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      selectedPageIndex = state.selectedPageIndex;
                      return Material(
                        type: MaterialType.transparency,
                        child: Text(
                          pages[selectedPageIndex]['title'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                  // for (var item in pages)
                  //   BlocBuilder<AppCubit, AppState>(
                  //     builder: (context, state) {
                  // return IconButton(
                  //   onPressed: () =>
                  //       widget.onPageSelected(item['index'] as int),
                  //   icon: Icon(
                  //     state.selectedPageIndex == item['index']
                  //         ? item['filled-icon'] as IconData
                  //         : item['outlined-icon'] as IconData,
                  //     color: state.selectedPageIndex == item['index']
                  //         ? theme.colorScheme.primary
                  //         : theme.iconTheme.color,
                  //   ),
                  // );
                  //   },
                  // ),
                  IconButton(
                    onPressed: () {
                      showMenuDialog(
                        context,
                        widget.onPageSelected,
                        selectedPageIndex, // أرسلها هنا
                      );
                    },
                    icon: Icon(Icons.menu),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
