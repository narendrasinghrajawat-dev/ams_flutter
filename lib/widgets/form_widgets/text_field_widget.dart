import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../core/constants/text_styles.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardInputType,
    this.readOnly,
    this.initValue,
    this.suffixIcon,
    this.onTep,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.prefix,
  });

  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardInputType;
  final bool? readOnly;
  final String? initValue;
  final Widget? suffixIcon;
  final VoidCallback? onTep;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final Widget? prefix;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeColors.isDark;
    final borderRadius = BorderRadius.circular(12);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: TextFormField(
        onTapOutside: (event) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        enabled: widget.enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        style: !widget.enabled
            ? AppStyles.medium.copyWith(color: AppThemeColors.disableLabelColor)
            : AppStyles.medium.copyWith(color: AppThemeColors.textPrimaryColor),
        keyboardType: widget.keyboardInputType,
        readOnly: widget.readOnly ?? false,
        initialValue: widget.initValue,
        onTap: widget.onTep,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          errorStyle: TextStyle(
            color: AppThemeColors.errorColor,
            fontSize: 12,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppThemeColors.errorBorderColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppThemeColors.errorBorderColor, width: 1.5),
          ),
          labelStyle: TextStyle(
            color: !widget.enabled
                ? AppThemeColors.disableLabelColor
                : AppThemeColors.textSecondaryColor,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: AppThemeColors.textHintColor,
            fontSize: 14,
          ),
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: !widget.enabled
                  ? AppThemeColors.disableBorderColor
                  : AppThemeColors.borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: !widget.enabled
                  ? AppThemeColors.disableBorderColor
                  : AppThemeColors.focusBorderColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: !widget.enabled
                  ? AppThemeColors.disableBorderColor
                  : AppThemeColors.enableBorderColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppThemeColors.disableBorderColor),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          prefixIcon: widget.prefix,
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
