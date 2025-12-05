
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';

class AppRadioListTileFieldWidget extends StatelessWidget {
  const AppRadioListTileFieldWidget({
    super.key,
    required this.radioList,
    required this.radioId,
    this.onChanged,
    this.isColumn = false,
    this.validator,
    this.enabled = true, // ✅ Add isEnabled property, default to true
  });

  final List<dynamic> radioList;
  final String? radioId;
  final ValueChanged<String?>? onChanged;
  final bool isColumn;
  final String? Function(String?)? validator;
  final bool enabled; // ✅ Define the isEnabled property

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: radioId,
      validator: validator,
      builder: (FormFieldState<String> field) {
        final radioTiles = radioList.map<Widget>((item) {
          final String? itemId = item["id"]?.toString();
          final String itemName = item["name"]?.toString() ?? '';

          return RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: itemId!,
            groupValue: radioId,
            title: AppTextWidget.medium(
              itemName,
              color: enabled ? Colors.black : Colors.grey,
              maxLines: 2,
            ),
            // ✅ Control onChanged based on the isEnabled property
            onChanged: enabled
                ? (value) {
              onChanged?.call(value);
              field.didChange(value); // Update form field state
            }
                : null, // If isEnabled is false, onChanged is null, disabling the radio
            activeColor: AppThemeColors.iconActiveColor,
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isColumn
                ? Column(children: radioTiles)
                : Row(children: radioTiles.map((tile) => Expanded(child: tile)).toList()),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AppTextWidget.small(
                  field.errorText ?? '',
                ),
              ),
          ],
        );
      },
    );
  }
}
