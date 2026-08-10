
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
    this.enabled = true, // <--- Add this new parameter, default to true
  });

  final String? labelText; // Use explicit types for clarity
  final String? hintText;
  final String? value; // Assuming value is a String ID
  final ValueChanged<String?>? onChanged; // Correct type for onChanged
  final List<dynamic>? items; // Assuming items is List of Map<String, dynamic>
  final String? Function(String?)? validator; // Correct type for validator
  final Widget? prefix;
  final bool enabled; // <--- The new enabled parameter

  @override
  State<DropdownFieldWidget> createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState extends State<DropdownFieldWidget> {

  // Helper method to determine the border color based on enabled state
  Color _getBorderColor() {
    if (!widget.enabled) {
      return Colors.grey; // Grey if disabled
    }
    // Default border color when enabled
    return Colors.black; // Or your primary app border color
  }


  @override
  Widget build(BuildContext context) {
    final Color currentBorderColor = _getBorderColor();

    final bool hasValueInItems = widget.items != null &&
        widget.items!.any((item) => item['id']?.toString() == widget.value?.toString());
    final String? safeValue = hasValueInItems ? widget.value : null;

    return DropdownButtonFormField<String>(
      isExpanded: true,
      validator: widget.validator,
      // --- Control onChanged based on enabled state ONLY ---
      onChanged: widget.enabled ? widget.onChanged : null, // Not clickable if disabled
      // --- ALWAYS provide items list ---
      items: widget.items?.map<DropdownMenuItem<String>>((valueMap) {
        return DropdownMenuItem<String>(
          value: valueMap['id']?.toString(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 50),
            child: AppTextWidget.medium(
                valueMap['name']?.toString() ?? '',
                maxLines: 2,
                color: !widget.enabled ? AppThemeColors.disableLabelColor : AppThemeColors.textPrimaryColor
            ),
          ),
        );
      }).toList(), // No longer conditional based on widget.enabled
      // --- END of items change ---

      dropdownColor: AppThemeColors.popupBackgroundColor,
      value: safeValue,
      elevation: 16,
      style: AppStyles.medium.copyWith(color: AppThemeColors.textPrimaryColor),
      decoration: InputDecoration(
        prefix: widget.prefix,
        labelStyle: !widget.enabled ? TextStyle(color: Colors.grey, fontSize: 14) : AppStyles.medium,
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorStyle: TextStyle(color: AppThemeColors.errorColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: currentBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: currentBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: !widget.enabled ? AppThemeColors.disableBorderColor : AppThemeColors.focusBorderColor)
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),

        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppThemeColors.errorBorderColor)
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
    );
  }
}

