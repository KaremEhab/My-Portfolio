import 'package:flutter/material.dart';
import 'package:my_portfolio/core/app/constants.dart';

class ThemeLanguageSwitcher extends StatelessWidget {
  final bool isDarkMode;
  final bool isEnglish;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<bool> onLanguageChanged;
  final bool isShrunk;

  const ThemeLanguageSwitcher({
    super.key,
    required this.isDarkMode,
    required this.isEnglish,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    this.isShrunk = false,
  });

  @override
  Widget build(BuildContext context) {
    // If shrunk, show icon-only buttons
    if (isShrunk) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => onThemeChanged(!isDarkMode),
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () => onLanguageChanged(!isEnglish),
          ),
        ],
      );
    }

    // Original (Full) Widget
    return Column(
      children: [
        _buildSwitcher(
          context,
          icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
          label: isDarkMode ? 'Dark' : 'Light',
          value: isDarkMode,
          onChanged: onThemeChanged,
        ),
        _buildSwitcher(
          context,
          icon: Icons.language,
          label: isEnglish ? 'English' : 'العربية',
          value: isEnglish,
          onChanged: onLanguageChanged,
        ),
      ],
    );
  }

  Widget _buildSwitcher(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? primaryText;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Transform.scale(
          scale: 0.9,
          child: Switch(
            value: value,
            activeColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.2),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
