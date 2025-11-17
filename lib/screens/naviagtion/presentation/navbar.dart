import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_portfolio/core/app/cubit/app_cubit.dart';

class NavBar extends StatelessWidget {
  // 🔥 FIX: Add required callback parameter
  const NavBar({super.key, required this.onPageSelected});

  final void Function(int) onPageSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final cubit = AppCubit.of(context); // Not needed here
    double navbarWidth = MediaQuery.sizeOf(context).width * 0.9;

    final items = [
      {'icon': IconlyLight.home, 'index': 0},
      {'icon': IconlyLight.folder, 'index': 1},
      {'icon': IconlyLight.work, 'index': 2},
      {'icon': IconlyLight.profile, 'index': 3},
      {'icon': IconlyLight.user, 'index': 4},
      {'icon': IconlyLight.message, 'index': 5},
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            width: navbarWidth,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var item in items)
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      // final cubit = AppCubit.of(context); // Not needed
                      return IconButton(
                        // 🔥 FIX: Call the onPageSelected callback directly
                        onPressed: () => onPageSelected(item['index'] as int),
                        icon: Icon(
                          item['icon'] as IconData,
                          color: state.selectedPageIndex == item['index']
                              ? theme.colorScheme.primary
                              : theme.iconTheme.color,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
