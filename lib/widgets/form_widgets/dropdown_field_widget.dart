import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../core/constants/text_styles.dart';
import '../text_and_icon_widgets/app_text_type.dart';

class DropdownFieldWidget extends StatefulWidget {
  const DropdownFieldWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.value,
    this.onChanged,
    this.items,
    this.validator,
    this.prefix,
    this.enabled = true,
  });

  final String? labelText;
  final String? hintText;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<dynamic>? items;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final bool enabled;

  @override
  State<DropdownFieldWidget> createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState extends State<DropdownFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeColors.isDark;
    final borderRadius = BorderRadius.circular(12);

    final bool hasValueInItems = widget.items != null &&
        widget.items!.any((item) => item['id']?.toString() == widget.value?.toString());
    final String? safeValue = hasValueInItems ? widget.value : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        validator: widget.validator,
        onChanged: widget.enabled ? widget.onChanged : null,
        items: widget.items?.map<DropdownMenuItem<String>>((valueMap) {
          return DropdownMenuItem<String>(
            value: valueMap['id']?.toString(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 50),
              child: AppTextWidget.medium(
                valueMap['name']?.toString() ?? '',
                maxLines: 2,
                color: !widget.enabled
                    ? AppThemeColors.disableLabelColor
                    : AppThemeColors.textPrimaryColor,
              ),
            ),
          );
        }).toList(),
        dropdownColor: AppThemeColors.popupBackgroundColor,
        value: safeValue,
        elevation: 16,
        style: AppStyles.medium.copyWith(color: AppThemeColors.textPrimaryColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          prefixIcon: widget.prefix,
          labelStyle: TextStyle(
            color: !widget.enabled
                ? AppThemeColors.disableLabelColor
                : AppThemeColors.textSecondaryColor,
            fontSize: 14,
          ),
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppThemeColors.textHintColor, fontSize: 14),
          errorStyle: TextStyle(color: AppThemeColors.errorColor, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: !widget.enabled
                  ? AppThemeColors.disableBorderColor
                  : AppThemeColors.borderColor,
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
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: !widget.enabled
                  ? AppThemeColors.disableBorderColor
                  : AppThemeColors.focusBorderColor,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppThemeColors.disableBorderColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppThemeColors.errorBorderColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: AppThemeColors.errorBorderColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        ),
      ),
    );
  }
}
