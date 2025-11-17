import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/app/constants.dart';

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

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.focusNode, // ✅ added focusNode
    this.validatorMsg,
    this.isPassword = false,
    this.isConfirm = false,
    this.isDropdown = false,
    this.keyboardType = TextInputType.text,
    this.extraValidator,
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
      focusNode: widget.focusNode, // ✅ attach focus node
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      minLines: isMultiline ? 3 : 1,
      maxLines: isMultiline ? null : 1,
      textAlignVertical: isMultiline
          ? TextAlignVertical.top
          : TextAlignVertical.center,
      decoration: _buildInputDecoration(isMultiline),
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
