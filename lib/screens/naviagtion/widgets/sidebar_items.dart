import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SidebarItems extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SidebarItems({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<SidebarItems> createState() => _SidebarItemsState();
}

class _SidebarItemsState extends State<SidebarItems> {
  // Sidebar items using Iconly Light for default
  final List<_SidebarItem> _items = const [
    _SidebarItem(
      lightIcon: IconlyLight.home,
      boldIcon: IconlyBold.home,
      label: 'Home',
    ),
    _SidebarItem(
      lightIcon: IconlyLight.folder,
      boldIcon: IconlyBold.folder,
      label: 'Projects',
    ),
    _SidebarItem(
      lightIcon: IconlyLight.work,
      boldIcon: IconlyBold.work,
      label: 'Skills',
    ),
    _SidebarItem(
      lightIcon: IconlyLight.profile,
      boldIcon: IconlyBold.profile,
      label: 'About Me',
    ),
    _SidebarItem(
      lightIcon: IconlyLight.user,
      boldIcon: IconlyBold.user_2,
      label: 'Testimonials',
    ),
    _SidebarItem(
      lightIcon: IconlyLight.message,
      boldIcon: IconlyBold.message,
      label: 'Contact Me',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    // Responsive sidebar width
    final sidebarWidth = width < 600 ? 70.0 : 250.0;

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final isSelected = widget.selectedIndex == index;

        return InkWell(
          onTap: () => widget.onItemSelected(index),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: sidebarWidth < 100
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  isSelected ? item.boldIcon : item.lightIcon,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withAlpha((0.6 * 255).round()),
                  size: 22,
                ),
                if (sidebarWidth >= 100) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: isSelected ? 15 : 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w300,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withAlpha((0.6 * 255).round()),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SidebarItem {
  final IconData lightIcon;
  final IconData boldIcon;
  final String label;

  const _SidebarItem({
    required this.lightIcon,
    required this.boldIcon,
    required this.label,
  });
}
