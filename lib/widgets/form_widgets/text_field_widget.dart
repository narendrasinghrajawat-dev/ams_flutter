import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../core/constants/text_styles.dart';



class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({super.key,this.controller, this.labelText, this.hintText, this.keyboardInputType, this.readOnly, this.initValue, this.suffixIcon,
    this.onTep, this.validator, this.onChanged, this.enabled = true, this.prefix});

  final labelText;
  final hintText;
  final controller;
  final keyboardInputType;
  final bool? readOnly;
  final initValue;
  final suffixIcon;
  final VoidCallback? onTep;
  final  validator;
  final onChanged;
  final enabled;
  final prefix;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
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
          // style: AppTextStyles.medium,
          style: !widget.enabled
              ? AppStyles.medium.copyWith(color: AppThemeColors.disableLabelColor) // Or whatever color you want for disabled text
              : AppStyles.medium,

          keyboardType: widget.keyboardInputType,
          readOnly: widget.readOnly ?? false,
          initialValue: widget.initValue,
          onTap: widget.onTep,
          onChanged: widget.onChanged,
          validator: widget.validator,

          decoration: InputDecoration(
            errorStyle: TextStyle(
              color: AppThemeColors.errorColor, // Set your desired color here
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppThemeColors.errorBorderColor)
            ),
            labelStyle: !widget.enabled ? TextStyle(color: AppThemeColors.disableLabelColor) :  AppStyles.medium,
            labelText: widget.labelText,
            hintText: widget.hintText,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: !widget.enabled ? AppThemeColors.disableBorderColor : Colors.black)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: !widget.enabled ? AppThemeColors.disableBorderColor : AppThemeColors.focusBorderColor)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: !widget.enabled ? AppThemeColors.disableBorderColor : AppThemeColors.enableBorderColor)
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14,horizontal: 10),
            prefix: widget.prefix,
            suffixIcon: widget.suffixIcon,
          )
      ),
    );
  }
}
