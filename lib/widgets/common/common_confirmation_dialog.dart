
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_theme_colors.dart';



Future<bool?> showCommonConfirmationDialog(BuildContext context,{String string = "Are You Sure "}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: kIsWeb ? MediaQuery.of(context).size.width * .3 : MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 15),
                AppTextWidget.large(
                  "Confirmation",
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    children: [
                      TextSpan(text: string),
                      // TextSpan(
                      //   text: name, // Making only this bold
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.black, // Slightly darker color for emphasis
                      //   ),
                      // ),
                      const TextSpan(text: "?"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: AppTextWidget.medium("No",),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemeColors.buttonBgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:  AppTextWidget.medium(
                            "Yes",
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      );
    },
  );
}
