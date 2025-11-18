import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_portfolio/core/app/constants.dart';
import 'package:my_portfolio/screens/layout.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final FocusNode? focusNode;
  final String? validatorMsg;
  final bool isPassword;
  final bool isConfirm;
  final bool isDropdown;
  final TextInputType keyboardType;
  final String? Function(String?)? extraValidator;
  final void Function(String)? onChanged; // ✅ added

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.focusNode,
    this.validatorMsg,
    this.isPassword = false,
    this.isConfirm = false,
    this.isDropdown = false,
    this.keyboardType = TextInputType.text,
    this.extraValidator,
    this.onChanged, // ✅ added
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isMultiline = widget.keyboardType == TextInputType.multiline;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      minLines: isMultiline ? 3 : 1,
      maxLines: isMultiline ? null : 1,
      textAlignVertical: isMultiline
          ? TextAlignVertical.top
          : TextAlignVertical.center,
      decoration: _buildInputDecoration(isMultiline),

      /// ✅ HERE — onChanged added
      onChanged: widget.onChanged,

      validator: (value) {
        if (widget.validatorMsg != null && (value == null || value.isEmpty)) {
          return widget.validatorMsg;
        }
        if (widget.extraValidator != null) return widget.extraValidator!(value);
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration(bool isMultiline) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
      prefixIcon: widget.isDropdown
          ? null
          : Padding(
              padding: EdgeInsets.only(
                bottom: isMultiline ? 53 : 0,
                left: 12,
                right: 8,
              ),
              child: Icon(widget.icon, size: 17),
            ),
      prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
      suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: iconGrey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : (widget.isDropdown ? Icon(widget.icon) : null),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoConnectionWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 120, color: secondaryText),
            const SizedBox(height: 24),
            const Text(
              'لا يوجد اتصال بالإنترنت حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'يرجى التحقق من الاتصال بشبكة الواي فاي أو تشغيل بيانات الهاتف.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: primaryText, height: 1.5),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      AppSettings.openAppSettings(type: AppSettingsType.wifi),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.wifi, color: screenBg),
                  label: const Text(
                    'فتح الواي فاي',
                    style: TextStyle(color: screenBg, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh, color: screenBg),
                    label: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(color: screenBg, fontSize: 16),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => AppSettings.openAppSettings(
                type: AppSettingsType.dataRoaming,
              ),
              icon: const Icon(Icons.network_cell, color: primaryColor),
              label: const Text(
                'فتح بيانات الهاتف',
                style: TextStyle(color: primaryColor, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple data model for search results — replace with your real data.
class _SearchItem {
  final String title;
  final String subtitle;
  final int pageIndex;
  const _SearchItem(this.title, this.subtitle, this.pageIndex);
}

/// Call this function to show the spotlight dialog.
/// initialQuery can be passed when opening from the sidebar input (single letter).
Future<void> showSpotlightSearch(
  BuildContext context, {
  String initialQuery = '',
}) async {
  // Prevent multiple dialogs stacking: check Navigator overlay entries
  // (We still keep a local guard in Sidebar but this is a safety net.)
  if (ModalRoute.of(context)?.isCurrent != true) return;

  // Example items — replace with your app pages / actions.
  final List<_SearchItem> allItems = const [
    _SearchItem('Home', 'Go to home', 0),
    _SearchItem('Projects', 'Open projects section', 1),
    _SearchItem('Skills', 'View skills', 2),
    _SearchItem('About Me', 'About Kareem', 3),
    _SearchItem('Testimonials', 'Read testimonials', 4),
    _SearchItem('Contact', 'Open contact page', 5),
    _SearchItem('Hire Me', 'Open hire me card', 999),
  ];

  final TextEditingController controller = TextEditingController(
    text: initialQuery,
  );
  List<_SearchItem> filtered = allItems
      .where(
        (i) =>
            i.title.toLowerCase().contains(initialQuery.toLowerCase()) ||
            i.subtitle.toLowerCase().contains(initialQuery.toLowerCase()),
      )
      .toList();

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Search',
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (ctx, a1, a2) {
      // pageBuilder must return a widget but transition will animate it.
      return const SizedBox.shrink();
    },
    transitionBuilder: (ctx, anim, secondaryAnim, child) {
      final curved = Curves.easeOut.transform(anim.value);
      return FadeTransition(
        opacity: anim,
        child: Transform.scale(
          scale: 0.98 + 0.02 * curved,
          child: GestureDetector(
            onTap: () {
              // absorb taps on backdrop through barrierDismissible
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Material(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.3),
                        elevation: 12,
                        borderRadius: BorderRadius.circular(14),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 760,
                            minWidth: 400,
                            maxHeight: 520,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: _SpotlightContent(
                              controller: controller,
                              initialItems: filtered,
                              allItems: allItems,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _SpotlightContent extends StatefulWidget {
  final TextEditingController controller;
  final List<_SearchItem> initialItems;
  final List<_SearchItem> allItems;
  const _SpotlightContent({
    required this.controller,
    required this.initialItems,
    required this.allItems,
  });

  @override
  State<_SpotlightContent> createState() => _SpotlightContentState();
}

class _SpotlightContentState extends State<_SpotlightContent> {
  late List<_SearchItem> results;
  final FocusNode _focus = FocusNode();
  int highlighted = 0;

  @override
  void initState() {
    super.initState();
    results = widget.initialItems;
    // Delay focus to let dialog animate in
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) FocusScope.of(context).requestFocus(_focus);
    });
    widget.controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onQueryChanged);
    _focus.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final q = widget.controller.text.trim().toLowerCase();
    setState(() {
      results = widget.allItems
          .where(
            (i) =>
                i.title.toLowerCase().contains(q) ||
                i.subtitle.toLowerCase().contains(q),
          )
          .toList();
      highlighted = 0;
    });
  }

  void _onSelect(_SearchItem item) {
    // TODO: wire this to your navigation/actions.
    // For example: Navigator.pop(context); then call widget to go to pageIndex.
    Navigator.of(context).pop();
    // You could use a callback or an event bus to navigate.
    // For now we just pop.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        Material(
          color: theme.colorScheme.surface.withOpacity(0.3),
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(IconlyLight.search),
              hintText: 'Search (press Esc to close)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            onSubmitted: (_) {
              if (results.isNotEmpty) _onSelect(results[0]);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Results box
        Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              child: results.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                        child: Text(
                          'No results',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: results.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                      itemBuilder: (ctx, idx) {
                        final r = results[idx];
                        final isHighlighted = idx == highlighted;
                        return InkWell(
                          onTap: () => _onSelect(r),
                          onHover: (h) {
                            if (h) {
                              setState(() => highlighted = idx);
                            }
                          },
                          child: Container(
                            color: isHighlighted
                                ? theme.focusColor.withOpacity(0.08)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: theme.colorScheme.primary
                                      .withOpacity(0.15),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.title,
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        r.subtitle,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  r.pageIndex == 999 ? '' : 'Go',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

void showMenuDialog(
  BuildContext context,
  Function(int) onPageSelected,
  int currentPageIndex,
) {
  showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildMenuItem(
                    context,
                    IconlyLight.home,
                    "Home",
                    0,
                    currentPageIndex,
                    onPageSelected,
                  ),
                  buildMenuItem(
                    context,
                    IconlyLight.work,
                    "Projects",
                    1,
                    currentPageIndex,
                    onPageSelected,
                  ),
                  buildMenuItem(
                    context,
                    Icons.code_rounded,
                    "Skills",
                    2,
                    currentPageIndex,
                    onPageSelected,
                  ),
                  buildMenuItem(
                    context,
                    IconlyLight.profile,
                    "About Me",
                    3,
                    currentPageIndex,
                    onPageSelected,
                  ),
                  buildMenuItem(
                    context,
                    IconlyLight.user,
                    "Testimonials",
                    4,
                    currentPageIndex,
                    onPageSelected,
                  ),
                  buildMenuItem(
                    context,
                    IconlyLight.message,
                    "Contact Me",
                    5,
                    currentPageIndex,
                    onPageSelected,
                  ),

                  const SizedBox(height: 15),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Language", style: theme.textTheme.bodyMedium),
                      Row(
                        children: [
                          _langButton(context, "العربية"),
                          const SizedBox(width: 8),
                          _langButton(context, "English", selected: true),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: theme.primaryColor.withOpacity(0.15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wb_sunny_outlined,
                            color: theme.iconTheme.color,
                          ),
                          const SizedBox(width: 8),
                          Text("Light Mode", style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildMenuItem(
  BuildContext context,
  IconData icon,
  String title,
  int index,
  int currentPageIndex,
  Function(int) onTap,
) {
  final bool selected = index == currentPageIndex;
  final theme = Theme.of(context);

  return InkWell(
    borderRadius: BorderRadius.circular(15),
    onTap: () {
      Navigator.pop(context);
      onTap(index);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: selected
            ? theme.primaryColor.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: selected
            ? Border.all(color: theme.primaryColor, width: 1)
            : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: selected ? theme.primaryColor : theme.iconTheme.color,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? theme.primaryColor
                  : theme.textTheme.bodyMedium!.color,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _langButton(BuildContext context, String text, {bool selected = false}) {
  final theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: selected
          ? theme.primaryColor.withOpacity(0.2)
          : theme.cardColor.withOpacity(0.2),
      border: Border.all(
        color: selected ? theme.primaryColor : Colors.white.withOpacity(0.15),
        width: 1,
      ),
    ),
    child: Text(text, style: theme.textTheme.bodyMedium),
  );
}

class MarqueeLoop extends StatefulWidget {
  final List<Widget> items;
  final double gap;
  final Duration speed;

  const MarqueeLoop({
    super.key,
    required this.items,
    this.gap = 50,
    this.speed = const Duration(seconds: 20),
  });

  @override
  State<MarqueeLoop> createState() => _MarqueeLoopState();
}

class _MarqueeLoopState extends State<MarqueeLoop>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _controller = AnimationController(vsync: this);

    _startScrolling();
  }

  void _startScrolling() {
    Future.delayed(const Duration(milliseconds: 300), () {
      double maxExtent = _scrollController.position.maxScrollExtent;

      _controller.repeat(period: widget.speed);
      _controller.addListener(() {
        if (_scrollController.hasClients) {
          double offset = (_controller.value * maxExtent).clamp(0, maxExtent);

          _scrollController.jumpTo(offset);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// duplication for infinite effect
    List<Widget> loopItems = [
      ...widget.items,
      SizedBox(width: widget.gap),
      ...widget.items,
    ];

    return SizedBox(
      height: 40,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: List.generate(loopItems.length, (i) {
              return Padding(
                padding: EdgeInsets.only(right: widget.gap),
                child: loopItems[i],
              );
            }),
          ),
        ],
      ),
    );
  }
}

Widget marqueeItem(String label) {
  return Row(
    children: [
      Icon(Icons.auto_awesome, size: 18, color: Colors.white),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
